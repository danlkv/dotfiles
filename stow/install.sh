#!/usr/bin/env bash
# Stow-like installer: symlinks entries from <source-dir> into $HOME, and applies
# *.patch files (zero-context unified diffs) to their base file via `git apply
# --unidiff-zero`. Recurses into directories that already exist in $HOME so they
# merge instead of colliding; otherwise links the subtree as a whole. Re-runs are
# idempotent: existing correct symlinks and already-applied patches are skipped.
#
# Usage: ./install.sh [--on-collision=fail|skip|backup|overwrite] <source-dir>
#
#   fail       (default) abort on any collision
#   skip       log and leave the existing target untouched
#   backup     rename existing target to <dst>.bak.<timestamp> then install
#   overwrite  remove the existing target (file/symlink only) then install;
#              refuses to delete a real directory — use `backup` for that case

set -euo pipefail

on_collision=fail
src_root=

while [[ $# -gt 0 ]]; do
    case "$1" in
        --on-collision=*) on_collision="${1#*=}"; shift ;;
        --on-collision)   on_collision="${2:?missing value}"; shift 2 ;;
        -h|--help)        sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        --)               shift; break ;;
        -*)               echo "unknown flag: $1" >&2; exit 2 ;;
        *)                src_root="$1"; shift ;;
    esac
done

[[ -n "$src_root" ]] || { echo "usage: $0 [--on-collision=fail|skip|backup|overwrite] <source-dir>" >&2; exit 2; }
case "$on_collision" in
    fail|skip|backup|overwrite) ;;
    *) echo "invalid --on-collision: $on_collision" >&2; exit 2 ;;
esac

src_root="$(cd "$src_root" && pwd)"
dst_root="${HOME:?HOME not set}"

timestamp() { date +%Y%m%d-%H%M%S; }
git_apply() { (cd "$dst_root" && git apply "$@"); }

# Clears $dst per $on_collision policy and logs its own action on its own line.
# Returns:
#   0  caller may proceed (target is gone)
#   1  fatal collision (caller should propagate)
#   2  skip (target left in place; caller should not install)
resolve_collision() {
    local dst="$1" rel="$2" kind="$3"   # kind: "link" or "patch"
    case "$on_collision" in
        fail)
            echo "collision: $dst exists (use --on-collision=skip|backup|overwrite)" >&2
            return 1 ;;
        skip)
            echo "skip   $rel ($kind collision)"
            return 2 ;;
        backup)
            local backup_path="$dst.bak.$(timestamp)"
            mv "$dst" "$backup_path"
            echo "backup $rel → $backup_path"
            return 0 ;;
        overwrite)
            if [[ -d "$dst" && ! -L "$dst" ]]; then
                echo "collision: $dst is a real directory; refusing to overwrite (use --on-collision=backup)" >&2
                return 1
            fi
            rm -f "$dst"
            return 0 ;;
    esac
}

apply_patch() {
    local src="$1" rel="$2"
    local base_dst="$dst_root/$rel"
    mkdir -p "$(dirname "$base_dst")"
    [[ -e "$base_dst" ]] || : > "$base_dst"

    # Already applied?
    if git_apply --reverse --check --unidiff-zero "$src" 2>/dev/null; then
        echo "skip   $rel (already applied)"
        return
    fi
    # Doesn't apply cleanly → collision. (Symmetric role to [[ -e || -L ]] in link_path.)
    if ! git_apply --check --unidiff-zero "$src" 2>/dev/null; then
        local rc=0
        resolve_collision "$base_dst" "$rel" patch || rc=$?
        case "$rc" in
            0) ;;
            2) return 0 ;;
            *) return $rc ;;
        esac
        # Truncate so the zero-context patch (delta from /dev/null) applies trivially.
        : > "$base_dst"
    fi
    git_apply --unidiff-zero --whitespace=nowarn "$src"
    echo "patch  $rel"
}

link_path() {
    local src="$1" dst="$2" rel="$3"
    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$src" ]]; then
        echo "skip   $rel (already linked)"
        return
    fi
    if [[ -e "$dst" || -L "$dst" ]]; then
        local rc=0
        resolve_collision "$dst" "$rel" link || rc=$?
        case "$rc" in
            0) ;;
            2) return 0 ;;
            *) return $rc ;;
        esac
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "link   $rel"
}

stow() {
    local rel="$1"
    local src="$src_root${rel:+/$rel}"
    local dst="$dst_root${rel:+/$rel}"

    # stow's package-local ignore file is metadata, not content to install.
    [[ "$(basename "$rel")" == ".stow-local-ignore" ]] && return 0

    if [[ "$rel" == *.patch ]]; then
        apply_patch "$src" "${rel%.patch}"
        return
    fi

    # Both sides real directories → descend (merge). Also the bootstrap case:
    # rel="" hits this branch since src_root and HOME are both real directories.
    if [[ -d "$src" && ! -L "$src" && -d "$dst" && ! -L "$dst" ]]; then
        local -; shopt -s nullglob dotglob   # auto-restored on return
        local entry
        for entry in "$src"/*; do
            stow "${rel:+$rel/}$(basename "$entry")"
        done
        return
    fi

    link_path "$src" "$dst" "$rel"
}

stow ""
