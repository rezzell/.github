# Product Feature Delivery

## Status

This document is an organization-default operational projection for GitHub. It
does not create product authority or replace the canonical product sources in
Notion.

## Purpose

Rezzell uses a product feature as the bridge between durable product intent and
bounded delivery work. A feature represents one meaningful user, operator, or
business outcome. It is intentionally larger than one implementation ticket and
smaller than an entire product or indefinite roadmap theme.

The model is:

```text
Product
  -> Capability usage
    -> Product feature
      -> GitHub delivery work
        -> Pull requests and implementation evidence
```

Agent Work Coordination is a sidecar to this hierarchy. It carries cross-session
recommendations, waiting conditions, claims, routing, and handoffs; it is not a
product backlog or delivery-status system.

## Control-plane ownership

| Concern | Owning system |
| --- | --- |
| Product problem, outcome, scope, authority, and product acceptance | Notion |
| Delivery containers, dependencies, priority, implementation status, and evidence links | GitHub Issues |
| Code, tests, contracts, configuration, pull requests, and executable truth | Git repositories |
| Cross-session continuation, waits, claims, and handoffs | Agent Work Coordination |

Authority follows the concern, not the tool. An issue description or comment
cannot silently approve or expand product scope. A merged pull request or a set
of closed child issues cannot silently create product acceptance.

## Shared Notion Product Features portfolio

The shared Product Features database is the product-level portfolio. Each
feature should identify:

- a stable Product Feature ID;
- the primary product and affected capabilities;
- the problem and intended outcome;
- the current product authority state;
- the coarse product lifecycle stage and product horizon;
- the canonical requirement or decision source;
- the corresponding GitHub delivery container; and
- the explicit product-acceptance record when accepted.

Use one record per meaningful product outcome. Do not mirror every GitHub issue
into Notion. Detailed execution state remains in GitHub.

## GitHub feature issue contract

Use the organization `Product feature` issue form to create a product-level
delivery container. The feature issue must:

1. link the canonical Notion feature or requirement and identify its authority
   state;
2. state the product outcome and bounded delivery scope;
3. identify the product-acceptance path and accountable reviewer;
4. contain or link the child-issue decomposition and dependencies; and
5. state that it is a container rather than a direct coding-agent unit.

The issue may summarize enough product context to support navigation, but it
must link rather than duplicate enough governing text to become an accidental
competing source.

A normal structure is:

```text
[Feature] Product outcome
  |- bounded product or decision issue
  |- implementation issue
  |- implementation issue in another repository
  |- verification or operations issue
  `- product-acceptance evidence
```

Use GitHub sub-issues when available. Otherwise maintain an explicit linked
checklist in the feature issue. A child issue may live in another repository
when that repository owns the implementation.

## Direct agent work

A feature issue is normally too broad for a coding agent. A direct coding-agent
unit should be a bounded child issue that:

- owns one coherent, independently reviewable outcome;
- links its parent feature and canonical Notion source;
- has explicit in-scope and out-of-scope behavior;
- allocates observable acceptance criteria and verification commands;
- represents dependencies, blockers, and active file ownership;
- contains no unresolved product or durable technical decision; and
- includes an escalation destination and stop conditions.

The preferred context traversal is:

```text
Child GitHub issue
  -> Parent GitHub feature issue
    -> Canonical Notion feature or requirement
      -> Applicable decisions and context manifest
        -> Repository-local implementation context
```

Do not load an entire product portfolio for a bounded implementation task unless
the work is explicitly strategic or cross-cutting.

## Product lifecycle and delivery state

The Notion product stage is a coarse product-level lifecycle signal. GitHub owns
the current delivery graph and detailed workflow state. Keep the two concepts
separate:

```text
Notion authority and lifecycle
  Draft -> Proposed -> Approved
  Planned -> In Delivery -> Acceptance Review -> Accepted -> Measuring

GitHub delivery
  Feature container -> bounded issues -> pull requests -> verification evidence
```

A feature may have an Approved requirement while its delivery is blocked. A
feature may also have complete implementation evidence while awaiting product
acceptance. Neither state should be inferred from the other.

## Product acceptance

When delivery evidence is ready:

1. review evidence against the approved Notion requirement, not merely against
   ticket closure;
2. record the accountable acceptance decision and known limitations in Notion;
3. link the acceptance record from the Product Features database;
4. close the GitHub feature issue only when its delivery obligation is complete;
   and
5. record follow-on outcomes or work in the owning control plane.

The feature should be marked `Accepted` in the product portfolio only from an
explicit product-acceptance record.

## Organization-level GitHub Project target

An organization Project named `Rezzell Product Delivery` should provide the
human delivery visualization without becoming a second source of product
requirements. Its primary views should be:

- **Features** — feature containers grouped by product;
- **Roadmap** — feature containers with actual target windows;
- **Feature drill-down** — feature containers and child issues grouped by
  parent; and
- **Agent-ready work** — bounded leaf issues that satisfy the applicable
  readiness contract.

Prefer organization issue fields for metadata that agents must query across
projects. Until those fields are configured, the issue form and canonical links
are the interoperable contract. Project-local fields may improve visualization,
but agents must not depend on them as the only copy of essential context.

Creating or editing the Project, organization issue fields, issue types, or
organization settings remains a separately authorized organization operation.

## Review checklist

Before accepting a new feature issue, confirm:

- the product outcome is meaningful at product level rather than a disguised
  technical task;
- the canonical Notion source and authority state are explicit;
- the GitHub issue does not invent product, architecture, security, pricing, or
  release authority;
- child work is bounded and independently verifiable;
- current delivery state is maintained in GitHub rather than copied into
  Notion; and
- product acceptance has an explicit owner, source, and evidence path.
