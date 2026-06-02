# Rezzell Organization Defaults

This public repository contains organization-wide GitHub defaults and reusable
automation that is safe to publish.

## Contents

- `.github/workflows/choose-runner.yml`: selects an online ARC runner scale set
  when one is visible through GitHub, otherwise falls back to a GitHub-hosted
  runner.
- Organization community health files and workflow templates may be added here
  when they are intended for public reuse.

## Security Boundary

Treat every file and every commit in this repository as public.

- Never commit secrets, credentials, private endpoints, internal hostnames, or
  sensitive infrastructure details.
- Never embed tokens in reusable workflows. Accept secrets from callers only
  when required.
- Use least-privilege credentials. The runner selector requires only the
  `Self-hosted runners: Read` organization permission.
- Keep fork pull requests safe. Public workflows must handle missing secrets
  without exposing credentials or blocking untrusted contributions.
- Pin third-party actions to immutable commit SHAs.

Private organization-only actions and workflows belong in
`rezzell/github-actions-private`, not this repository.

## Change Review

Review workflow changes as supply-chain changes. Confirm token scope, public
exposure, fork behavior, third-party action pins, and the effect on every
calling repository before merging.
