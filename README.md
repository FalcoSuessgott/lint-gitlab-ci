# pre-commit-gitlab-ci

https://pre-commit.com

## Example
```sh
- repo: https://github.com/FalcoSuessgott/pre-commit-gitlab-ci
  rev: master
  hooks:
    - id: gitlab-ci
      args:
        - '--args=GITLAB_SERVER_URL=https://gitlab.com'
        - '--args=GITLAB_CI_FILE=.gitlab-ci.yml'
```