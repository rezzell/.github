#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="${repo_root}/scripts/choose-runner.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

run_case() {
  local name="$1"
  local event_name="$2"
  local event_json="$3"
  local token="$4"
  local api_body="$5"
  local expected_runner="$6"
  local expected_log="$7"

  local event_path="${tmpdir}/${name}-event.json"
  printf '%s\n' "${event_json}" > "${event_path}"

  local output
  output="$(
    GITHUB_EVENT_NAME="${event_name}" \
    GITHUB_EVENT_PATH="${event_path}" \
    GH_TOKEN="${token}" \
    ORGANIZATION="rezzell" \
    SCALE_SET_NAME="preferred-runner-set" \
    FALLBACK_RUNNER="ubuntu-latest" \
    MOCK_RUNNERS_RESPONSE="${api_body}" \
    bash "${script}"
  )"

  printf '%s\n' "${output}" | grep -F "${expected_log}" >/dev/null
  printf '%s\n' "${output}" | grep -F "runner=${expected_runner}" >/dev/null
}

run_case_multi_page() {
  local event_path="${tmpdir}/multi-page-event.json"
  printf '%s\n' '{}' > "${event_path}"

  local output
  output="$(
    GITHUB_EVENT_NAME="push" \
    GITHUB_EVENT_PATH="${event_path}" \
    GH_TOKEN="token" \
    ORGANIZATION="rezzell" \
    SCALE_SET_NAME="preferred-runner-set" \
    FALLBACK_RUNNER="ubuntu-latest" \
    MOCK_RUNNERS_RESPONSE_PAGE_1='{"runners":[{"name":"other-set-001","status":"online"}]}' \
    MOCK_RUNNERS_RESPONSE_PAGE_2='{"runners":[{"name":"preferred-runner-set-002","status":"online"}]}' \
    bash "${script}"
  )"

  printf '%s\n' "${output}" | grep -F 'Choose Runner: found 1 online runner(s) for the preferred runner set; using preferred-runner-set' >/dev/null
  printf '%s\n' "${output}" | grep -F 'runner=["preferred-runner-set"]' >/dev/null
}

run_case \
  "fork-pr" \
  "pull_request" \
  '{"pull_request":{"head":{"repo":{"fork":true}}}}' \
  "" \
  '{"runners":[]}' \
  '["ubuntu-latest"]' \
  'Choose Runner: untrusted fork PR; using fallback runner ubuntu-latest'

run_case \
  "trusted-no-token" \
  "push" \
  '{}' \
  "" \
  '{"runners":[]}' \
  '["ubuntu-latest"]' \
  'Choose Runner: trusted event but no org-runners-read-token secret available; using fallback runner ubuntu-latest'

run_case \
  "trusted-no-runners" \
  "push" \
  '{}' \
  "token" \
  '{"runners":[{"name":"other-set-001","status":"online"}]}' \
  '["ubuntu-latest"]' \
  'Choose Runner: found no online runners for the preferred runner set; using fallback runner ubuntu-latest'

run_case \
  "trusted-has-runner" \
  "push" \
  '{}' \
  "token" \
  '{"runners":[{"name":"preferred-runner-set-001","status":"online"}]}' \
  '["preferred-runner-set"]' \
  'Choose Runner: found 1 online runner(s) for the preferred runner set; using preferred-runner-set'

run_case \
  "non-fork-pr" \
  "pull_request" \
  '{"pull_request":{"head":{"repo":{"fork":false}}}}' \
  "token" \
  '{"runners":[{"name":"preferred-runner-set-003","status":"online"}]}' \
  '["preferred-runner-set"]' \
  'Choose Runner: found 1 online runner(s) for the preferred runner set; using preferred-runner-set'

run_case_multi_page

echo "test-choose-runner.sh: PASS"
