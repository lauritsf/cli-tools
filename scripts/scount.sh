#!/bin/bash

# AWK scripts (defined as variables)
awk_user_status_gres='
NR>1 {
    status = toupper(substr($2,1,1)) tolower(substr($2,2))
    status_counts[$1][status]++
    # Extract GPU count from GRES string (handle different formats)
    if ($3 ~ /gres:gpu(:[a-zA-Z]+)?(:[0-9]+)?/) {  # Match various "gres:gpu" formats
        match($3, /gres:gpu(:[a-zA-Z]+)?:([0-9]+)/, matches)  # Capture the number separately
        gpu_count = matches[2] ? matches[2] : 1
        gpu_counts[$1][status] += gpu_count  # Accumulate per user per state
    }
} 
END {
    for (user in status_counts) {
        for (status in status_counts[user]) {
            print user, status, gpu_counts[user][status], status_counts[user][status]
        }
    }
}'
awk_status_gres='
NR>1 {
    status = toupper(substr($1,1,1)) tolower(substr($1,2))
    status_counts[status]++
    # Extract GPU count from GRES string (handle different formats)
    if ($2 ~ /gres:gpu(:[a-zA-Z]+)?(:[0-9]+)?/) {  # Match various "gres:gpu" formats
        match($2, /gres:gpu(:[a-zA-Z]+)?:([0-9]+)/, matches)  # Capture the number separately
        gpu_count = matches[2] ? matches[2] : 1
        gpu_counts[status] += gpu_count  # Accumulate per status
    }
} 
END {
    for (status in status_counts) {
        print status, gpu_counts[status], status_counts[status]
    }
}'

awk_user_gres='
NR>1 {
    user_counts[$1]++
    # Extract GPU count from GRES string (handle different formats)
    if ($2 ~ /gres:gpu(:[a-zA-Z]+)?(:[0-9]+)?/) {  # Match various "gres:gpu" formats
        match($2, /gres:gpu(:[a-zA-Z]+)?:([0-9]+)/, matches)  # Capture the number separately
        gpu_count = matches[2] ? matches[2] : 1
        gpu_counts[$1] += gpu_count  # Accumulate per user
    }
} 
END {
    for (user in user_counts) {
        print user, gpu_counts[user], user_counts[user]
    }
}'


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
        echo "$header" | sed 's/ /  /g'  # Add extra spaces in the header
        echo "$squeue_output" | awk "$awk_script" | sort -k"$sort_key" -nr
    } | column -t
}

# Check if the script is being run as a program
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check for optional arguments
    if [ $# -eq 0 ] || [ "$1" == "" ]; then
        squeue_output=$(squeue -O UserName,State,Gres)
        process_counts "$awk_user_status_gres" 3 "USER STATUS GPU_COUNT JOB_COUNT" "$squeue_output"  # Changed header
    elif [ "$1" == "--status" ] || [ "$1" == "-s" ]; then
        squeue_output=$(squeue -O State,Gres)
        process_counts "$awk_status_gres" 2 "STATUS GPU_COUNT JOB_COUNT" "$squeue_output"  # Changed header
    elif [ "$1" == "--user" ] || [ "$1" == "-u" ]; then
        squeue_output=$(squeue -O UserName,Gres)
        process_counts "$awk_user_gres" 2 "USER GPU_COUNT JOB_COUNT" "$squeue_output"  # Changed header
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        show_help
    else
        echo "Invalid argument: $1" >&2
        show_help
        exit 1
    fi
fi
