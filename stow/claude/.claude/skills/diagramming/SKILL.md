---
name: diagramming
description: Use when designing or documenting a system whose state, multiplicity, or component lifetimes matter. Produces a snapshot-in-time diagram of state-nodes connected by typed edges. NOT for sequence/flow/event diagrams.
---

# Diagramming

A discipline for drawing **snapshots of state** — what exists at one instant and what references what — using a small, precise edge vocabulary. Output is either a PlantUML fence or an interactive HTML L1 file.

---

## The Snapshot Principle

A diagram answers one question:

> *"If you froze the system right now, what state exists and how does it reference itself?"*

No time, no flow, no events — just **what exists and what points at what at one instant**. Sequence diagrams, flow charts, and animations are different artifacts; this skill is not those.

Two refinements:

- **Strive for the most general snapshot.** Pick the typical steady-state moment, not a degenerate edge case. "Steady state with N connected clients, M requests in flight" beats "instant after boot, before anyone connects."
- **Multiple snapshots on one diagram are allowed** via the case-3 `.-.-.-` edge, which joins states that don't coexist in time. Use sparingly, when historical relationship matters more than co-existence.

---

## Modeling Procedure

1. **Pick the snapshot moment(s).** Name it explicitly ("steady state with ≥1 in-flight `/health` request"). Default to one moment; reach for a second (linked by `.-.-.-`) only when the relationship being shown spans lifetimes.
2. **List state-nodes.** Every variable, entity, request-in-flight, primitive value that exists at that moment. No shape decisions yet. No formal categories — a "state" is anything you'd name to describe the snapshot.
3. **For each related pair, classify the edge.**
   - First: multiplicity (1..1, 0..1, 1..N, N..1, N..M).
   - Then: lifecycle (cases 1A, 1B, 2, 2B, 3, or none).
4. **Render** as either a PUML fence (inline, low ceremony) or an HTML L1 file (interactive, when the reader benefits from rearranging).

Step 3 is where most modeling errors happen. The reference below makes it mechanical.

---

## Edge Semantics

### Layer 1 — Multiplicity

| Cardinality | PUML | Reads as |
|---|---|---|
| 1..1 | `A -- B` | A has one B; B has one A |
| 0..1 | `A o-- B` | A optionally has B |
| 1..N | `A --{ B` | A has many Bs |
| N..1 | `A }-- B` | many As share one B |
| N..M | `A }--{ B` | many As relate to many Bs |

(Direction is a real choice but not a structural one — see Principle 3 for the reading heuristic.)

### Layer 2 — Lifecycle (combines with multiplicity)

Brackets `[X---X]` denote the lifetime span of state X.

| Case | Lifetime bracket | Meaning | Notation |
|---|---|---|---|
| 1A | `[A---[B---A]---B]` | B born during A; B outlives A | `A ->- B` |
| 1B | `[A---[Bᵢ---A]---Bᵢ]` | many Bᵢ born during A, outlive A | `A -->-{ B` |
| 2  | `[A---[B---B]---A]` | B's lifetime fully inside A's | `A --\|>-- B` |
| 2B | analogous, many B inside A | many Bs all contained in A's lifetime | `A --\|>--{ B` |
| 3  | `[A---A]   [B---B]` | A and B never coexist | `A .-.->-.- B` |

**Combining rule:** lifecycle modifies the arrow *body*; multiplicity stays on the *ends* (`{`, `}`, `o`). When unsure of lifecycle, drop to Layer 1 — never invent.

**Lifecycle is about lifetime overlap, not ownership.** Case 2 (`--|>--`) means "B's lifetime is fully inside A's" — it makes no claim about who semantically owns whom. Multiple parents can independently nest the same child's lifetime; draw every such edge that holds.

---

## Principles

1. **Visual weight = scope.** Long-lived entities render large/bold (rectangles). Ephemeral states are mid-sized (cards). Primitives are small. Scale tells the reader what's stable vs. transient at a glance.

