// Example 2 (full) — realistic GET with concurrency, 5 nodes, 6 edges.
// Demonstrates non-exclusive lifetime nesting (the handler is case-2-contained
// in BOTH Server and Client) and direction-choice on borrowed primitives
// (/health }-- IP, not IP --{ /health).
//
// Layout choices keyed to the heuristics:
//   - Long-lived entities (Server, Client) anchor the top corners.
//   - IP is the "one" side of N..1 with /health AND the 1..1 partner of Client,
//     so it sits raised toward Client — above /health, tight to Client.
//   - response data is /health's case-1A outlives target — placed tight below
//     /health (1..1 group close).

const DIAGRAM_TITLE = "Snapshot: server steady-state, one client, one /health in flight";
const nodes = [
  { id: 'server',   label: 'Server',        shape: 'rect', cx: 200, cy: 160 },
  { id: 'client',   label: 'Client',        shape: 'rect', cx: 840, cy: 160 },
  // IP raised toward Client.
  { id: 'ip',       label: 'IP',            shape: 'card', cx: 760, cy: 280 },
  // In-flight handler below the entity row, slightly left of center.
  { id: 'health',   label: '/health',       shape: 'card', cx: 480, cy: 400 },
  // response tucked tight below /health (1..1 with health; 1..N from client, looser).
  { id: 'response', label: 'response data', shape: 'card', cx: 560, cy: 520 },
];
const edges = [
  { from: 'server', to: 'health',   mult: '1..N', lifecycle: 'contains' },
  { from: 'client', to: 'health',   mult: '1..N', lifecycle: 'contains' },
  // response is born inside the handler but outlives it (sent over the wire, kept by client).
  { from: 'health', to: 'response', mult: '1..1', lifecycle: 'outlives' },
  // /health is the active state borrowing the IP; many concurrent handlers reference one IP.
  { from: 'health', to: 'ip',       mult: 'N..1', lifecycle: null },
  // Client outlives each received response (case 2B: many responses contained in client's lifetime).
  { from: 'client', to: 'response', mult: '1..N', lifecycle: 'contains' },
  { from: 'client', to: 'ip',       mult: '1..1', lifecycle: null },
];
