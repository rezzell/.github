#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
action="${repo_root}/actions/s3-cache-manager/action.yml"
workflow="${repo_root}/workflows/s3-cache-manager.yml"
validate_workflow="${repo_root}/workflows/validate-s3-cache-manager.yml"
readme="${repo_root}/../README.md"
cache_sha="9fc411013eb63519a6930c994c298ba869be6fed"
checkout_sha="34e114876b0b11c390a56381ad16ebd13914f8d5"

require_line() {
  local file="$1"
  local text="$2"
  if ! grep -F "${text}" "${file}" >/dev/null; then
    echo "Expected to find '${text}' in ${file}" >&2
    exit 1
  fi
}

require_line "${action}" "uses: runs-on/cache/restore@${cache_sha}"
require_line "${action}" "uses: runs-on/cache/save@${cache_sha}"
require_line "${action}" "REQUESTED_SAVE_CACHE: \${{ inputs.save-cache }}"
require_line "${action}" "GITHUB_EVENT_NAME: \${{ github.event_name }}"
require_line "${action}" "CACHE_BACKEND_ENABLED: \${{ steps.backend.outputs.enabled }}"
require_line "${action}" "S3 cache backend is unavailable"
require_line "${action}" "GITHUB_EVENT_NAME}\" != pull_request*"
require_line "${action}" "RUNS_ON_S3_BUCKET_CACHE: \${{ inputs.s3-bucket }}"
require_line "${action}" "RUNS_ON_S3_BUCKET_ENDPOINT: \${{ inputs.s3-endpoint }}"

if grep -E 'uses: runs-on/cache(/(restore|save))?@v[0-9]+' "${action}" >/dev/null; then
  echo "s3-cache-manager action must pin runs-on/cache to an immutable SHA" >&2
  exit 1
fi

require_line "${workflow}" "on:"
require_line "${workflow}" "workflow_call:"
require_line "${workflow}" "GLOBAL_CACHE_S3_ENDPOINT:"
require_line "${workflow}" "GLOBAL_CACHE_AWS_SECRET_ACCESS_KEY:"
require_line "${workflow}" "cache-enabled:"
require_line "${workflow}" "runs-on: \${{ fromJson(inputs.runner) }}"
require_line "${workflow}" "uses: actions/checkout@${checkout_sha}"
require_line "${workflow}" "uses: ./workflow-repo/.github/actions/s3-cache-manager"

require_line "${validate_workflow}" ".github/actions/s3-cache-manager/action.yml"
require_line "${validate_workflow}" ".github/workflows/s3-cache-manager.yml"
require_line "${validate_workflow}" ".github/scripts/test-s3-cache-manager.sh"

require_line "${readme}" ".github/actions/s3-cache-manager/action.yml"
require_line "${readme}" ".github/workflows/s3-cache-manager.yml"
require_line "${readme}" "Do not cache credentials, tokens, private keys, or generated files that"

echo "test-s3-cache-manager.sh: PASS"
