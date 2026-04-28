# Harness — System Concept Engineering Toolkit

AI-agnostic toolkit that develops abstract ideas into concrete system architectures, then hands off to per-service development tools like [speckit](https://github.com/speckit).

## Where It Sits

```
User's abstract idea
       │
   ┌────────┐
   │ HARNESS │  system-level concept engineering
   └────┬───┘
        │  per-service specs
   ┌────────┐
   │ SPECKIT │  per-service feature development
   └────────┘
```

## Phases

Agents communicate exclusively through files in `.harness/memory/`.

| # | Agent | Reads | Writes | Role |
|---|-------|-------|--------|------|
| 1 | `harness.ideate` | (user input) | `system-vision.md` | Abstract idea → vision draft |
| 2 | `harness.clarify` | `system-vision.md` | `system-vision.md` | Resolve ambiguities |
| 3 | `harness.domain` | `system-vision.md` | `domain-model.md` | Bounded contexts & domain model |
| 4 | `harness.architect` | vision + domain | `system-architecture.md` | MSA/monolith decision |
| 5 | `harness.research` | architecture | `research-findings.md` | References & infra concepts |
| 6 | `harness.scaffold` | all memory files | project directories | Physical structure |
| 7 | `harness.handoff` | all memory files | `services/*/spec.md` | Per-service specs → speckit |

## Installation

```bash
# From this repo's source:
src/scripts/bash/init.sh --ai kiro-cli
src/scripts/bash/init.sh --ai cursor
src/scripts/bash/init.sh --ai claude
```

Creates in target project:

```
.harness/
├── init-options.json
├── memory/            # phase outputs accumulate here
├── templates/         # memory file templates
└── scripts/bash/      # check-phase.sh, common.sh
```

Plus AI-specific prompt files:
- `kiro-cli` → `.kiro/prompts/harness.*.md`
- `cursor` → `.cursor/rules/harness.*.mdc`
- `claude` → `CLAUDE.md` (appended sections)

## Supported AI Types

kiro-cli, cursor, claude, gemini, codex, opencode, windsurf, copilot

## Source Structure

```
ai-harness/
├── README.md
├── src/
│   ├── prompts/       # 7 AI-agnostic prompt files
│   ├── templates/     # 4 memory file templates
│   └── scripts/bash/  # init, install-prompts, check-phase, common
├── specs/             # speckit feature specs (development artifacts)
└── test/
```
