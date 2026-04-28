---
description: Design system architecture based on domain complexity — MSA, monolith, or hybrid.
handoffs:
  - label: Research Infrastructure
    agent: harness.research
    prompt: Research reference systems and infrastructure concepts
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Decide and document the system architecture at `.harness/memory/system-architecture.md`.

### Pre-Check

1. Run `.harness/scripts/bash/check-phase.sh architect --json` and parse JSON. If not ready, report missing prerequisites.

### Execution

2. Load `.harness/memory/system-vision.md` and `.harness/memory/domain-model.md`.

3. Load `.harness/templates/system-architecture-template.md`.

4. Evaluate architecture style. Consider:

   | Factor | Favors Monolith | Favors MSA |
   |--------|-----------------|------------|
   | Team size | Small (1-5) | Large (10+) |
   | Domain complexity | Low (1-2 contexts) | High (4+ contexts) |
   | Scaling needs | Uniform | Per-service |
   | Deployment cadence | Unified releases | Independent deploys |
   | Data consistency | Strong consistency needed | Eventual consistency OK |

   Make an explicit decision: **monolith**, **MSA**, or **hybrid** (monolith with planned seams).
   Document the rationale — why this style fits this system.

5. Define services (or modules for monolith):
   - Map each bounded context to a service/module
   - Define responsibilities per service
   - Specify communication patterns:
     - Synchronous: REST, gRPC, GraphQL
     - Asynchronous: events, message queues, pub/sub
   - For each service pair that communicates, specify the pattern and why

6. Identify cross-cutting concerns:

   | Concern | Check If Needed |
   |---------|-----------------|
   | Authentication/SSO | Multiple user-facing services? |
   | Authorization | Role-based or resource-based access? |
   | Message Queue | Async communication between services? |
   | API Gateway | Multiple external-facing services? |
   | Service Discovery | Dynamic service instances? |
   | Observability | Distributed tracing, centralized logging? |
   | Configuration | Shared config across services? |
   | CI/CD | Per-service or unified pipeline? |

   For each applicable concern: document the approach and rationale.

7. Optionally describe deployment topology (containerized, serverless, VM-based, etc.).

8. Write to `.harness/memory/system-architecture.md`.

9. Report:
   - Architecture style chosen with rationale summary
   - Number of services/modules
   - Cross-cutting concerns identified
   - Suggest `harness.research` as next step.

## Guidelines

- Default to monolith unless there's a clear reason for MSA.
- Hybrid (modular monolith with defined seams) is often the best starting point.
- Every cross-cutting concern adds complexity — only include what's needed for v1.
- Communication patterns should match consistency requirements, not trends.
