#!/usr/bin/env sh

set -eu

conftest verify --show-builtin-errors
conftest test --all-namespaces .
