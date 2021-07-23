# pre-commit-gitlab-ci

[pre-commit-hook](https://pre-commit.com) for validating and linting your `.gitlab.ci.yml` using the [`/ci/lint/`](https://docs.gitlab.com/ee/api/lint.html) API endpoint.

[![shellcheck](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/FalcoSuessgott/pre-commit-gitlab-ci/actions/workflows/shellcheck.yml)

# Features
* includes merged or imported gitlab-ci configurations
* specify custom Gitlab Server URL
* specify custom gitlab-ci.yml

# Dependencies
* `yg`
* `curl`

# Prerequisites
> you will need to export `GITLAB_TOKEN`, otherwise you will receive `401 Unauthorized`
```bash
export GITLAB_TOKEN="abc123"
pre-commit run
```

# Usage
> Add to your `pre-commit-config.yaml`:
```
- repo: https://github.com/FalcoSuessgott/pre-commit-gitlab-ci
  rev: v0.0.2
  hooks:
    - id: gitlab-ci
```

# Configuration
## specify custom gitlab-ci.yml
```bash
- repo: https://github.com/FalcoSuessgott/pre-commit-gitlab-ci
  rev: v0.0.2
  hooks:
    - id: gitlab-ci
      args: .custom-ci-file.yml
```

## custom Gitlab Server URL
> export `GITLAB_SERVER_URL` (defaults to `gitlab.com`) and run `pre-commit`
```bash
export GITLAB_SERVER_URL="custom-gitlab.tld"
pre-commit run
```