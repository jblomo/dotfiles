# AGENTS.md

## Purpose
This project uses **AI-native development**: features start as natural language → become formal specs (ADR + CUE/Zod) → are implemented in verifiable, functional code → and must pass automated checks before deploy.

Agents should follow this workflow; only bypass with explicit user direction.

See: [adr.github.io](https://adr.github.io/) for ADR background, [MADR](https://adr.github.io/madr/) for the Markdown template, and [agents.md](https://agents.md) for this convention.

---

## Development Loop

1. **Intent**
   - New functionality begins as an **Architectural Decision Record** (`doc/adr/NNNN-title.md`).
   - Include context, decision, consequences, and CUE/Zod snippets for constraints.

2. **Spec**
   - For changes that require new data abstractions, API shapes, ORM classes, etc, create a reference CUE spec.
   - CUE files live under `/spec/`.
   - Corresponding Zod schemas live in `/src/io/`.
   - Specs must be reviewed/accepted before code is generated.

3. **Code**
  - Prefer a strongly functional style, especially in core logic. inspired by references in this doc.
  - Declare types at module and function boundaries and public APIs.
    - Encourage structural typing: write logic against common protocols or interface
    - Prefer `TypedDict` or `Protocol` for map-like structures instead of scattering one-off Pydantic models
    - In TypeScript, use discriminated unions and `strict` mode; validate inputs once with a schema (e.g. Zod).
  - Prefer helper functions like toolz (get_in, assoc, merge) or JSONPath/JMESPath or fp-ts, a library for typed functional programming.
  - Prefer list comprehensions or concise `map` calls to unweildly `for` loops
  - Prefer immutable or persistent-style updates when practical (`toolz`, `pyrsistent`, or spreading objects in TS) to keep code predictable.
  - Prefer minimal number of required libraries; avoid introducing overlapping utility libraries unless there’s clear benefit (eg 50% code reduction).
  - Follow the project’s existing formatting/linting (e.g. Black/ruff for Python, Prettier/eslint for TypeScript).
  - Isolate and track side effects. For example:
    - Side-effects live in `/src/io/` and must be wrapped in Zod validation + OpenTelemetry tracing.
    - Follow [fp-ts](https://gcanti.github.io/fp-ts/) style for effect management.

6. **Verification**
   - Prefer building verification tasks, for example `npm run verify`:
     - `cue vet` (CUE constraints)
     - `tsc --noEmit`
     - `npx vitest` (unit/property/metamorphic tests)
     - `npm run fuzz` (fuzz/adversarial tests)
     - `npm run gallery` (render UX gallery for human review)

7. **Review**
   - When human feedback is given, consider if updates are required to ADRs/specs/tests and recommending doing those first to verify human intent.
   - With appropriate updates to ADRs/specs/tests, then iterate on code.

8. **Deploy**
   - Only “Accepted” ADRs with passing verification may be deployed.
   - Deploy via `sandbox/docker-dev.sh` or `kappa-deploy`.

---

## Architecture Defaults

- **Kappa architecture**: all state derived from immutable event streams ([kappa](https://www.oreilly.com/radar/questioning-the-lambda-architecture/)).
- **Contract-first APIs**: partner/internal endpoints are generated from specs.
- **Observability by default**: traces/metrics tied to spec IDs.

---

## Conventions

- ADRs: `doc/adr/NNNN-title.md` using [MADR](https://adr.github.io/madr/).
- Specs: `/spec/*.cue` (constraints), `/src/io/schema.ts` (Zod).
- Tests: `/tests/*.spec.ts` include property + metamorphic + fuzz.
- Gallery: `/scripts/gallery.ts` renders behaviour for review.
- AGENTS.md: keep updated if process or tooling changes.

---

## Human Feedback Loop

- Gallery feedback is structured and versioned.
- Use `ai-spec update` to apply feedback → regenerate ADR/spec/tests.
- Never “patch silently”: changes must go through ADR or Spec update.

---

## References
- [Architectural Decision Records](https://adr.github.io/)  
- [MADR Template](https://adr.github.io/madr/)  
- [CUE language](https://cuelang.org/)  
- [Zod validation](https://zod.dev/)  
- [Property-based testing](https://fast-check.dev/)  
- [Functional core, imperative shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell)  
- [Kappa architecture](https://www.oreilly.com/radar/questioning-the-lambda-architecture/)  
- [Agents.md convention](https://agents.md)  

---

**Reminder for agents:**  
Always align implementation with the **specs and ADRs**. Do not generate code without a corresponding accepted decision record and verifiable constraints.
