# Phase Prerequisite Contract: `check-phase.sh`

## Usage

```bash
.harness/scripts/bash/check-phase.sh <phase> --json
```

## Input

| Parameter | Required | Description |
|-----------|----------|-------------|
| `<phase>` | yes | Phase name: ideate, clarify, domain, architect, research, scaffold, handoff |
| `--json` | no | Output in JSON format |

## Prerequisite Matrix

| Phase | Required Files | Optional Files |
|-------|---------------|----------------|
| ideate | (none) | |
| clarify | `memory/system-vision.md` | |
| domain | `memory/system-vision.md` | |
| architect | `memory/system-vision.md`, `memory/domain-model.md` | |
| research | `memory/system-architecture.md` | |
| scaffold | `memory/system-vision.md`, `memory/domain-model.md`, `memory/system-architecture.md` | `memory/research-findings.md` |
| handoff | `memory/system-vision.md`, `memory/domain-model.md`, `memory/system-architecture.md` | `memory/research-findings.md` |

## JSON Output

```json
{
  "phase": "domain",
  "ready": true,
  "harness_dir": "/path/to/.harness",
  "memory_dir": "/path/to/.harness/memory",
  "available": ["system-vision.md"],
  "missing": []
}
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All prerequisites met |
| 1 | Missing prerequisite files (details in output) |
| 2 | `.harness/` not found |
