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

# Perform subdomain enumeration using assetfinder
echo "Starting subdomain enumeration using assetfinder ..."
echo "======================================== Assetfinder Sub Domain Enumeration =================================================" > $output_file
assetfinder --subs-only $target_url >> $output_file
echo "Subdomain enumeration complete."

# Perform passive reconnaissance using waybackurls
echo "Starting passive reconnaissance using waybackurls ..."
echo "======================================== Waybackurls Passive Reconnaissance =================================================" >> $output_file
waybackurls $target_url >> $output_file
echo "Passive reconnaissance complete."

# Perform active reconnaissance using amass
echo "Starting active reconnaissance using amass ..."
echo "======================================== Amass Active Reconnaissance =================================================" >> $output_file
amass enum -d $target_url >> $output_file
echo "Active reconnaissance complete."

# Perform screenshotting using aquatone
echo "Starting screenshotting process using aquatone ..."
echo "========================================  Aquatone Screenshooting  =================================================" >> $output_file
aquatone-scan -d $target_url -o aquatone-result
echo "Screenshotting complete."

# All recon process complete
echo "Bug bounty recon process complete. Results stored in $output_file."
