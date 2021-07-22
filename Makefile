TESTDIR?=testdata
include: .envrc

.PHONY: test
test:
	@./verify-gitlab-ci.sh -a "testdata/invalid-gitlab-ci.yml" && echo "test passed"
	@./verify-gitlab-ci.sh -a "testdata/valid-gitlab-ci.yml" && echo "test passed"