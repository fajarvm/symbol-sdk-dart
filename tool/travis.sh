#!/bin/bash

# Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Run pub get to fetch packages.
pub get

# Verify that the all source code files are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS .

# Run the tests.
echo "Running all tests..."
pub run test test/test_all.dart --reporter expanded

# Gather coverage and upload to Coveralls.
if [ "$COVERALLS_TOKEN" ]; then
  OBS_PORT=9292
  echo "Collecting coverage on port $OBS_PORT..."

  # Start tests in one VM.
  echo "Running all tests..."
  dart \
    --enable-vm-service=$OBS_PORT \
    --pause-isolates-on-exit \
  test/test_all.dart &

  # Run the coverage collector to generate the JSON coverage report.
  collect_coverage \
    --port=$OBS_PORT \
    --out=var/coverage.json \
    --wait-paused \
    --resume-isolates

  # Convert the JSON coverage report to LCOV report
  echo "Generating LCOV report..."
  format_coverage \
    --lcov \
    --in=var/coverage.json \
    --out=var/lcov.info \
    --packages=.packages \
    --report-on=lib

  echo "LCOV report generated"
fi
