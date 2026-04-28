---
description: Identify and resolve ambiguities in the system vision through targeted clarification questions.
handoffs:
  - label: Model Domain
    agent: harness.domain
    prompt: Create the domain model from the finalized vision
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Detect and reduce ambiguity in `.harness/memory/system-vision.md` by asking up to 5 targeted questions and encoding answers back into the vision.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh clarify --json` and parse JSON. If not ready, instruct user to run `harness.ideate` first.

### Execution

2. Load `.harness/memory/system-vision.md`. Perform a structured ambiguity scan:

   | Category | What to Check |
   |----------|---------------|
   | Problem Clarity | Is the problem statement specific and falsifiable? |
   | User Definition | Are personas distinct with clear goals? |
   | Outcome Measurability | Can desired outcomes be objectively verified? |
   | Scope Boundaries | Are in/out scope items concrete, not vague? |
   | Assumption Validity | Are assumptions reasonable and non-contradictory? |
   | Value Differentiation | Is the value proposition distinct from status quo? |
   | Open Questions | Any `[NEEDS CLARIFICATION]` markers? |

   For each category, mark: Clear / Partial / Missing.

3. Generate a prioritized queue of up to 5 clarification questions. Constraints:
   - Each question: multiple-choice (2-5 options) OR short answer (<=5 words)
   - Only questions whose answers materially impact domain modeling, architecture, or service boundaries
   - Prioritize by (Impact × Uncertainty)

4. Sequential questioning loop:
   - Present ONE question at a time
   - For multiple-choice: provide **Recommended** option with reasoning, then all options as table
   - For short-answer: provide **Suggested** answer with reasoning
   - After user answers: validate, record, move to next
   - Stop when: all resolved, user signals done, or 5 questions reached

5. After EACH accepted answer:
   - Ensure `## Clarifications` section exists with `### Session [DATE]` subheading
   - Append: `- Q: <question> → A: <answer>`
   - Apply clarification to the appropriate section of the vision
   - Remove any `[NEEDS CLARIFICATION]` markers that the answer resolves
   - Save immediately

6. Write updated vision to `.harness/memory/system-vision.md`.

7. Report:
   - Questions asked/answered
   - Sections updated
   - Coverage summary (Resolved / Deferred / Clear / Outstanding per category)
   - Suggest `harness.domain` if vision is clean, or re-run `harness.clarify` if outstanding items remain.
