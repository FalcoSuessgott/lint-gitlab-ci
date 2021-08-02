TESTDIR?=testdata

.PHONY: test
test:
	@pre-commit try-repo https://github.com/FalcoSuessgott/pre-commit-gitlab-ci gitlab-ci --ref $(shell git branch --show-current)  --files $(TESTDIR)/valid-gitlab-ci.yml -v