2. **Layout is part of the model.** Don't throw nodes at the canvas. Specific heuristics:
   - **No overlap.** Two nodes shouldn't share a grid cell or have bounding boxes that intersect. Check before writing positions.
   - **Long-lived entities anchor the periphery.** The most-connected ephemeral state sits between them; derived data sits below its source.
   - **For `A --{ B` (1..N), put A higher than B.** The "one" side goes up; the "many" side fans out below. This reads as the natural tree direction.
   - **Group 1..1 pairs tightly; let 1..N edges span wider.** 1..1 nodes are tuple-equivalent (Invariant 1), so they belong visually close; 1..N expresses divergence, so give the many side room to fan.
   - **Minimize edge crossings.**

3. **Pick the direction that answers the question.** Multiplicity edges encode both sides, but the rendering chooses a perspective. `/health }-- IP` says "each handler references this IP" (handler is the active state). `IP --{ /health` says "the IP spawns handlers" (true, useless). The crowfoot goes on the **active / changing** side that *acts on* the **borrowed / referenced** value.

4. **Practicality over completeness.** A structurally-valid edge can be inconsequential. Draw an edge only if it helps the reader understand the snapshot.

5. **Lifetime nesting is not exclusive.** Two unrelated parents can each have a case-2 lifetime claim over the same child. These are not duplicate edges — they're independent lifetime statements.

6. **Split a node when the same data carries contradictory multiplicities.** If `X -- Y` and a path implies `X --{ Y`, that's a real multiplicity contradiction — but it can mean the data exists in two distinct *states* (in-flight vs. persisted, draft vs. published, queued vs. delivered). Splitting one node into two resolves the contradiction structurally. The Invariant 2 multiplicity contradiction is the diagnostic. (Example 3: `payload submission` vs. `stored payload`.)

7. **Place constraints on the owning entity, not on the primitive key.** A uniqueness constraint like "one stored payload per user" lives on `User --|>-- stored` (1..1), not on `stored -- user_id` (1..1). Funneling the constraint through the entity prevents two paths to the constrained node (one via the key, one via the entity) from claiming different multiplicities.

---

## Invariants

A model violating an invariant is *wrong*, not just inelegant. The two invariants work as a pair: Invariant 1 is both an equivalence and a **normalization tool**; Invariant 2 defines validity in the normalized form.

### Invariant 1 — 1..1 chains/cycles ≡ tuples

A chain or cycle of pure 1..1 edges (`A -- B -- C -- D`) means every component co-occurs in exactly one instance with every other — no degree of freedom. **It is equivalent to a single tuple node** `X = (A, B, C, D)`. Components may physically live on different machines; logically they're one composite state.

**Use the equivalence two ways:**
- As a *modeling note* — don't auto-collapse. The expanded form may be the right choice (showing distributed components). Collapse only when the user asks to simplify.
- As a *normalization tool* for validating longer cycles against Invariant 2.

### Invariant 2 — multiplicity consistency (bidirectional edge semantics)

Simple edges carry **bidirectional** 1..1 semantics. `X -- Y` means both *"X has one Y"* and *"Y has one X."* A crowfoot overrides the forward direction (`X --{ Y` = "X has many Y") but the reverse stays 1..1 ("each Y has one X") unless explicitly marked otherwise.

**A model is invalid when two paths between the same node pair assert contradictory multiplicities.**

The minimum-form case is `X --{ Y -- X`:
- The crowfoot says "X has many Y."
- The simple edge `Y -- X`, read in reverse, says "X has one Y."
- Contradiction. The cycle is invalid by axiom.

**Validation via collapse.** Longer cycles reduce to this minimum form. Use Invariant 1 to collapse pure 1..1 chains inside the cycle, then check the residual shape:

> `A -- B -- C --{ D -- E -- A`
>
> Collapse `A -- B -- C` to tuple `X = (A, B, C)`; collapse `D -- E` to tuple `Y = (D, E)`. The original cycle becomes `X --{ Y -- X` — contradictory. **The original cycle is therefore invalid.**

Longer cycles through distinct multiplicity transitions are *valid*: `X --{ Y -- Z }-- F -- X` survives collapse — it expresses real structure (each X has many Ys, each Y pairs with one Z, each F has many Zs, each F pairs with one X). No path between the same pair asserts conflicting multiplicities.

---

## Validator & Truncator (built into the L1 template)

