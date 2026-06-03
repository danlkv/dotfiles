// Example 3 — POST persists to DB. 8 nodes, 11 edges. Demonstrates:
//   - state splitting (payload submission vs. stored payload — same data,
//     different multiplicity claims would create an Invariant 2 contradiction
//     in a unified node)
//   - constraint on the owning entity (User --|>-- stored carries the
//     "one stored per user" rule; routing all paths through User avoids
//     multiplicity contradictions a key-level constraint would create)
//   - truncator suggestions (POST }-- uid and submission }-- uid are
//     transitively implied through Client -- uid; they're flagged
//     removable by the panel)
//
// Layout: long-lived entities Server, Client, DB share the top row (DB above
// User per the 1..N "A higher than B" hint). user_id raised toward Client
// (1..1 tight). POST and its in-flight submission stack vertically on the
// right (1..1 close). stored payload tucked tight below User (1..1) and
// above submission (per N..1: stored is the "one" side).

const DIAGRAM_TITLE = "Snapshot: client POSTs a payload for a user_id; server persists it to DB";
const nodes = [
  // Top row: three long-lived entities (DB above User per the 1..N hint).
  { id: 'server',     label: 'Server',             shape: 'rect', cx: 200, cy: 200 },
  { id: 'client',     label: 'Client',             shape: 'rect', cx: 840, cy: 200 },
  { id: 'db',         label: 'DB',                 shape: 'rect', cx: 520, cy: 200 },
  // user_id raised toward Client (1..1 tight) and above the N..1 "many" side.
  { id: 'uid',        label: 'user_id',            shape: 'card', cx: 760, cy: 240 },
  // User entity sits directly under DB.
  { id: 'user',       label: 'User',               shape: 'rect', cx: 520, cy: 320 },
  // stored tight below User (1..1) and above submission (N..1 hint).
  { id: 'stored',     label: 'stored payload',     shape: 'card', cx: 480, cy: 400 },
  // POST handler in the right column.
  { id: 'post',       label: 'POST',               shape: 'card', cx: 640, cy: 440 },
  // submission tight below POST (1..1 contained, 80px apart).
  { id: 'submission', label: 'payload submission', shape: 'card', cx: 640, cy: 520 },
];
const edges = [
  // Server contains many concurrent POST handlers.
  { from: 'server',     to: 'post',       mult: '1..N', lifecycle: 'contains' },
  // Client can have many concurrent POSTs in flight; each handler dies before client moves on.
  { from: 'client',     to: 'post',       mult: '1..N', lifecycle: 'contains' },
  // Each POST holds one in-flight submission (dies with the handler).
  { from: 'post',       to: 'submission', mult: '1..1', lifecycle: 'contains' },
  // Client briefly held each submission before send; submissions die with handlers, client outlives.
  { from: 'client',     to: 'submission', mult: '1..N', lifecycle: 'contains' },
  // DB contains the long-lived User entity (1..N: DB above User).
  { from: 'db',         to: 'user',       mult: '1..N', lifecycle: 'contains' },
  // The uniqueness constraint: each User has exactly one stored payload.
  { from: 'user',       to: 'stored',     mult: '1..1', lifecycle: 'contains' },
  // user_id is User's primitive identity.
  { from: 'user',       to: 'uid',        mult: '1..1', lifecycle: null },
  // Each client identifies as one user.
  { from: 'client',     to: 'uid',        mult: '1..1', lifecycle: null },
  // Each POST is for one user_id; many concurrent POSTs share it.
  { from: 'post',       to: 'uid',        mult: 'N..1', lifecycle: null },
  // Each submission carries one user_id; many concurrent submissions share it (the racing fact).
  { from: 'submission', to: 'uid',        mult: 'N..1', lifecycle: null },
  // Many submissions converge on the one stored payload; stored outlives each (case 1A).
  { from: 'submission', to: 'stored',     mult: 'N..1', lifecycle: 'outlives' },
];
