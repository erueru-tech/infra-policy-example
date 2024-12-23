#!/usr/bin/env sh

set -eu

[[ -z ${CI:-} ]] && OPT="-w" || OPT="--fail --list"
opa fmt $OPT policy/
