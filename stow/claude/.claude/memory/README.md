# Memory authoring

User-scope memories for Claude sessions. `MEMORY.md` is the @-imported
index; this file is process — never loaded into sessions.

## Drafting rules

- Construction rules, not post-hoc checks: "write from X", never
  "check it reads like Y".
- Positive rules dominate; negative lists short and subordinate.
- Plain terms, each defined; definitions separate from examples.
- Examples minimal, canonical, invented.
- The reader is a future Claude with zero context. The entry must pass
  its own rules.
- Compact: hook-sized description, entry well under a screen.

## Operational

- Ask scope first: project (`~/.claude/projects/<dir>/memory/`) or
  user (here).
- Entry: `<name>.md` with frontmatter `name` + `description`.
- Index line in MEMORY.md: `- [Title](file.md) — hook`.
- Loading: append `@file.md` to the index line to load every session
  (rules); index-only is consulted on recall (reference). Choose
  deliberately — @-imports cost context in every session.
- Verify by replaying a task that previously triggered the failure in
  a fresh session; grade what it produces (artifacts, output, or both).
- On failure, patch the rule's generation procedure, not the observed
  symptom. One clause per leak is the failure mode.
- Files live in dotfiles (stow); one commit per memory, refinements
  amended (`--force-with-lease`).
- Add a before/after pair below when adding a memory.

## Before / after

Populate from transcripts, never synthesize: quote verbatim the
observed failure that motivated the memory (before) and the replay
result with the memory loaded (after). Session detail is fine here —
this file is the case-side archive and is never session-loaded.

**brevity** — unpopulated (predates this section).

**generalize-cases-address-readers** —
Before (session `1bb17afc`, no memory): test input
`gross $400k+; US average is ~$450–500k` copied from the source chat,
labeled "(from the broken session)"; commit example `"gross $400k,
average ~$450k"` — case values in durable artifacts.
After (session `30b0443d`, memory loaded): tests invented per
dimension — `costs $2 and $3`, `$2k–$3k`, `$ x $`, `$2^n$`, `\$`;
commit example `"costs $2 and $3"` — case appears only to confirm
the pattern covers it.
