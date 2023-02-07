#!/bin/bash

# Define default values for target URL and output file
target_url=""
output_file=""

# Parse command-line options using getopt
options=$(getopt -o t:o: --long target_url:,output_file: -- "$@")

# Check if getopt was successful
if [ $? -ne 0 ]; then
  echo "Usage: $0 --target_url <target_url> --output_file <output_file>"
  exit 1
fi

# Assign parsed options to variables
eval set -- "$options"
while true; do
  case "$1" in
    -t|--target_url)
      target_url="$2"
      shift 2
      ;;
    -o|--output_file)
      output_file="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

# Check if the target URL was parsed correctly
if [ -z "$target_url" ]; then
  echo "Error: target URL not specified."
  echo "Usage: $0 --target_url <target_url> --output_file <output_file>"
  exit 1
fi

# Check if the output file was parsed correctly
if [ -z "$output_file" ]; then
  echo "Error: output file not specified."
  echo "Usage: $0 --target_url <target_url> --output_file <output_file>"
  exit 1
fi

# Perform port scanning using nmap
echo "Starting port scanning..."
nmap -Pn -p- $target_url >> $output_file
echo "Port scanning complete."

# Perform directory scanning using dirb
echo "Starting directory scanning..."
dirb http://$target_url/ >> $output_file
dirb https://$target_url/ >> $output_file
echo "Directory scanning complete."

# Perform web server and application scanning using nikto
echo "Starting web server and application scanning..."
nikto -h $target_url >> $output_file
echo "Web server and application scanning complete."

# All scan process complete
echo "Bug bounty scan process complete. Results stored in $output_file."
