# lint-gitlab-ci

[pre-commit-hook](https://pre-commit.com) for validating and linting your `.gitlab.ci.yml` using the [`/ci/lint/`](https://docs.gitlab.com/ee/api/lint.html) API endpoint.

[![shellcheck](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/shellcheck.yml)
[![test](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/test.yml/badge.svg)](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/test.yml)

# Features
* includes merged or imported gitlab-ci configurations
* specify custom Gitlab Server URL
* specify custom gitlab-ci.yml

# Dependencies
* `jq`
* `curl`

# Prerequisites
> you will need to export `GITLAB_TOKEN`, otherwise you will receive `401 Unauthorized`:
```sh
export GITLAB_TOKEN="abc123"
```

> export `GITLAB_SERVER_URL` in order to specify your private Gitlab Server (default is `gitlab.com`):
```sh
export GITLAB_SERVER_URL="custom-gitlab.tld"
```

# Usage
> Add to your `pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/FalcoSuessgott/lint-gitlab-ci
    rev: v0.0.4
    hooks:
      - id: gitlab-ci
```

# Configuration
```yaml
repos:
  - repo: https://github.com/FalcoSuessgott/lint-gitlab-ci
    rev: v0.0.4
    hooks:
      - id: gitlab-ci
        args: [ ".custom-ci-file.yml" ]
```