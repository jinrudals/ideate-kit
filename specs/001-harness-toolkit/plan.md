# Implementation Plan: Harness System Concept Engineering Toolkit

**Branch**: `001-harness-toolkit` | **Date**: 2026-04-28 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-harness-toolkit/spec.md`

## Summary

AI-agnostic system concept engineering toolkit with 7-phase workflow (ideate → clarify → domain → architect → research → scaffold → handoff). Each phase is an independent AI agent prompt that communicates through files in `.harness/memory/`. The toolkit installs into any project and deploys prompts to the target AI's native format. Final output is per-service specs consumable by speckit.

## Technical Context

**Language/Version**: Bash 4.0+ (scripts), Markdown (prompts/templates)
**Primary Dependencies**: None (zero runtime dependencies — pure bash + markdown)
**Storage**: Filesystem (`.harness/memory/*.md` files)
**Testing**: bats (Bash Automated Testing System) for scripts, manual validation for prompts
**Target Platform**: Any POSIX-compatible system (Linux, macOS)
**Project Type**: CLI toolkit (installer + prompt package)
**Performance Goals**: N/A (human-interactive, not latency-sensitive)
**Constraints**: Zero external dependencies, offline-capable, AI-agnostic
**Scale/Scope**: Single user per project, systems with 1-20 services

## Constitution Check

*Constitution not yet ratified for this project. No gates to evaluate.*

N/A — Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-harness-toolkit/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (speckit.tasks)
```

### Source Code (repository root)

```text
src/
├── prompts/                        # AI-agnostic prompt sources
│   ├── harness.ideate.md           # Phase 1: abstract idea → vision draft
│   ├── harness.clarify.md          # Phase 2: resolve vision ambiguities
│   ├── harness.domain.md           # Phase 3: bounded contexts & domain model
│   ├── harness.architect.md        # Phase 4: system architecture decision
│   ├── harness.research.md         # Phase 5: references & infra research
│   ├── harness.scaffold.md         # Phase 6: project structure generation
│   └── harness.handoff.md          # Phase 7: per-service specs for speckit
├── templates/                      # Memory file templates (installed to .harness/templates/)
│   ├── system-vision-template.md
│   ├── domain-model-template.md
│   ├── system-architecture-template.md
│   └── service-handoff-template.md
└── scripts/
    └── bash/
        ├── common.sh              # Shared utilities
        ├── init.sh                # `harness init` entrypoint
        └── install-prompts.sh     # AI-specific prompt deployment
```

**Structure Decision**: Single project layout. No backend/frontend split — this is a pure CLI toolkit producing markdown artifacts. `src/` contains the distributable package contents.
