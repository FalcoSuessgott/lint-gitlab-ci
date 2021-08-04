TESTDIR?=testdata

.PHONY: test
test:
	@pre-commit try-repo https://github.com/FalcoSuessgott/lint-gitlab-ci gitlab-ci --ref $(shell git branch --show-current) --files $(TESTDIR)/valid-gitlab-ci.yml && echo "\nvalidates ==> test passed\n"
	@pre-commit try-repo https://github.com/FalcoSuessgott/lint-gitlab-ci gitlab-ci --ref $(shell git branch --show-current) --files $(TESTDIR)/invalid-gitlab-ci.yml || echo "\nshould fail ==> test passed\n"