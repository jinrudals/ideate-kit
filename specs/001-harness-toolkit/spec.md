# Feature Specification: Harness System Concept Engineering Toolkit

**Feature Branch**: `001-harness-toolkit`
**Created**: 2026-04-28
**Status**: Draft
**Input**: User description: "AI-agnostic system concept engineering toolkit with 7-phase workflow (ideate, clarify, domain, architect, research, scaffold, handoff) that develops abstract ideas into concrete system architectures via file-based agent communication, then produces per-service specs consumable by speckit"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Develop Abstract Idea into System Vision (Priority: P1)

A user has a vague idea ("I want to build a food delivery platform") and runs `harness.ideate`. The agent engages in interactive dialogue to extract problem statement, target users, desired outcomes, and scope boundaries, then writes `system-vision.md` as a structured draft.

**Why this priority**: Without a concrete vision document, no subsequent phase can proceed. This is the entry point of the entire toolkit.

**Independent Test**: Can be fully tested by providing an abstract idea and verifying that `system-vision.md` is produced with all required sections filled, containing no unexplained placeholders.

**Acceptance Scenarios**:

1. **Given** an empty `.harness/memory/` directory, **When** user runs `harness.ideate` with "I want to build a food delivery platform", **Then** `.harness/memory/system-vision.md` is created with problem statement, target users, desired outcomes, scope boundaries, and open questions sections populated.
2. **Given** an existing `system-vision.md`, **When** user runs `harness.ideate` with a revised idea, **Then** the file is overwritten with the new vision.

---

### User Story 2 - Clarify Ambiguities in Vision (Priority: P1)

After ideate produces a vision draft, user runs `harness.clarify`. The agent reads `system-vision.md`, identifies ambiguous or underspecified areas, asks up to 5 targeted questions one at a time, and integrates answers back into the vision document.

**Why this priority**: Equal to ideate — a vision with unresolved ambiguities produces poor domain models and architecture decisions downstream.

**Independent Test**: Can be tested by providing a vision document with intentional ambiguities and verifying that clarify identifies them, asks relevant questions, and updates the document with resolved answers.

**Acceptance Scenarios**:

1. **Given** a `system-vision.md` with `[NEEDS CLARIFICATION]` markers, **When** user runs `harness.clarify`, **Then** the agent presents questions one at a time with recommended answers, and after user responds, updates `system-vision.md` with resolved content.
2. **Given** a `system-vision.md` with no ambiguities, **When** user runs `harness.clarify`, **Then** the agent reports that no clarification is needed.

---

### User Story 3 - Model Domain Boundaries (Priority: P2)

User runs `harness.domain` after vision is finalized. The agent reads `system-vision.md` and produces `domain-model.md` containing bounded contexts, core entities per context, context relationships, and ubiquitous language glossary.

**Why this priority**: Domain modeling is the foundation for architecture decisions but requires a finalized vision first.

**Independent Test**: Can be tested by providing a finalized vision and verifying that `domain-model.md` contains at least one bounded context with entities, relationships, and a glossary.

**Acceptance Scenarios**:

1. **Given** a finalized `system-vision.md` for a food delivery platform, **When** user runs `harness.domain`, **Then** `.harness/memory/domain-model.md` is created with bounded contexts (e.g., Order, Delivery, Restaurant, User), entities per context, and a context map showing relationships.
2. **Given** no `system-vision.md` exists, **When** user runs `harness.domain`, **Then** the agent errors with a message directing user to run `harness.ideate` first.

---

### User Story 4 - Decide System Architecture (Priority: P2)

User runs `harness.architect`. The agent reads vision + domain model and produces `system-architecture.md` with MSA/monolith/hybrid decision, service boundaries, communication patterns, and cross-cutting concerns (SSO, MQ, observability, etc.).

**Why this priority**: Architecture decisions depend on domain model and directly shape all subsequent phases.

**Independent Test**: Can be tested by providing vision + domain model and verifying that `system-architecture.md` contains an explicit architecture style decision with rationale, service list, and cross-cutting concerns.

**Acceptance Scenarios**:

1. **Given** `system-vision.md` and `domain-model.md` for a complex multi-domain system, **When** user runs `harness.architect`, **Then** `system-architecture.md` is created with MSA recommendation, service boundaries aligned to bounded contexts, communication patterns (sync/async), and cross-cutting concerns identified.
2. **Given** a simple single-domain system, **When** user runs `harness.architect`, **Then** `system-architecture.md` recommends monolith with modular boundaries and explains why MSA is unnecessary.

---

### User Story 5 - Research References and Infrastructure (Priority: P3)

User runs `harness.research`. The agent reads architecture and investigates similar systems, technology recommendations, and system-level infrastructure concepts.

**Why this priority**: Research enriches decisions but the system can proceed to scaffold with reasonable defaults without it.

**Independent Test**: Can be tested by providing an architecture document and verifying that `research-findings.md` contains reference systems, technology recommendations, and infrastructure concept explanations.

**Acceptance Scenarios**:

1. **Given** `system-architecture.md` specifying MSA with event-driven communication, **When** user runs `harness.research`, **Then** `research-findings.md` contains reference architectures, MQ technology comparison, and SSO/auth pattern recommendations.

---

### User Story 6 - Generate System Scaffold (Priority: P3)

User runs `harness.scaffold`. The agent reads all memory files and generates the physical project structure (directories, boilerplate configs).

**Why this priority**: Scaffold is a convenience — users could create directories manually, but automation ensures consistency with architecture decisions.

**Independent Test**: Can be tested by providing all memory files and verifying that the correct directory structure is created matching the architecture.

**Acceptance Scenarios**:

