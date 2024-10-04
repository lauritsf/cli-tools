#!/bin/bash

# Function to display help message
show_help() {
  echo "Usage: $0 [-d directory] [-h|--help]"
  echo "  -d directory  Specify the directory to count files in (default: current directory)"
  echo "  -h, --help    Display this help message"
}

# Function to count files in a directory
count_files() {
  local directory="$1"

  # Check if the directory exists
  if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist." >&2
    exit 1
  fi

  # Count files in the specified directory and its subdirectories, and sort the output
  {
    echo "COUNT  DIRECTORY"  # Add header
    {

      # Count files in the root directory
      count=$(find "$directory" -type f -maxdepth 1 -printf "." 2>/dev/null | wc -c) 
      echo "$count $directory"

      # Count files in subdirectories
      for dir in "$directory"/{.,}*; do
        if [ -d "$dir" ] && [ "$dir" != "$directory/." ] && [ "$dir" != "$directory/.." ]; then
          count=$(find "$dir" -type f -printf "." 2>/dev/null | wc -c)
          echo "$count $dir"
        fi
      done
    } | sort -nr
  } | column -t
}

# Main function
main() {
  # Get directory from command-line arguments
  directory="."
  if [ "$1" == "-d" ] && [ -n "$2" ]; then
    directory="$2"
    shift 2
  elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
  elif [ -n "$1" ]; then  # Check for invalid options
    echo "Invalid option: $1" >&2
    show_help
    exit 1
  fi

  count_files "$directory"
}

# Check if the script is being run as a program
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
