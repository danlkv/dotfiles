// Example 2 (simple) — minimum-viable GET, 3 nodes, 2 edges.
// Snapshot: web server, one client, one /health in flight.
// Layout: Server is the 1..N parent (top-left). Client is the 1..1 partner —
// pulled in closer to /health than Server is, so the tight 1..1 edge reads
// shorter than the loose 1..N.

const DIAGRAM_TITLE = "Snapshot (simple): server, one client, one /health in flight";
const nodes = [
  { id: 'server', label: 'Server',  shape: 'rect', cx: 240, cy: 200 },
  { id: 'client', label: 'Client',  shape: 'rect', cx: 760, cy: 200 },
  { id: 'health', label: '/health', shape: 'card', cx: 640, cy: 360 },
];
const edges = [
  // Server handles many concurrent /health (case 2B: handler dies before server).
  { from: 'server', to: 'health', mult: '1..N', lifecycle: 'contains' },
  // One client has one /health in flight at this snapshot.
  { from: 'client', to: 'health', mult: '1..1', lifecycle: 'contains' },
];
