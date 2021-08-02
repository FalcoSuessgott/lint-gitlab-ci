#!/usr/bin/env bash
set -e

GITLAB_SERVER_URL=${GITLAB_SERVER_URL:-"gitlab.com"}
CI_FILE=${1:-".gitlab-ci.yml"}
TOKEN=${GITLAB_TOKEN:-""}
URL="https://${GITLAB_SERVER_URL}/api/v4/ci/lint?include_merged_yaml=true"

stderr() {
  echo >&2 -e "$@"
  exit 1
}

validate() {
  response=$(jq --null-input --arg yaml "$(< "$CI_FILE")" '.content=$yaml' | curl -s -H "PRIVATE-TOKEN: ${TOKEN}" -H 'Content-Type: application/json' "$URL" --data @-)

  message=$(echo "$response" | jq '.message' | tr -d "\"")
  status=$(echo "$response" | jq '.status' | tr -d "\"")
  warnings=$(echo "$response" | jq '.warning')
  errors=$(echo "$response" | jq '.errors')

  [[ "$message" != "null" ]] && stderr "$message"
  [[ "$status" == "valid" ]] && {
    echo "$CI_FILE validates."
    exit 0
  }
  [[ "$warnings" != "null" ]] && {
    stderr "Warnings: $warnings"
    exit 1
  }
  [[ "$errors" != "null" ]] && {
    stderr "Errors: $errors"
    exit 1
  }
}

main() {
  [[ "$TOKEN" == "" ]] && stderr "GITLAB_TOKEN needs to be set."
  [[ $(command -v "yq") ]] || stderr "yq needs to be installed."
  [[ $(command -v "curl") ]] || stderr "curl needs to be installed."
  [[ -f "$CI_FILE" ]] || stderr "file $CI_FILE does not exist."

  validate
}

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
