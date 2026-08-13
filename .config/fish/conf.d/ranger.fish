# Quit ranger into the directory it was left in.
# ranger --choosedir writes that path on exit; the shell cds there afterwards,
# since a child process cannot change its parent's pwd.
function ranger-cd --description "Run ranger, cd to the directory it exits in"
    set -l dir (mktemp -t ranger_cd.XXXXXX)
    ranger --choosedir=$dir $argv
    set -l chosen (cat $dir)
    rm -f $dir
    # Empty when ranger was killed before writing; cd would fall back to $HOME.
    if test -n "$chosen" -a "$chosen" != (pwd)
        cd $chosen
    end
    commandline -f repaint
end

# Safe to bind here even though config.fish calls fish_vi_key_bindings later:
# that erases preset bindings only (bind --erase --all --preset), not user ones.
if status is-interactive
    bind -M insert \co ranger-cd
    bind -M default \co ranger-cd
    abbr --add ra ranger-cd
end
