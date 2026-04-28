# Tasks: Harness System Concept Engineering Toolkit

**Input**: Design documents from `/specs/001-harness-toolkit/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in spec. Test tasks omitted.

**Organization**: Tasks grouped by user story. P1 stories first (install, ideate, clarify), then P2 (domain, architect, handoff), then P3 (research, scaffold).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story (US1-US8)
- Exact file paths included

---

## Phase 1: Setup

**Purpose**: Repository structure and shared utilities

- [x] T001 Create directory structure: `src/prompts/`, `src/templates/`, `src/scripts/bash/`
- [x] T002 Create `src/scripts/bash/common.sh` with shared utilities (find_harness_dir, check_file_exists, json_output, error_exit)

---

## Phase 2: Foundational

**Purpose**: Core scripts that ALL prompts and the installer depend on

**⚠️ CRITICAL**: No prompt or installer work can begin until this phase is complete

- [x] T003 Create `src/scripts/bash/check-phase.sh` implementing the phase prerequisite contract per `contracts/phase-check-contract.md`
- [x] T004 Create `src/templates/system-vision-template.md` with placeholder tokens per data-model.md schema (System Name, Problem Statement, Target Users, Desired Outcomes, Core Value Proposition, Scope, Assumptions, Open Questions)
- [x] T005 [P] Create `src/templates/domain-model-template.md` with placeholder tokens per data-model.md schema (Bounded Contexts, Context Map, Ubiquitous Language)
- [x] T006 [P] Create `src/templates/system-architecture-template.md` with placeholder tokens per data-model.md schema (Architecture Style, Services, Cross-Cutting Concerns, Deployment Topology)
- [x] T007 [P] Create `src/templates/service-handoff-template.md` following speckit's spec-template.md format with harness-specific placeholders

**Checkpoint**: Foundation ready — prompt and installer implementation can begin

---

## Phase 3: User Story 8 - Install Harness into Any AI Tool (Priority: P1) 🎯 MVP

**Goal**: `harness init --ai <type>` creates `.harness/` and deploys prompts to AI-specific locations

**Independent Test**: Run `init.sh --ai kiro-cli` in an empty directory, verify `.harness/` structure and `.kiro/prompts/harness.*.md` files exist

### Implementation for User Story 8

- [x] T008 [US8] Create `src/scripts/bash/install-prompts.sh` with AI type → file path mapping (kiro-cli, cursor, claude, gemini, codex/opencode + extensible pattern from speckit's update-agent-context.sh)
- [x] T009 [US8] Create `src/scripts/bash/init.sh` entrypoint: parse `--ai <type>` and `--force` args, create `.harness/` structure, copy templates, copy scripts, call `install-prompts.sh`, write `init-options.json`
- [x] T010 [US8] Handle edge case: existing `.harness/` detection with overwrite/abort prompt (exit code 3 without `--force`)

**Checkpoint**: Installer works. Can install harness into any project for any supported AI type.

---

## Phase 4: User Story 1 - Develop Abstract Idea into System Vision (Priority: P1)

**Goal**: `harness.ideate` takes abstract idea, produces `system-vision.md` draft

**Independent Test**: Invoke ideate prompt with "I want to build a food delivery platform", verify `.harness/memory/system-vision.md` created with all template sections filled

### Implementation for User Story 1

- [x] T011 [US1] Create `src/prompts/harness.ideate.md` — prompt with: YAML frontmatter (description, handoffs to harness.clarify), prerequisite check (none required, just verify `.harness/` exists), parse user input, fill system-vision-template.md, write to `.harness/memory/system-vision.md`

**Checkpoint**: ideate produces a structured vision document from any abstract idea

---

## Phase 5: User Story 2 - Clarify Ambiguities in Vision (Priority: P1)

**Goal**: `harness.clarify` reads vision draft, asks up to 5 targeted questions, updates vision

**Independent Test**: Invoke clarify on a vision with intentional ambiguities, verify questions asked and vision updated

### Implementation for User Story 2

- [x] T012 [US2] Create `src/prompts/harness.clarify.md` — prompt with: YAML frontmatter (description, handoffs to harness.domain), prerequisite check (system-vision.md required via check-phase.sh), structured ambiguity scan taxonomy, sequential questioning loop (max 5, one at a time, with recommendations), integrate answers back into system-vision.md, report coverage summary

**Checkpoint**: ideate + clarify together produce a finalized, unambiguous vision document

---

## Phase 6: User Story 3 - Model Domain Boundaries (Priority: P2)

**Goal**: `harness.domain` reads finalized vision, produces `domain-model.md`

**Independent Test**: Invoke domain on a finalized vision, verify `domain-model.md` has bounded contexts, entities, context map, glossary

### Implementation for User Story 3

- [x] T013 [US3] Create `src/prompts/harness.domain.md` — prompt with: YAML frontmatter (description, handoffs to harness.architect), prerequisite check (system-vision.md required), extract actors/entities/processes from vision, identify bounded contexts, map entities to contexts, define context relationships, build ubiquitous language glossary, fill domain-model-template.md, write to `.harness/memory/domain-model.md`

**Checkpoint**: Domain model established with clear bounded contexts

---

## Phase 7: User Story 4 - Decide System Architecture (Priority: P2)

**Goal**: `harness.architect` reads vision + domain, produces `system-architecture.md`

**Independent Test**: Invoke architect on vision + domain model, verify architecture style decision with rationale, service list, communication patterns, cross-cutting concerns

### Implementation for User Story 4

- [x] T014 [US4] Create `src/prompts/harness.architect.md` — prompt with: YAML frontmatter (description, handoffs to harness.research), prerequisite check (system-vision.md + domain-model.md required), evaluate domain complexity for MSA/monolith/hybrid decision, map bounded contexts to services, define communication patterns (sync/async per service pair), identify cross-cutting concerns (SSO, MQ, observability, logging, etc.), fill system-architecture-template.md, write to `.harness/memory/system-architecture.md`

**Checkpoint**: Architecture decided with explicit rationale

---

## Phase 8: User Story 7 - Hand Off to speckit (Priority: P2)

**Goal**: `harness.handoff` reads all memory files, produces per-service `spec.md` in speckit format

**Independent Test**: Invoke handoff on complete memory files, verify `services/<name>/spec.md` files follow speckit spec-template.md format

### Implementation for User Story 7

- [x] T015 [US7] Create `src/prompts/harness.handoff.md` — prompt with: YAML frontmatter (description, no further handoffs — terminal phase), prerequisite check (vision + domain + architecture required), read all memory files, for each service in architecture: extract relevant bounded context, map domain entities to key entities, derive user stories from system vision scoped to service, derive functional requirements from context responsibilities + business rules, derive success criteria from system-level outcomes, fill service-handoff-template.md, write to `services/<name>/spec.md`. Handle monolith case (single spec.md).

**Checkpoint**: Per-service specs ready for speckit consumption

---

## Phase 9: User Story 5 - Research References and Infrastructure (Priority: P3)

**Goal**: `harness.research` reads architecture, produces `research-findings.md`

**Independent Test**: Invoke research on an architecture doc, verify findings contain reference systems, tech recommendations, infra concepts

### Implementation for User Story 5

- [x] T016 [US5] Create `src/prompts/harness.research.md` — prompt with: YAML frontmatter (description, handoffs to harness.scaffold), prerequisite check (system-architecture.md required), extract services and cross-cutting concerns from architecture, research similar systems/products, recommend technologies per service, analyze infrastructure concepts (SSO patterns, MQ options, observability stacks, etc.), degrade gracefully when offline (use agent's training knowledge), write to `.harness/memory/research-findings.md`

**Checkpoint**: Research enriches architecture decisions with concrete technology recommendations

---

## Phase 10: User Story 6 - Generate System Scaffold (Priority: P3)

**Goal**: `harness.scaffold` reads all memory files, generates project directory structure

**Independent Test**: Invoke scaffold on complete memory files, verify directory tree matches architecture

### Implementation for User Story 6

- [x] T017 [US6] Create `src/prompts/harness.scaffold.md` — prompt with: YAML frontmatter (description, handoffs to harness.handoff), prerequisite check (vision + domain + architecture required, research optional), read all memory files, generate directory structure (mono-repo or multi-repo per architecture), create per-service skeleton directories, create shared infrastructure config placeholders, generate root README.md with system overview, respect research findings for tech-specific boilerplate if available

**Checkpoint**: Physical project structure exists, ready for per-service development

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Documentation and validation across all prompts

- [x] T018 [P] Create `README.md` at repo root with: project description, phase overview, installation instructions, source structure
- [x] T019 [P] Validate all 7 prompts have consistent YAML frontmatter format (description, handoffs)
- [x] T020 Validate all prompts reference `check-phase.sh` with correct phase names per prerequisite matrix in `contracts/phase-check-contract.md`
- [x] T021 Run `quickstart.md` validation: execute full install + ideate flow in temp directory

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup
- **US8 Install (Phase 3)**: Depends on Foundational — BLOCKS manual testing of all prompts
- **US1 Ideate (Phase 4)**: Depends on Foundational (template + check-phase.sh)
- **US2 Clarify (Phase 5)**: Depends on Foundational
- **US3 Domain (Phase 6)**: Depends on Foundational
- **US4 Architect (Phase 7)**: Depends on Foundational
- **US7 Handoff (Phase 8)**: Depends on Foundational
- **US5 Research (Phase 9)**: Depends on Foundational
- **US6 Scaffold (Phase 10)**: Depends on Foundational
- **Polish (Phase 11)**: Depends on all prompts complete

### User Story Dependencies

- **US8 (Install)**: Independent — can start after Foundational
- **US1 (Ideate)**: Independent — can start after Foundational
- **US2 (Clarify)**: Independent — can start after Foundational
- **US3 (Domain)**: Independent — can start after Foundational
- **US4 (Architect)**: Independent — can start after Foundational
- **US7 (Handoff)**: Independent — can start after Foundational
- **US5 (Research)**: Independent — can start after Foundational
- **US6 (Scaffold)**: Independent — can start after Foundational

All prompts are independent files. Runtime dependencies (phase ordering) are enforced by `check-phase.sh`, not by build-time dependencies.

### Parallel Opportunities

- T005, T006, T007 can run in parallel (independent templates)
- After Foundational: ALL user story phases can run in parallel (each prompt is an independent file)
- T018, T019 can run in parallel

---

## Parallel Example: All P1 Stories

```
# After Foundational phase, launch all P1 stories simultaneously:
Task: T008-T010 (US8 Install)
Task: T011 (US1 Ideate)
Task: T012 (US2 Clarify)
```

---

## Implementation Strategy

### MVP First (Install + Ideate + Clarify)

1. Complete Phase 1: Setup (T001-T002)
2. Complete Phase 2: Foundational (T003-T007)
3. Complete Phase 3: US8 Install (T008-T010)
4. Complete Phase 4: US1 Ideate (T011)
5. Complete Phase 5: US2 Clarify (T012)
6. **STOP and VALIDATE**: Install harness in temp project, run ideate + clarify end-to-end
7. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add Install + Ideate + Clarify → Test end-to-end → **MVP!**
3. Add Domain + Architect → Test full concept-to-architecture flow
4. Add Handoff → Test speckit bridge → **Core complete**
5. Add Research + Scaffold → Full toolkit
6. Polish → Production ready

---

## Notes

- Each prompt file is self-contained — no cross-prompt imports
- Runtime phase ordering enforced by `check-phase.sh`, not file dependencies
- All prompts follow same structure: YAML frontmatter → prerequisite check → load context → execute → write output → report
- Templates use `[PLACEHOLDER]` tokens consistent with speckit convention
