#!/bin/bash

# Load the assertions and fixtures library
. ${SOURCEDIR}/test/lib/assert.sh
. ${SOURCEDIR}/test/lib/fixtures.sh

assert "echo testing" "testing"
assert_end "basic"
