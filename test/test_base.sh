#!/bin/bash

# Load the assertions and fixtures library
. ./lib/assert.sh
. ./lib/fixtures.sh

TESTCASE="basic"

assert "echo testing" "testing"
assert "echo testing" "testing"
assert "echo testing" "testing"
assert_end $TESTCASE

TESTCASE="basic2"

assert "echo testing2" "testing2"
assert "echo testing2" "testing2"
assert "echo testing2" "testing2"
assert_end $TESTCASE