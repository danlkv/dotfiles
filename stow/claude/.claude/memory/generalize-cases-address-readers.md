---
name: generalize-cases-address-readers
description: Treat concrete inputs as evidence of a pattern, not as the
  spec. Write artifacts to their reader's context, not the conversation.
---

**Definitions.**
- *Case* — a concrete input standing in for something general: bug
  repro, log excerpt, error string, user-given example, quoted text,
  reference design.
  Example: `500 at 03:14 UTC from IP 10.0.4.7`.
- *Pattern* — the general behavior or intent the case exemplifies.
  Example: `requests missing Authorization return 500`.
- *Reader* — whoever consumes an artifact.
  Example: your dialogue partner (for a chat reply); a future
  developer skimming git log (for a commit).

**Reasoning rule.** A case is evidence of a pattern, not the
specification. Before designing or validating, state the pattern in
one sentence — the sentence itself must resolve without knowledge
of the case. If you can't, generalize until you can. Design against
the pattern. Construct tests from the pattern: enumerate its
dimensions and invent one input per dimension cell — positive,
negative, boundary; an input that covers no new cell is redundant.
Invented values are minimal and canonical — the smallest numbers and
plainest names that exercise the cell; realistic-looking values drift
back toward the case. The case's role ends at confirming the pattern
covers it; it does not become a test input.

**Writing rule.** Artifacts are written from the pattern, never from
the case — the case's only output is the pattern extracted in the
reasoning step. State the reader in one line: who they are and what
context they hold. Then:
- *Details* (test inputs, examples, identifiers): invent each from
  the pattern, with minimal canonical values.
- *References* the reader already holds (ticket link for a team
  reader) may be included; each must resolve in the reader's context
  alone.
- *Moves* (explanations, contrasts, justifications): respond to
  nothing from the conversation. No rebutting proposals the reader
  never saw; explain contested choices from the reader's zero state.

**Reader contexts.**
- Public / durable (commits, production code, docs, memory entries):
  reader shares nothing — only the pattern resolves.
- Team (PR descriptions, wikis): shared anchors (ticket links, repro
  paths) also resolve.
- Conversation (chat replies, scratch notes): the dialogue partner
  shares everything; case detail is fine.

**When to ask.** If case-specific material (URL, transcript snippet,
"a tempting alternative" explainer) seems valuable to a reader who
doesn't obviously hold it, ask before including. Never by default.
