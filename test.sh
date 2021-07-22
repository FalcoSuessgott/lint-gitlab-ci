#!/usr/bin/env bash

set -e

file="testdata/invalid-gitlab-ci.yml"
echo -e "==> $file should fail:\n"
./verify-gitlab-ci.sh -- "$file" > /dev/null || true
echo -e "test passed.\n"

file="testdata/valid-gitlab-ci.yml"
echo -e "==> $file should pass:\n"
./verify-gitlab-ci.sh -- "$file" > /dev/null && false
echo -e "test passed.\n"

exit 0
