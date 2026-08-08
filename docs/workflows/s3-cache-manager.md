# S3 Cache Manager

The S3 cache manager restores and conditionally saves GitHub Actions cache
archives in an S3-compatible bucket. It is available as both a composite action
for the current job and a reusable workflow that runs a dedicated cache job.

## Choose the correct interface

Use the composite action when later steps in the same job need the restored
files. Use the reusable workflow only when a separate cache-only job is
intentional. A reusable workflow cannot restore files into another job's
workspace.

## Composite-action example

```yaml
- name: Manage S3 cache
  id: cache
  uses: rezzell/.github/.github/actions/s3-cache-manager@<commit-sha>
  with:
    cache-key: dotnet-${{ runner.os }}-${{ hashFiles('**/*.csproj') }}
    cache-paths: |
      ~/.nuget/packages
    restore-keys: |
      dotnet-${{ runner.os }}-
    s3-endpoint: ${{ secrets.GLOBAL_CACHE_S3_ENDPOINT }}
    s3-bucket: ${{ secrets.GLOBAL_CACHE_S3_BUCKET }}
    aws-access-key-id: ${{ secrets.GLOBAL_CACHE_AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.GLOBAL_CACHE_AWS_SECRET_ACCESS_KEY }}
```

## Reusable-workflow example

```yaml
jobs:
  cache:
    uses: rezzell/.github/.github/workflows/s3-cache-manager.yml@main
    with:
      runner: '["ubuntu-latest"]'
      cache-key: tools-${{ github.sha }}
      cache-paths: |
        .cache/tools
    secrets: inherit
```

## Required backend settings

The endpoint, bucket, access key, and secret key must all be present. If any
are unavailable—such as on a fork pull request—the action warns, sets
`cache-enabled=false`, and skips restore and save rather than failing the job.

Credentials should be limited to the cache bucket and must never be committed
to this public repository. Organization secrets are available only to approved
repositories in that organization; personal repositories require their own
repository-level onboarding.

## Save policy

`save-cache: auto` saves only outside pull-request events on the calling
repository's default branch. Pull requests restore but do not write. Set
`save-cache` to `true` or `false` only when the caller deliberately needs to
override that policy.

## Outputs

- `cache-hit`: the primary key matched exactly.
- `cache-primary-key`: resolved primary key.
- `cache-matched-key`: exact or prefix key restored.
- `save-cache`: this invocation was permitted to save.
- `cache-enabled`: all backend settings were available.

## Implementation and security

The implementation uses immutable revisions of `runs-on/cache/restore` and
`runs-on/cache/save`. S3 credentials exist only in the cache steps' environment.
Cache archives must be treated as untrusted build inputs; never cache
credentials, tokens, private keys, or generated files containing secrets.

## Troubleshooting

- **Cache is disabled:** verify all four backend secrets are available to the
  current event and repository.
- **Files are missing in another job:** use the composite action inside that
  job; job workspaces are isolated.
- **Pull request does not save:** expected under `save-cache: auto`.
- **S3 path errors:** verify the endpoint, region, bucket, and
  `force-path-style` setting for the selected object store.
- **Unexpected cross-platform miss:** review `enable-cross-os-archive`; it is
  disabled by default.

## Validation

Run:

```bash
bash .github/scripts/test-s3-cache-manager.sh
```

The validation workflow runs the same policy tests when the action or wrapper
changes.
