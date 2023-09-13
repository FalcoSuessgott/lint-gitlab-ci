# pre-commit-hook: lint-gitlab-ci

**Warning: This Hook has been updated and tested for Gitlab 16.x. There is no gurantee it works for earlier versions ([Link](https://docs.gitlab.com/ee/api/lint.html#validate-the-ci-yaml-configuration-deprecated)).**

[pre-commit-hook](https://pre-commit.com) validating and linting your `.gitlab.ci.yml` using the [`/ci/lint/`](https://docs.gitlab.com/ee/api/lint.html) API endpoint.

[![shellcheck](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/FalcoSuessgott/lint-gitlab-ci/actions/workflows/shellcheck.yml)

## Features

* includes merged or imported gitlab-ci configurations
* automatically detect Gitlab Server & Project Path by using `git remote`
* specify custom gitlab-ci.yml

## Dependencies

* `jq`
* `curl`

## Prerequisites

> you will need to export `GITLAB_TOKEN` with scope `api`, otherwise you will receive `401 Unauthorized`:

```sh
# ## token with api scope
export GITLAB_TOKEN="abc123"
```

## Usage

> Add to your `pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/FalcoSuessgott/lint-gitlab-ci
    rev: v0.0.6
    hooks:
      - id: gitlab-ci
```

## Configuration

```yaml
repos:
  - repo: https://github.com/FalcoSuessgott/lint-gitlab-ci
    rev: v0.0.6
    hooks:
      - id: gitlab-ci
        args: [ ".custom-ci-file.yml" ]
```
