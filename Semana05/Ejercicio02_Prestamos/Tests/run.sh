#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
testdir=$(mktemp -d)
trap 'rm -rf "$testdir"' EXIT
swiftc CalculadoraPrestamos/Calculator.swift Tests/main.swift -o "$testdir/tests"
"$testdir/tests"
