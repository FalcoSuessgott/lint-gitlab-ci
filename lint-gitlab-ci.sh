#!/usr/bin/env bash
set -e

# GITLAB_SERVER_URL=${GITLAB_SERVER_URL:-"gitlab.com"}
# ## get gitlab push remote
GITLAB_REMOTE=$(git remote -v | grep push | awk '{print $2}')
# ## remove useless parts
# ## git urls (everything bevore @)
GITLAB_REMOTE=${GITLAB_REMOTE#*@}
# ## https urls (everythin before //)
GITLAB_REMOTE=${GITLAB_REMOTE#*//}
# ## .git ending
GITLAB_REMOTE=${GITLAB_REMOTE%.git}

# ## get the url
GITLAB_SERVER_URL=$(echo "${GITLAB_REMOTE:?}" | cut -d':' -f1)
# ## get the project name and URL encode
GITLAB_PROJECT=$(echo "${GITLAB_REMOTE:?}" | cut -d':' -f2 | sed 's#/#%2F#g' )
# ## get project ID
# GITLAB_PROJECT_ID=$(curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN:?}" "https://${GITLAB_SERVER_URL:?}/api/v4/projects/${GITLAB_PROJECT:?}" | jq '.id')

CI_FILE=${1:-".gitlab-ci.yml"}
TOKEN=${GITLAB_TOKEN:-""}
# ## ENDPOINT: see https://docs.gitlab.com/ee/api/lint.html
# ## old endpoint, deprecated since 15.7, removed in 16.0
# API_ENDPOINT=ci/lint
# ## new endpoint: /projects/:id/ci/lint
API_ENDPOINT=projects/${GITLAB_PROJECT:?}/ci/lint
URL="https://${GITLAB_SERVER_URL}/api/v4/${API_ENDPOINT:?}?include_merged_yaml=true"

stderr() {
  printf >&2 "Error: %s\n" "$@"
}

validate() {
  response=$(jq --null-input --arg yaml "$(< "$CI_FILE")" '.content=$yaml' | curl -s -H "PRIVATE-TOKEN: ${TOKEN}" -H 'Content-Type: application/json' "$URL" --data @-)

  valid=$(echo "$response" | jq '.valid')
  warnings=$(echo "$response" | jq '.warning')
  errors=$(echo "$response" | jq '.errors')

  [[ "$valid" == "true" ]] && {
    printf "%s validated.\n" "$CI_FILE"
    exit 0
  }
  [[ "$warnings" != "null" ]] && {
    printf "Warnings: %s\n" "$warnings"
    exit 1
  }
  [[ "$errors" != "null" ]] && {
    stderr "$errors"
    exit 1
  }
}

main() {
  [[ "$TOKEN" == "" ]] && stderr "GITLAB_TOKEN needs to be set."
  [[ $(command -v "jq") ]] || stderr "jq needs to be installed."
  [[ $(command -v "curl") ]] || stderr "curl needs to be installed."
  [[ -f "$CI_FILE" ]] || stderr "$CI_FILE does not exist."

  validate
}

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
