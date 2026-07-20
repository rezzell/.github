# Rezzell Organization Defaults

This public repository contains organization-wide GitHub defaults and reusable
automation that is safe to publish.

## Contents

- `.github/workflows/choose-runner.yml`: selects an online ARC runner scale set
  when one is visible through GitHub, otherwise falls back to a GitHub-hosted
  runner.
- `.github/actions/s3-cache-manager/action.yml`: restores and conditionally
  saves GitHub Actions cache paths through an S3-compatible backend for
  ephemeral ARC or other self-hosted runners.
- `.github/workflows/s3-cache-manager.yml`: workflow-call wrapper around the
  S3 cache manager action for cache-only jobs that intentionally run as their
  own reusable workflow job.
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

## S3 cache manager trust policy

- Use the action form inside the same job as the build or test steps that need
  restored files. A reusable workflow runs in its own job, so it cannot restore
  files into a separate caller job.
- Cache saves default to `auto`, which saves only outside `pull_request` events
  on the caller repository's default branch. Pull requests restore only.
- When cache backend secrets are unavailable, the action skips restore and save
  instead of failing fork pull requests.
- The S3 endpoint, bucket, and access keys must come from caller secrets or
  organization secrets. Do not hard-code cache backend details in this public
  repository.
- Do not cache credentials, tokens, private keys, or generated files that
  contain secrets.
- Callers should pin this repository to an immutable commit SHA when consuming
  the action or workflow.

Example step-level usage:

```yaml
- name: Manage S3 cache
  id: s3-cache
  uses: rezzell/.github/.github/actions/s3-cache-manager@<commit-sha>
  with:
    cache-key: go-${{ runner.os }}-${{ hashFiles('**/go.sum') }}
    cache-paths: |
      ~/go/pkg/mod
      ~/.cache/go-build
    restore-keys: |
      go-${{ runner.os }}-
    s3-endpoint: ${{ secrets.GLOBAL_CACHE_S3_ENDPOINT }}
    s3-bucket: ${{ secrets.GLOBAL_CACHE_S3_BUCKET }}
    aws-access-key-id: ${{ secrets.GLOBAL_CACHE_AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.GLOBAL_CACHE_AWS_SECRET_ACCESS_KEY }}
```

## `choose-runner` trust policy

- Fork-originated pull requests always fall back to the caller's GitHub-hosted runner.
- Trusted events (`push`, `workflow_dispatch`, `schedule`, and non-fork pull requests) may use self-hosted runners when `ORG_RUNNERS_READ_TOKEN` is available.
- If the token is absent or no matching runner is online, the workflow falls back to the configured GitHub-hosted runner.
- Caller workflows should continue to consume `needs.choose-runner.outputs.runner` with `runs-on: ${{ fromJson(...) }}`.

Private organization-only actions and workflows belong in
`rezzell/github-actions-private`, not this repository.

## Change Review

Review workflow changes as supply-chain changes. Confirm token scope, public
exposure, fork behavior, third-party action pins, and the effect on every
calling repository before merging.
