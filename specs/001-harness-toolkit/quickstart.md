# Quickstart: Harness Toolkit Development

## Prerequisites

- Bash 4.0+
- bats (for testing scripts)
- Any AI coding assistant (kiro-cli, cursor, claude, etc.) for testing prompt deployment

## Repository Layout

```
ai-harness/
├── src/
│   ├── prompts/           # 7 AI-agnostic prompt files
│   ├── templates/         # 4 memory file templates
│   └── scripts/bash/      # init + install scripts
├── specs/                 # speckit feature specs
└── test/                  # bats tests
```

## Development Workflow

1. Edit prompt sources in `src/prompts/`
2. Edit templates in `src/templates/`
3. Edit scripts in `src/scripts/bash/`
4. Test with `bats test/`
5. Manual integration test: run `src/scripts/bash/init.sh --ai kiro-cli` in a temp project

## Testing a Prompt Change

```bash
# Copy a prompt to a test project's AI location
cp src/prompts/harness.ideate.md /tmp/test-project/.kiro/prompts/

# Run the prompt in your AI tool and verify behavior
```

## Testing the Installer

```bash
# Create a temp project
mkdir /tmp/test-project && cd /tmp/test-project

# Run init
/path/to/ai-harness/src/scripts/bash/init.sh --ai kiro-cli

# Verify structure
ls -la .harness/
ls -la .kiro/prompts/harness.*
```

## Key Design Rules

- Prompts are AI-agnostic: no AI-specific syntax in `src/prompts/`
- Agents communicate only through `.harness/memory/` files
- Each phase validates prerequisites before running
- Zero external dependencies in installed toolkit
