#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd src && echo "Switched to src directory"

echo "Installing dependencies..."

npm install

echo "Running test suite"

npm test

CODE=$?

echo "Test exited with status code ${CODE}."

exit $CODE