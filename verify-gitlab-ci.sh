#!/usr/bin/env bash
set -e

declare -a ARGS
declare -a ENVS

parse_cmdline() {
  declare argv
  argv=$(getopt -o e:a: --long envs:,args: -- "$@") || return
  eval "set -- $argv"

  for argv; do
    case $argv in
      -a | --args)
        shift
        ARGS+=("$1")
        shift
        ;;
      -e | --envs)
        shift
        ENVS+=("$1")
        shift
        ;;
      --)
        shift
        GITLAB_CI="$1"
        [[ "$1" == "" ]] && GITLAB_CI=".gitlab-ci.yml"
        break
        ;;
    esac
  done
}

check_command() {
  [[ $(command -v "$1") ]] || {
    echo >&2 "$1 needs to be installed."
    exit 1
  }
}

check_envvar() {
  [[ "$1" != "" ]] || {
    echo >&2 "\"$1\" needs to be set."
    exit 1
  }
}

check_file() {
  [[ -f "$1" ]] || {
    echo >&2 "\"$1\" does not exist."
    exit 1
  }
}

validate() {
  response=$(jq --null-input --arg yaml "$(< "$1")" '.content=$yaml' | curl -s -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://${GITLAB_SERVER_URL}/api/v4/ci/lint?include_merged_yaml=true" --header 'Content-Type: application/json' --data @-)
  code=$?

  message=$(echo "$response" | jq '.message' | tr -d "\"")
  status=$(echo "$response" | jq '.status' | tr -d "\"")
  warnings=$(echo "$response" | jq '.warning')
  errors=$(echo "$response" | jq '.errors')

  [[ "$message" != "null" ]] && {
    echo >&2 "$message"
    exit 1
  }

  echo -e "==> $1 is $status.\n"

  [[ "$warnings" != "null" ]] && {
    code=1
    echo >&2 -e "Warnings: $warnings\n"
  }
  [[ "$errors" != "null" ]] && {
    code=1
    echo >&2 -e "Errors: $errors\n"
  }

  exit "$code"
}

set_env() {
  local var var_name var_value
  for var in "${ENVS[@]}"; do
    var_name="${var%%=*}"
    var_value="${var#*=}"

    export "$var_name"="$var_value"
  done
}

main() {
  check_command "jq"
  check_command "curl"

  parse_cmdline "$@"

  check_file "$GITLAB_CI"

  set_env

  check_envvar "GITLAB_TOKEN"
  check_envvar "GITLAB_SERVER_URL"

  validate "$GITLAB_CI"
}

main "$@"
