# Project Outcome Delivery

## Status

This document is an organization-default operational projection for GitHub. It
does not create project authority, reclassify a Project as a Product, or replace
canonical project context in Notion.

## Purpose

Rezzell uses a project outcome to show durable progress above individual issues
without forcing non-product Projects into the Product Features model. An outcome
may be a project objective, milestone, deliverable, experiment, decision, or
operational-readiness result.

The model is:

```text
Project
  -> Project outcome
    -> GitHub milestone or delivery container
      -> bounded issues and work packets
        -> pull requests and implementation evidence
```

Agent Work Coordination remains a sidecar. It carries cross-session
recommendations, waiting conditions, claims, routing, and handoffs; it is not the
project roadmap or execution backlog.

## Control-plane ownership

| Concern | Owning system |
| --- | --- |
| Project identity, purpose, boundaries, outcome map, and durable completion context | Notion |
| Milestones, work packets, dependencies, delivery status, and evidence links | GitHub Issues and repository planning |
| Code, tests, contracts, configuration, pull requests, and executable truth | Git repositories |
| Cross-session continuation, waits, claims, routing, and handoffs | Agent Work Coordination |

## Shared Notion Project Outcomes portfolio

The shared Project Outcomes database is the project-level portfolio. Each record
should identify:

- a stable Project Outcome ID;
- the owning Project;
- the outcome type and source classification;
- the problem or intended result;
- a coarse outcome stage and Now, Next, Later, or Parked horizon;
- the canonical project context;
- current GitHub delivery navigation; and
- explicit completion evidence when complete.

Use one record per durable project-level result. Do not mirror every GitHub issue
or pull request into Notion. The database is a navigation and outcome layer, not
a second execution system.

## Source classification

Use the conclusion labels consistently:

- **Observed** — directly stated in a current canonical source.
- **Derived** — a necessary synthesis of current sources.
- **Proposed** — new direction offered for accountable disposition.
- **Ratified** — already established by an Approved Rezzell source.

A GitHub issue cannot turn Proposed direction into Ratified direction.

## GitHub outcome container

Use the organization `Project outcome` issue form only when a GitHub container
adds useful delivery navigation. Reuse an existing repository milestone,
planning record, or container issue when it already owns that role.

A project outcome container should:

1. link the canonical Notion project page and outcome record;
2. identify its source classification and outcome type;
3. state the intended result and completion signal;
4. link bounded child issues, dependencies, and evidence; and
5. state whether it is a container or a directly executable unit.

Do not create a redundant outcome issue merely to mirror a Notion row. A direct
coding agent should normally receive a bounded child issue or work packet.

## Normal agent traversal

```text
Bounded GitHub issue or work packet
  -> containing milestone or project outcome
    -> canonical Notion project page and outcome record
      -> applicable decisions and standards
        -> repository-local implementation context
```

Do not load an entire project portfolio for a bounded implementation task unless
the work is explicitly strategic or cross-cutting.

## Outcome stage versus issue status

The Notion outcome stage is a coarse project-level signal. GitHub owns the live
execution graph. A milestone may remain `In Delivery` while many child issues are
complete, and a completed issue does not automatically complete its containing
outcome.

Use these stage meanings:

- **Discovery** — the outcome or required context is still being established.
- **Planned** — the outcome is defined but delivery has not begun.
- **In Delivery** — bounded work is actively advancing the outcome.
- **Review** — completion evidence is being assessed.
- **Complete** — the stated completion signal is satisfied and evidence is linked.
- **Measuring** — post-completion behavior or learning is being observed.
- **Parked** or **Retired** — work is intentionally inactive or concluded.

## Completion

Before marking an outcome Complete:

1. evaluate the evidence against the stated completion signal;
2. record limitations, residual work, or deferred scope;
3. link immutable or durable evidence from the Project Outcomes record;
4. close any GitHub container only when its delivery obligation is discharged;
   and
5. route follow-on work to the correct owning control plane.

Issue closure, merged code, and passing tests are evidence. They are not by
themselves proof that a broader project objective or milestone is complete.

## Project and product boundary

Use Product Features for reusable commercial products and Project Outcomes for
bounded Rezzell Projects. A Project does not become a Product because it has a
large repository, sophisticated implementation, a long roadmap, or extensive
agentic execution. Promotion requires an explicit Rezzell decision.

## Review checklist

Before accepting a project outcome or container, confirm:

- the outcome is useful above individual tickets;
- the Project classification is preserved;
- the canonical Notion context is explicit;
- source classification is truthful;
- completion criteria are observable;
- current execution state remains in GitHub;
- direct work is decomposed to bounded agent-sized units; and
- no product, architecture, security, pricing, release, or operational authority
  is created by implication.
