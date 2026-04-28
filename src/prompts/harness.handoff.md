---
description: Generate per-service specification files in speckit-compatible format for downstream development.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Produce per-service `spec.md` files that are directly consumable by `speckit.specify`, bridging harness output to speckit input.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh handoff --json` and parse JSON. If not ready, report missing prerequisites.

### Execution

2. Load all memory files:
   - `.harness/memory/system-vision.md` (required)
   - `.harness/memory/domain-model.md` (required)
   - `.harness/memory/system-architecture.md` (required)
   - `.harness/memory/research-findings.md` (optional)

3. Load `.harness/templates/service-handoff-template.md`.

4. For each service in `system-architecture.md`:

   a. **Extract service scope**:
      - Service name and bounded context from architecture
      - Responsibilities from architecture
      - Core entities from domain model (filtered to this context)
      - Business rules from domain model (filtered to this context)

   b. **Generate User Stories**:
      - Derive from system vision's desired outcomes, scoped to this service
      - Each story must be independently testable
      - Assign priorities (P1 = core service responsibility, P2 = integration, P3 = enhancement)
      - Include acceptance scenarios in Given/When/Then format

   c. **Generate Functional Requirements**:
      - From bounded context responsibilities → FR items
      - From business rules → FR items with MUST language
      - From cross-cutting concerns that affect this service → FR items
      - Mark any that need service-level clarification as `[NEEDS CLARIFICATION]`

   d. **Generate Key Entities**:
      - From domain model entities for this context
      - Include attributes and relationships

   e. **Generate Success Criteria**:
      - Derive from system-level outcomes, scoped to this service's contribution
      - Must be measurable and technology-agnostic

   f. **Generate Assumptions**:
      - From system-level assumptions relevant to this service
      - Add inter-service dependency assumptions

   g. Fill `service-handoff-template.md` and write to `services/<service-name>/spec.md`.

5. **Handle monolith case**: If architecture style is monolith, produce a single `spec.md` covering the entire system rather than per-service files.

6. Report:
   - Number of service specs generated
   - Per-service: name, story count, requirement count, entity count
   - Any `[NEEDS CLARIFICATION]` markers
   - Suggest: "Each service spec is ready for speckit. Run `speckit.specify` in each service directory to begin per-service development."

## Guidelines

- Output MUST follow speckit's spec template format exactly — this is the contract.
- Each spec must be self-contained — readable without the harness memory files.
- Inter-service dependencies should appear as assumptions, not requirements.
- Keep specs focused on WHAT the service does, not HOW (no tech stack in specs).
