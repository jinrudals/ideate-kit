---
description: Develop an abstract idea into a concrete system vision document through interactive dialogue.
handoffs:
  - label: Clarify Vision
    agent: harness.clarify
    prompt: Clarify ambiguities in the system vision
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Transform the user's abstract idea into a structured system vision document at `.harness/memory/system-vision.md`.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh ideate --json` and parse JSON. If `.harness/` not found, instruct user to run `harness init` first.

### Execution

2. Parse the user's input. Extract:
   - Core idea / problem space
   - Any mentioned users, constraints, or goals
   - Implicit assumptions

3. Load `.harness/templates/system-vision-template.md`.

4. Fill the template by engaging with the user:
   - **System Name**: Derive a concise name (2-4 words) from the idea.
   - **Problem Statement**: What pain point or opportunity does this address? Who experiences it?
   - **Target Users**: Primary and secondary personas with goals and constraints.
   - **Desired Outcomes**: What does success look like from the user's perspective?
   - **Core Value Proposition**: One paragraph — why choose this over alternatives?
   - **Scope — In Scope (v1)**: Concrete capabilities for first version.
   - **Scope — Out of Scope**: Explicitly excluded for v1.
   - **Key Assumptions**: Market, technical, and resource assumptions.
   - **Open Questions**: Unresolved decisions for `harness.clarify` to address.

   For each section:
   - If user input provides enough information, fill directly.
   - If ambiguous, make a reasonable default and mark with `[NEEDS CLARIFICATION: specific question]`. Maximum 5 markers total.
   - Do NOT ask the user interactively for every field — produce a complete draft first.

5. Write the completed vision to `.harness/memory/system-vision.md`.

6. Report:
   - Path to generated file
   - Summary of what was captured
   - Count of `[NEEDS CLARIFICATION]` markers (if any)
   - Suggest running `harness.clarify` if markers exist, or `harness.domain` if vision is clean.

## Guidelines

- Focus on WHAT and WHY, not HOW.
- Keep language accessible to non-technical stakeholders.
- Be opinionated — make decisions where reasonable rather than deferring everything.
- One complete draft is better than many questions.
