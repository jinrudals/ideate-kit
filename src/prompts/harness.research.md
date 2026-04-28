---
description: Investigate reference systems and infrastructure concepts to inform technology decisions.
handoffs:
  - label: Generate Scaffold
    agent: harness.scaffold
    prompt: Generate the project scaffold based on architecture and research
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Research similar systems, recommend technologies, and analyze infrastructure concepts. Write findings to `.harness/memory/research-findings.md`.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh research --json` and parse JSON. If not ready, report missing prerequisites.

### Execution

2. Load `.harness/memory/system-architecture.md`.

3. **Reference Systems**: For each service/module in the architecture:
   - Identify 1-3 well-known systems that solve similar problems
   - Extract relevant lessons (what they do well, common pitfalls)
   - Note architectural patterns they use

4. **Technology Recommendations**: For each service:
   - Recommend language/framework based on service characteristics
   - Consider: team familiarity (if known), ecosystem maturity, community support
   - Provide rationale and one alternative for each recommendation

5. **Infrastructure Concepts**: For each cross-cutting concern in the architecture:
   - Explain the concept and why it's needed for this system
   - Recommend a specific approach or tool
   - List alternatives with trade-offs
   - Examples:
     - SSO: OIDC vs SAML vs custom token
     - MQ: Kafka vs RabbitMQ vs SQS
     - Observability: OpenTelemetry vs vendor-specific
     - API Gateway: Kong vs Envoy vs cloud-native

6. Write to `.harness/memory/research-findings.md`.

7. Report:
   - Reference systems surveyed
   - Technology recommendations per service
   - Infrastructure decisions made
   - Suggest `harness.scaffold` as next step.

## Guidelines

- If web search is unavailable, use training knowledge and state that recommendations are based on general knowledge rather than current market data.
- Prefer boring, proven technology over cutting-edge unless the problem demands it.
- Always provide at least one alternative for each recommendation.
- Keep recommendations actionable — specific versions and configurations, not just names.
