# AGENTS.md

## Purpose

This public repository contains Rezzell organization defaults, community files,
workflow templates, and reusable GitHub Actions workflows that are safe to
publish.

## Public Repository Rules

- Treat all files, commit messages, workflow logs, and git history as public.
- Do not add secrets, credentials, private endpoints, internal hostnames,
  customer data, or sensitive infrastructure details.
- Do not store private organization-only automation here. Use
  `rezzell/github-actions-private`.
- Do not broaden token permissions without documenting the endpoint that
  requires the additional access.
- Prefer GitHub App credentials or fine-grained tokens with the smallest
  possible organization and repository scope.
- Pin third-party actions and container images to immutable digests or commit
  SHAs.
- Ensure workflows triggered by public pull requests behave safely when secrets
  are unavailable.

## Workflow Review Checklist

- Confirm that reusable workflow inputs and outputs form a stable public API.
- Confirm that caller-provided secrets are optional where fork pull requests
  need a safe fallback.
- Confirm that logs cannot disclose secrets or sensitive infrastructure data.
- Confirm that shell scripts use strict error handling and quote variables.
- Confirm that any added dependency is necessary and pinned.

## Automation Documentation Contract

- Every reusable workflow under `.github/workflows/` and reusable action under
  `.github/actions/` must have a caller-facing document under `docs/workflows/`.
- Document purpose, trust boundary, inputs, secrets, outputs, complete usage,
  account or repository setup, fallback behavior, and troubleshooting.
- Explain implementation decisions that callers or future maintainers would
  otherwise have to rediscover, including GitHub ownership and permission
  boundaries.
- Keep the workflow metadata, implementation, tests, README link, and detailed
  document synchronized in the same pull request.
- Validation-only workflows may be documented by the item they validate rather
  than receiving a separate caller document.

## Repository Hygiene

- Keep `README.md` current and link every reusable automation item to its
  detailed documentation.
- Keep `CLAUDE.md` as a thin pointer to this file.
- Use focused commits and review workflow changes before publishing them.