The L1 template ships with two live analyzers wired into a collapsible panel:

**Validator (Invariant 2 check).**
Collapses pure 1..1 chains into super-nodes (Invariant 1), then for each super-pair flags any direction with conflicting `1` vs `N` arity claims. Reports violations in the panel. *MVP scope:* catches direct same-pair contradictions after collapse; does NOT exhaustively check multi-hop path consistency. Manual review still warranted for converging structures.

**Truncator (transitivity-implied edges).**
For each Layer-1 edge `A — C`, looks for a 2-hop path `A → X → C` whose composed multiplicity matches. Composition rules: `1 ∘ 1 = 1`, `N ∘ anything = N`, `0..1` propagates unless absorbed by `N`. Skips Layer-2 (lifecycle) edges — lifecycle composition is ambiguous.

*Cycle-aware behavior.* The truncator does iterative cluster-aware removal: it removes only "safe" edges (whose implying path doesn't depend on other candidates), then re-evaluates. Edges that remain mutually implied at fixpoint form an Invariant 1 cluster (pure 1..1 cycle ≡ tuple); the truncator refuses to pick a victim and instead flags them as a collapse candidate.

In the UI, the "Hide redundant edges" toggle removes the safe candidates from the rendering; cycle-symmetry edges are dimmed but never hidden.

---

## Output Decision

> Prefer HTML L1 when the reader benefits from rearranging; PUML fence otherwise.

PUML fences (`plantuml-svg`) render inline in chat with zero ceremony — use them for quick design discussion. For interactive diagrams, copy `assets/html-l1-template.html` and paste data into its sentinel-bracketed block (see workflow below).

---

## Worked Examples

### Example 1 — small, Layer 1 only

Snapshot: a driver in their car on the road.

```plantuml-svg
card Car
card Driver
card Wheel
Driver -- Car
Car --{ Wheel
```

### Example 2 (simple) — minimum-viable GET, both layers

Snapshot: web server, one client, one `/health` request in flight.

```plantuml-svg
rectangle Server
rectangle Client
card "/health" as health
Server --|>--{ health
Client --|>-- health
```

Three nodes, two edges. Answers *"who runs this, for whom, and what's the lifetime."* Deliberately omits response data, IP, and concurrent-request multiplicity — those are refinements, not the base case. Practicality over completeness.

For the interactive version, paste `examples/example2-simple.js` into the template's data block. The Layer 2 toggle collapses to the bare multiplicity view (`Server --{ health`, `Client -- health`).

### Example 2 (full) — realistic, both layers

Snapshot: web server in steady state, one connected client with concurrent `/health` requests in flight.

**Layer 1 (multiplicity only):**

```plantuml-svg
rectangle Server
rectangle Client
card "/health" as health
card "response data" as response
card IP
Server --{ health
Client --{ health
health --{ response
health }-- IP
Client --{ response
Client -- IP
```

**Layer 2 (with lifecycle):**

```
Server --|>--{ health    ' handler's lifetime contained in server's (case 2B)
Client --|>--{ health    ' handler's lifetime also contained in client's (case 2B; lifetime nesting is not exclusive)
health ->- response      ' response is born during the handler but OUTLIVES it — sent over the wire, kept by client (case 1A)
Client --|>--{ response  ' client outlives each received response (case 2B)
health }-- IP            ' Layer-1: many handlers borrow the one IP primitive
Client -- IP             ' Layer-1: each client has one IP
```

**The lesson:** the same node (`/health`) has two valid lifetime-contains parents (Server, Client). Response data has different lifecycle relations to its two parents: born during `/health` and outlives it (case 1A from handler), but contained in Client's lifetime (case 2B from client). This is normal — lifetime nesting is per-parent. The IP node is a borrowed primitive: Layer 1 only, no lifecycle claim. Picking the right direction matters: `/health }-- IP` reads as "handler references IP" (useful), while `IP --{ /health` would read as "IP spawns handlers" (true, useless).

**Compare to the simple version above:** the full diagram has 6 edges and 5 nodes vs. 2 edges and 3 nodes. Each addition earns its place by answering a question the simple version can't (concurrency, what gets sent back, what identifies the caller). When those questions aren't on the table, ship the simple version.

### Example 3 — POST persists to DB (state-splitting + truncation)

Snapshot: client POSTs a payload for a `user_id`; server persists it to DB with the constraint *one stored payload per user*.

Key modeling moves the example teaches:

- **State split** — `payload submission` (in-flight body, N per user) and `stored payload` (persisted entry, 1 per user) are separate nodes. Same data, but different multiplicity claims to `user_id` would create an Invariant 2 contradiction in a unified node. Splitting resolves it.
- **Constraint on the entity** — the "one stored per user" uniqueness lives on `User --|>-- stored` (1..1), not on `stored -- user_id`. This routes all paths through `User` and avoids the multiplicity contradiction that a key-level constraint would create.
- **Truncator finds the shortcuts** — `POST }-- user_id` is transitively implied by `POST ← Client -- user_id` (composed forward 1, reverse N — matches). Iteratively, `submission }-- user_id` is then implied by `submission ← POST -- user_id`. Both flagged as removable; toggle "Hide redundant edges" simplifies the model to just `Client -- user_id` and `User -- user_id` as the primary holders.

See `examples/example3-post-persist.js` for the data; paste into the template to interact.

---

## The HTML L1 Template

`assets/html-l1-template.html` is a self-contained, single-file HTML scaffold:

- Draggable nodes on a 40px grid, center-snapped.
- SVG edges that re-route live; multiplicity end-markers (crow's foot, optional-circle) and lifecycle midline markers (filled triangle = contains, open chevron with line-break = outlives, dashed line + chevron = historic).
- Top-of-canvas toggle to hide/show Layer 2 (lifecycle), reducing the view to pure multiplicity on demand.
- Dark-mode aware via `prefers-color-scheme`; SVG uses `currentColor` so strokes follow theme.
- Edit surface is just the `nodes` and `edges` arrays at the top of the inline script.

**Workflow (when producing an L1 diagram):**

1. Copy `assets/html-l1-template.html` to the destination (e.g. `/tmp/<topic>.html` or next to a spec).
2. In the copy, the **only** editable region is the block between `// DIAGRAM DATA` and `// END DIAGRAM DATA` sentinel comments. Inside that block, set:
   - `DIAGRAM_TITLE` — drives both `<title>` and the on-canvas header at startup.
   - `nodes` — `{ id, label, shape: 'rect' | 'card', cx, cy }`. `cx, cy` are *centers* on the 40px grid.
   - `edges` — `{ from, to, mult: '1..1' | '1..N' | 'N..1' | '0..1' | 'N..M', lifecycle: null | 'contains' | 'outlives' | 'historic' }`.
3. Open in a browser. The template provides:
   - **Drag-to-rearrange** with center-snap.
   - **Pan** (drag on empty canvas) and **zoom** (mouse wheel, cursor-anchored).
   - **Show lifecycle (Layer 2)** toggle — collapse to pure multiplicity.
   - **Hide redundant edges** toggle — fires the transitivity truncator.
   - **Live validator** — reports Invariant 2 violations + lists transitively-implied edges and any cycle-symmetry clusters.

Do not edit the rendering, validator, or truncator JS unless extending the skill itself — the data block is the entire editable surface.

**Reference examples** live as data-only `.js` files in `examples/`. To use one, paste its contents into the template's data block:
- `examples/example2-simple.js` — 3-node minimum-viable GET.
- `examples/example2-server-health.js` — 5-node, 6-edge full GET with concurrency, IP, response data.
- `examples/example3-post-persist.js` — 8-node POST with state-splitting (`payload submission` vs. `stored payload`), constraint-on-entity (`User --|>-- stored`), and truncator-removable shortcuts.

The examples are data only; the rendering logic lives entirely in the template, so a single template update propagates to every instantiation.

---

---

## When this skill applies

- Designing a new system and clarifying which states exist and how they relate.
- Documenting an existing system's state model (post-hoc).
- Discussing ambiguous lifetime/ownership questions during review.

## When it doesn't

- Sequence of events, request/response flows, message ordering → sequence diagram.
- Decision branches, control flow → flowchart.
- Component-by-time evolution → use L2 (stepper) — out of scope for v1.