1. **Given** all memory files describing a 4-service MSA system, **When** user runs `harness.scaffold`, **Then** a directory structure is created with per-service directories, shared infrastructure config, and a root README.

---

### User Story 7 - Hand Off to speckit (Priority: P2)

User runs `harness.handoff`. The agent reads all memory files and produces per-service `spec.md` files in speckit-compatible format, ready to be consumed by `speckit.specify`.

**Why this priority**: This is the bridge to speckit — without it, the harness output has no actionable downstream consumer.

**Independent Test**: Can be tested by providing all memory files and verifying that each service gets a `spec.md` with user stories, functional requirements, and success criteria in speckit template format.

**Acceptance Scenarios**:

1. **Given** all memory files describing 4 services, **When** user runs `harness.handoff`, **Then** 4 `services/<name>/spec.md` files are created, each following speckit's spec template structure with service-specific requirements extracted from the system-level documents.
2. **Given** a monolith architecture, **When** user runs `harness.handoff`, **Then** a single `spec.md` is produced covering the entire system.

---

### User Story 8 - Install Harness into Any AI Tool (Priority: P1)

User runs `harness init --ai <agent-type>` in their project. The installer creates `.harness/` directory structure and deploys prompt files to the AI-specific location.

**Why this priority**: Without installation, no agent can run. AI-agnostic installation is a core design requirement.

**Independent Test**: Can be tested by running init with different AI types and verifying that prompts are deployed to the correct locations.

**Acceptance Scenarios**:

1. **Given** an empty project, **When** user runs `harness init --ai kiro-cli`, **Then** `.harness/` is created with templates and scripts, and `.kiro/prompts/harness.*.md` files are deployed.
2. **Given** an empty project, **When** user runs `harness init --ai cursor`, **Then** `.harness/` is created and `.cursor/rules/harness-*.mdc` files are deployed with proper frontmatter.
3. **Given** an empty project, **When** user runs `harness init --ai claude`, **Then** `.harness/` is created and prompt content is deployed to `CLAUDE.md`.

---

### Edge Cases

- What happens when user runs a phase out of order (e.g., `harness.domain` before `harness.ideate`)? → Agent MUST error with a message indicating which prerequisite phase to run first.
- What happens when `system-vision.md` exists but is incomplete (missing sections)? → `harness.clarify` MUST detect missing sections and include them in clarification questions.
- What happens when user wants to re-run a phase after downstream phases have already run? → Agent MUST warn that downstream artifacts may become stale and offer to continue or abort.
- What happens when the target project already has `.harness/` from a previous init? → Installer MUST detect existing installation and ask whether to overwrite or merge.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide 7 independent agent prompts (ideate, clarify, domain, architect, research, scaffold, handoff) that can be invoked separately.
- **FR-002**: Agents MUST communicate exclusively through files in `.harness/memory/` — no direct agent-to-agent communication.
- **FR-003**: Each agent MUST validate that its prerequisite memory files exist before proceeding, and error with actionable guidance if missing.
- **FR-004**: The `harness.clarify` agent MUST read `system-vision.md`, identify ambiguities using a structured taxonomy, and ask a maximum of 5 questions sequentially.
- **FR-005**: The `harness.handoff` agent MUST produce `spec.md` files compatible with speckit's spec template format.
- **FR-006**: The installer MUST support multiple AI agent types and deploy prompts to the correct AI-specific locations.
- **FR-007**: All templates MUST use placeholder tokens (e.g., `[SYSTEM_NAME]`) that agents replace with concrete values.
- **FR-008**: The `harness.architect` agent MUST explicitly decide and justify the architecture style (MSA, monolith, or hybrid) based on domain complexity.
- **FR-009**: The `harness.research` agent MUST investigate both reference systems (similar products) and system-level infrastructure concepts (SSO, MQ, observability, etc.).
- **FR-010**: The `harness.scaffold` agent MUST generate physical directory structures and boilerplate files consistent with the architecture decision.
- **FR-011**: Each agent prompt MUST include a `handoffs` section suggesting the logical next phase.
- **FR-012**: The system MUST be installable independently of speckit — no speckit dependency required.

### Key Entities

- **System Vision**: The concrete articulation of the user's abstract idea — problem, users, outcomes, scope. Stored as `system-vision.md`.
- **Domain Model**: Bounded contexts, entities, relationships, and ubiquitous language. Stored as `domain-model.md`.
- **System Architecture**: Architecture style decision, service boundaries, communication patterns, cross-cutting concerns. Stored as `system-architecture.md`.
- **Research Findings**: Reference systems, technology recommendations, infrastructure concept analysis. Stored as `research-findings.md`.
- **Service Spec**: Per-service specification in speckit-compatible format. Stored as `services/<name>/spec.md`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user with an abstract idea can produce a complete set of per-service specs ready for speckit in under 2 hours using the 7-phase workflow.
- **SC-002**: Each phase's output file is self-contained — readable and useful without running subsequent phases.
- **SC-003**: `harness init` successfully deploys to at least 3 different AI agent types (kiro-cli, cursor, claude).
- **SC-004**: `harness.handoff` output is directly consumable by `speckit.specify` without manual reformatting.
- **SC-005**: Running phases out of order produces clear error messages indicating the correct prerequisite phase.

## Assumptions

- Users have a shell environment (bash) available for running scripts.
- Users have an AI coding assistant installed (kiro-cli, cursor, claude, etc.) that can consume prompt files.
- speckit may or may not be installed in the target project — harness operates independently.
- The target project is either a new empty project or an existing project where `.harness/` does not yet exist.
- Internet access may not be available — `harness.research` MUST degrade gracefully to offline recommendations when web search is unavailable.
