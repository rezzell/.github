# Choose Runner

`choose-runner.yml` selects an available ARC runner scale set for trusted work
and returns a GitHub-hosted runner when private capacity is unavailable or the
request is not trusted.

## When to use it

Use this reusable workflow as a small GitHub-hosted prerequisite job. Pass its
JSON output to `runs-on` for later jobs. It supports scale sets owned by the
Rezzell organization and scale sets registered directly to an approved member
repository.

The chooser does not grant runner access. GitHub still enforces the runner
group or repository registration. Knowing a scale-set name is not sufficient
to submit work to it.

## Complete caller example

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  choose-runner:
    uses: rezzell/.github/.github/workflows/choose-runner.yml@main
    with:
      runner-scope: repository
      scale-set-name: galleon-runner-set
      fallback-runner: ubuntu-latest
    secrets:
      runners-read-token: ${{ secrets.RUNNERS_READ_TOKEN }}

  build:
    needs: choose-runner
    runs-on: ${{ fromJson(needs.choose-runner.outputs.runner) }}
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5
      - run: ./scripts/build.sh
```

Pin production callers to an immutable commit SHA when the workflow is part of
a security-sensitive supply chain.

## Inputs

| Input | Required | Default | Meaning |
| --- | --- | --- | --- |
| `runner-scope` | No | `organization` | `organization` or `repository`. |
| `organization` | No | `rezzell` | Organization queried in organization scope. |
| `repository` | No | Calling repository | `owner/name` queried in repository scope. |
| `scale-set-name` | Yes | — | ARC scale-set name returned when its persistent entry is online. |
| `fallback-runner` | Yes | — | GitHub-hosted label returned on denial or lookup failure. |

## Secrets

| Secret | Purpose |
| --- | --- |
| `runners-read-token` | Preferred fine-grained credential for the selected runners endpoint. |
| `org-runners-read-token` | Backward-compatible organization credential for existing callers. |

New callers should use `runners-read-token`. If both secrets are supplied, the
generic secret takes precedence.

The credential needs only the GitHub permission required to list self-hosted
runners at its selected scope. Do not give it workflow, contents-write, or
OpenShift permissions.

## Outputs

`runner` is a JSON array intended for `fromJson`, for example:

```json
["galleon-runner-set"]
```

or:

```json
["ubuntu-latest"]
```

## Ownership and onboarding

### Rezzell-owned repository

Use organization scope. The scale set must belong to an organization runner
group that permits the calling repository. Rezzell can provide the read token
through an organization secret restricted to approved repositories.

```yaml
with:
  runner-scope: organization
  organization: rezzell
  scale-set-name: galleon-runner-set
  fallback-runner: ubuntu-latest
secrets:
  runners-read-token: ${{ secrets.RUNNERS_READ_TOKEN }}
```

### Member-owned repository

A personal repository is outside the Rezzell organization runner-group
boundary even when its owner is a Rezzell member. Register a repository-scoped
ARC scale set for that repository, provide a repository-scoped runner-read
credential, and use repository scope. The `repository` input normally does not
need to be supplied because it defaults to `github.repository`.

## Trust and fallback policy

- Fork-originated pull requests always use the fallback.
- `push`, `workflow_dispatch`, `schedule`, and non-fork pull requests may use
  ARC when the token is present and the scale-set entry is online.
- Missing credentials, unsupported events, invalid scope values, invalid
  `owner/name` values, GitHub API errors, and no matching online entry all use
  the fallback.
- The chooser itself always runs on `ubuntu-latest`, so ARC downtime cannot
  prevent the decision job from starting.

Public repositories should avoid executing untrusted contributor code on
self-hosted runners. A caller may adopt a stricter policy by invoking private
jobs only for protected events and keeping all pull-request jobs hosted.

## Scale-to-zero behavior

ARC exposes a persistent scale-set entry separately from ephemeral runner
instances. With `minRunners: 0`, the persistent entry remains online while no
runner pods exist. The chooser matches that entry, GitHub assigns the job to
the scale set, and ARC creates an ephemeral runner on demand.

The matching rule counts online entries whose names begin with the configured
scale-set name. This covers the persistent entry and active ephemeral runners.

## Implementation

The workflow checks out the same revision of `rezzell/.github` that supplied
the reusable workflow and runs `.github/scripts/choose-runner.sh`. The script
queries one of:

```text
GET /orgs/{organization}/actions/runners
GET /repos/{owner}/{repo}/actions/runners
```

It follows GitHub pagination and emits only the configured public alias in log
messages. The actual selected label is written to the workflow output.

## Troubleshooting

- **Always falls back:** confirm the caller passes a runner-read secret and the
  token can list runners at the selected scope.
- **Organization lookup cannot see a personal repository:** use repository
  scope and a repository-scoped scale set.
- **Scale set is online but jobs remain queued:** verify GitHub runner-group or
  repository authorization and inspect the ARC listener/controller logs.
- **Fork PR uses hosted capacity:** this is expected and cannot be overridden by
  supplying a token.
- **Lookup failure:** validate `runner-scope`, `organization`, and the optional
  `repository` value; the chooser intentionally fails closed.

## Validation

Run:

```bash
bash .github/scripts/test-choose-runner.sh
```

The validation workflow also runs this test for chooser changes.
