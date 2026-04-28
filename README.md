# ideate-kit

AI-agnostic toolkit that develops abstract ideas into concrete system architectures, then hands off to per-service development tools like [speckit](https://github.com/github/spec-kit).

## Where It Sits

```
User's abstract idea
       │
   ┌────────────┐
   │  IDEATE-KIT │  system-level concept engineering
   └──────┬─────┘
          │  per-service specs
   ┌────────────┐
   │   SPECKIT   │  per-service feature development
   └────────────┘
```

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/jinrudals/ideate-kit/main/install.sh | sh
```

Then, in your project:

```bash
harness init --ai kiro-cli
harness init --ai cursor
harness init --ai claude
```

### Supported AI Types

kiro-cli, cursor, claude, gemini, codex, opencode, windsurf, copilot

## What It Creates

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
