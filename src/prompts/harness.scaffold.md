---
description: Generate the physical project structure based on architecture and research findings.
handoffs:
  - label: Hand Off to speckit
    agent: harness.handoff
    prompt: Generate per-service specs for speckit
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Create the physical directory structure and boilerplate files for the system.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh scaffold --json` and parse JSON. If not ready, report missing prerequisites.

### Execution

2. Load all available memory files:
   - `.harness/memory/system-vision.md` (required)
   - `.harness/memory/domain-model.md` (required)
   - `.harness/memory/system-architecture.md` (required)
   - `.harness/memory/research-findings.md` (optional — enhances tech-specific boilerplate)

3. Determine repository layout from architecture style:
   - **Monolith**: Single project root with modular directories per bounded context
   - **MSA**: Per-service directories at root, plus shared infrastructure directory
   - **Hybrid**: Single project root with clear module boundaries and defined seams

4. For each service/module, create:
   - Source directory skeleton (language-appropriate if research findings available)
   - README.md with service name, responsibility, and bounded context reference
   - Placeholder for configuration

5. Create shared infrastructure:
   - Root README.md with system overview (name, description, architecture style, service list)
   - Shared configuration directory (if cross-cutting concerns exist)
   - Docker/compose skeleton (if deployment topology suggests containers)

6. Report:
   - Directory tree created
   - Files generated per service
   - Suggest `harness.handoff` as next step.

## Guidelines

- Generate minimal but useful boilerplate — enough to start, not so much it needs cleanup.
- README files are the most valuable scaffold output — they document intent.
- If research findings are unavailable, create language-agnostic directory structures.
- Do not generate application code — that's speckit's job.
