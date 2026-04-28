---
description: Identify bounded contexts and build a domain model from the finalized system vision.
handoffs:
  - label: Design Architecture
    agent: harness.architect
    prompt: Design the system architecture based on the domain model
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Analyze the system vision and produce a domain model with bounded contexts, entities, relationships, and ubiquitous language at `.harness/memory/domain-model.md`.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh domain --json` and parse JSON. If not ready, instruct user to run `harness.ideate` first.

### Execution

2. Load `.harness/memory/system-vision.md`.

3. Load `.harness/templates/domain-model-template.md`.

4. Identify bounded contexts:
   - Extract all actors, processes, and data concepts from the vision
   - Group related concepts by cohesion (what changes together, stays together)
   - Name each context with a clear, domain-specific noun
   - Define each context's single responsibility

5. For each bounded context:
   - List core entities with key attributes and relationships
   - Identify key business rules (invariants, constraints, policies)
   - Note which entities are shared across contexts (these become integration points)

6. Build context map:
   - Define relationships between contexts: upstream/downstream, shared kernel, anti-corruption layer, etc.
   - Identify which contexts are core (competitive advantage), supporting (necessary but not differentiating), or generic (commodity)

7. Build ubiquitous language glossary:
   - Extract domain-specific terms from the vision
   - Define each term precisely within its context
   - Flag terms that mean different things in different contexts

8. Write to `.harness/memory/domain-model.md`.

9. Report:
   - Number of bounded contexts identified
   - Context classification (core/supporting/generic)
   - Key integration points between contexts
   - Suggest `harness.architect` as next step.

## Guidelines

- Contexts should be autonomous — each could theoretically be a separate service.
- Prefer fewer, larger contexts over many tiny ones (avoid premature decomposition).
- Business rules belong to the context that owns the data they constrain.
- The glossary is critical — inconsistent terminology causes architecture errors downstream.
