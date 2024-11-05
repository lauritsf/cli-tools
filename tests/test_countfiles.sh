#!/bin/bash

# test_countfiles.sh

# Get the absolute path to the project directory
project_dir=$(pwd)

# Counters for passed and failed tests
passed_tests=0
failed_tests=0

# Function to run countfiles.sh and check the output
run_countfiles() {
    local args="$@"
    local expected_exit_code=$1
    shift

    # Separate the local declaration to capture the acutal exit code
    local actual_output
    local actual_exit_code
    actual_output=$("$project_dir"/scripts/countfiles.sh "$@" 2>&1)
    actual_exit_code=$?

    if [ $actual_exit_code -ne $expected_exit_code ]; then
        echo "Test failed: countfiles.sh $args (expected exit code: $expected_exit_code, actual exit code: $actual_exit_code)"
        test_failed=1
    fi

    if [ "$actual_output" != "$expected_output" ]; then
        echo "Test failed: countfiles.sh $args (output mismatch)"
        echo "Expected output:"
        echo "$expected_output"
        echo "Actual output:"
        echo "$actual_output"
        test_failed=1
    fi

    if [ $test_failed ]; then
        ((failed_tests++))
    else
        ((passed_tests++))
    fi
}

# --- Test cases ---

# Test with no arguments (default directory - current directory)
mkdir -p testdir
mkdir -p testdir/subdir
touch testdir/file1.txt testdir/file2.txt testdir/file3.txt testdir/subdir/file4.txt testdir/subdir/file5.txt
cd testdir

expected_output=$(cat <<EOF
total 5
COUNT  DIRECTORY
3      .
2      ./subdir
EOF
)
run_countfiles 0

cd ..

expected_output=$(cat <<EOF
total 5
COUNT  DIRECTORY
3      testdir
2      testdir/subdir
EOF
)
run_countfiles 0 "-d" "testdir"

rm -rf testdir

# Test with -h flag
expected_output=$(cat <<EOF
Usage: $project_dir/scripts/countfiles.sh [-d directory] [-h|--help]
  -d directory  Specify the directory to count files in (default: current directory)
  -h, --help    Display this help message
EOF
)
run_countfiles 0 "-h"

# Test with an invalid option
expected_output=$(cat <<EOF
Invalid option: -x
Usage: $project_dir/scripts/countfiles.sh [-d directory] [-h|--help]
  -d directory  Specify the directory to count files in (default: current directory)
  -h, --help    Display this help message
EOF
)
run_countfiles 1 "-x"

# Test with a non-existent directory
expected_output="Error: Directory 'nonexistent_dir' does not exist."
run_countfiles 1 "-d" "nonexistent_dir"

# --- Unit tests for functions ---
source "$project_dir/scripts/countfiles.sh"

# Test show_help
test_show_help() {
    local expected_output=$(cat <<EOF
Usage: tests/test_countfiles.sh [-d directory] [-h|--help]
  -d directory  Specify the directory to count files in (default: current directory)
  -h, --help    Display this help message
EOF
)
    local actual_output=$(show_help)
    if [ "$actual_output" != "$expected_output" ]; then
        echo "Test failed: show_help"
        echo "Expected output:"
        echo "$expected_output"
        echo "Actual output:"
        echo "$actual_output"
        ((failed_tests++))
    else
        ((passed_tests++))
    fi
}
test_show_help

# --- Print test summary ---
echo "-----------------------------"
echo "Test Summary for countfiles.sh:"
echo "Passed: $passed_tests"
echo "Failed: $failed_tests"
