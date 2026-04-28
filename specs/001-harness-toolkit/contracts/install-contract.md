# Installation Contract: `harness init --ai <type>`

## Input

| Parameter | Required | Description |
|-----------|----------|-------------|
| `--ai <type>` | yes | Target AI agent type (kiro-cli, cursor, claude, etc.) |

## Output: `.harness/` directory

```
.harness/
├── init-options.json          # {"ai": "<type>", "harness_version": "0.1.0"}
├── memory/                    # Empty, populated by phases
├── templates/
│   ├── system-vision-template.md
│   ├── domain-model-template.md
│   ├── system-architecture-template.md
│   └── service-handoff-template.md
└── scripts/
    └── bash/
        ├── common.sh
        └── check-phase.sh    # Phase prerequisite validator
```

## Output: AI-specific prompt files

| AI Type | Prompt Location | Format |
|---------|----------------|--------|
| kiro-cli | `.kiro/prompts/harness.*.md` | Markdown with YAML frontmatter (description, handoffs) |
| cursor | `.cursor/rules/harness-*.mdc` | Markdown with Cursor YAML frontmatter (description, globs, alwaysApply) |
| claude | `CLAUDE.md` | Appended sections |
| gemini | `GEMINI.md` | Appended sections |
| codex/opencode | `AGENTS.md` | Appended sections |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Missing `--ai` argument |
| 2 | Unknown AI type |
| 3 | `.harness/` already exists (use `--force` to overwrite) |
