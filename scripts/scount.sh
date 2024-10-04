#!/bin/bash

# AWK scripts (defined as variables)
awk_user_status='NR>1 {status_counts[$1][toupper(substr($2,1,1)) tolower(substr($2,2))]++} END {for (user in status_counts) {for (status in status_counts[user]) {print user, status, status_counts[user][status]}}}'
awk_status='NR>1 {status_counts[toupper(substr($1,1,1)) tolower(substr($1,2))]++} END {for (status in status_counts) {print status, status_counts[status]}}'
awk_user='NR>1 {user_counts[$1]++} END {for (user in user_counts) {print user, user_counts[user]}}'

show_help() {
  echo "Usage: $0 [-u|-s|-h|--user|--status|--help]"
  echo "  -u, --user     Count jobs by user"
  echo "  -s, --status   Count jobs by status"
  echo "  -h, --help     Display this help message"
  echo "  (no flags)      Count jobs by user and status"
}

# Function to process and print job counts
process_counts() {
  local awk_script="$1"
  local sort_key="$2"
  local header="$3"
  local squeue_output="$4"

  # Process, sort, and format data using 'column -t' (including header)
  {
    echo "$header"
    echo "$squeue_output" | awk "$awk_script" | sort -k"$sort_key" -nr
  } | column -t
}

# Check if the script is being run as a program
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Check for optional arguments
  if [ $# -eq 0 ] || [ "$1" == "" ]; then
    squeue_output=$(squeue -o "%u %T")
    process_counts "$awk_user_status" 3 "USER STATUS COUNT" "$squeue_output"
  elif [ "$1" == "--status" ] || [ "$1" == "-s" ]; then
    squeue_output=$(squeue -o "%T")
    process_counts "$awk_status" 2 "STATUS COUNT" "$squeue_output"
  elif [ "$1" == "--user" ] || [ "$1" == "-u" ]; then
    squeue_output=$(squeue -o "%u")
    process_counts "$awk_user" 2 "USER COUNT" "$squeue_output"
  elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
  else
    echo "Invalid argument: $1" >&2
    show_help
    exit 1
  fi
fi
