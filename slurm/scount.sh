#!/bin/bash

show_help() {
  echo "Usage: $0 [--user|--status|--help]"
  echo "  --user    Count jobs by user"
  echo "  --status  Count jobs by status"
  echo "  --help    Display this help message"
  echo "  (no flags) Count jobs by user and status" 
}

# Function to process and print job counts
process_counts() {
  local awk_script="$1"
  local sort_key="$2"
  local header="$3"
  local squeue_format="$4"

  squeue_output=$(squeue -o "$squeue_format")

  # Process, sort, and format data using 'column -t' (including header)
  { 
    echo "$header"
    echo "$squeue_output" | awk "$awk_script" | sort -k"$sort_key" -nr 
  } | column -t
}

# Check for optional arguments
if [ "$1" == "--status" ]; then
  process_counts 'NR>1 {status_counts[toupper(substr($1,1,1)) tolower(substr($1,2))]++} END {for (status in status_counts) {print status, status_counts[status]}}' \
                 2 "STATUS COUNT" "%T" 
elif [ "$1" == "--user" ]; then
  process_counts 'NR>1 {user_counts[$1]++} END {for (user in user_counts) {print user, user_counts[user]}}' \
                 2 "USER COUNT" "%u"
elif [ "$1" == "--help" ]; then
  show_help
else
  process_counts 'NR>1 {status_counts[$1][toupper(substr($2,1,1)) tolower(substr($2,2))]++} END {for (user in status_counts) {for (status in status_counts[user]) {print user, status, status_counts[user][status]}}}' \
                 3 "USER STATUS COUNT" "%u %T"
fi
