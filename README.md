# pre-commit-gitlab-ci

[pre-commit-hook](https://pre-commit.com) for validating and linting your `.gitlab.ci.yml` using the `/ci/lint/` API endpoint.

[![test](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/test.yml/badge.svg)](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/test.yml)
[![shellcheck](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/shellcheck.yml)

# Dependencies
* `yg`
* `curl`
* `GITLAB_TOKEN` (otherwise you will receive `401 Unauthorized`)

# Features
* includes merged (imported) configurations
* specifiy custom gitlab server
* specifiy custom gitlab-ci file

# Usage
> Add to your `pre-commit-config.yaml`:
```
- repo: https://github.com/FalcoSuessgott/pre-commit-gitlab-ci
  rev: main
  hooks:
    - id: gitlab-ci
      args:
        - '--envs=GITLAB_SERVER_URL="private.gitlab.com"' # private gitlab server
        - '--envs=GITLAB_TOKEN="xxxxx"' # private gitlab token with API permissions
        - '-- custom-gitlab-ci.yml' # in case you have a custom .gitlab-ci.yml
```