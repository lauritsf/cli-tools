#!/bin/bash

# test_scount.sh

# Counters for passed and failed tests
passed_tests=0
failed_tests=0

run_scount() {
  local args="$@"
  local expected_exit_code=$1
  shift

  ./scripts/scount.sh "$@" > /dev/null 2>&1
  local actual_exit_code=$?

  if [ $actual_exit_code -ne $expected_exit_code ]; then
    echo "Test failed: scount.sh $args (expected exit code: $expected_exit_code, actual exit code: $actual_exit_code)"
    ((failed_tests++))
  elif [ "$actual_output" != "$expected_output" ]; then
    echo "Test failed: scount.sh $args (output mismatch)"
    echo "Expected output:"
    echo "$expected_output"
    echo "Actual output:"
    echo "$actual_output"
    ((failed_tests++))
  else
    ((passed_tests++))
  fi
}


valid_options=(
    ""
    "-u"
    "--user"
    "-s"
    "--status"
    "-h"
    "--help"
)
for option in "${valid_options[@]}"; do
  run_scount 0 "$option"
done

invalid_options=(
  "-x"
  "-u -s"
  "--user --status"
  "invalid"
  "123"
)
for option in "${invalid_options[@]}"; do
  run_scount 1 "$option"
done



# --- Unit tests for functions ---
source "scripts/scount.sh"

# Test show_help
test_show_help() {
  local expected_output=$(cat <<EOF
Usage: $0 [-u|-s|-h|--user|--status|--help]
  -u, --user     Count jobs by user
  -s, --status   Count jobs by status
  -h, --help     Display this help message
  (no flags)      Count jobs by user and status
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

# Test data (using defined strings)
squeue_u_t_output="\
USER STATE
user1 PENDING
user2 PENDING
user1 PENDING
user1 RUNNING
user2 RUNNING"

scount_u_output="\
USER   STATUS   COUNT
user1  Pending  2
user2  Running  1
user2  Pending  1
user1  Running  1"

squeue_s_output="\
STATE
PENDING
PENDING
PENDING
RUNNING
RUNNING"

scount_s_output="\
STATUS   COUNT
Pending  3
Running  2"

squeue_u_output="\
USER
user1
user2
user1
user1
user2"

scount_us_output="\
USER   COUNT
user1  3
user2  2"

# Test process_counts
test_process_counts() {
  local awk_script="$1"
  local sort_key="$2"
  local header="$3"
  local squeue_output="$4"
  local expected_output="$5"

  local actual_output=$(process_counts "$awk_script" "$sort_key" "$header" "$squeue_output" | column -t)
  if [ "$actual_output" != "$expected_output" ]; then
    echo "Test failed: process_counts '$awk_script' '$sort_key' '$header'"
    echo "Expected output:"
    echo "$expected_output"
    echo "Actual output:"
    echo "$actual_output"
    ((failed_tests++))
  else
    ((passed_tests++))
  fi
}

test_process_counts "$awk_user_status" 3 "USER STATUS COUNT" "$squeue_u_t_output" "$scount_u_output"
test_process_counts "$awk_status" 2 "STATUS COUNT" "$squeue_s_output" "$scount_s_output"
test_process_counts "$awk_user" 2 "USER COUNT" "$squeue_u_output" "$scount_us_output"

# Print test summary
echo "---------------------------"
echo "Test Summary for scount.sh:"
echo "Passed: $passed_tests"
echo "Failed: $failed_tests"
