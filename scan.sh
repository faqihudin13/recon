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
echo -en '\n' >> $output_file
echo "========================================= Scan using Nmap =========================================================" > $output_file
nmap -Pn -p- -sV $target_url -oN nmap-output.txt
cat nmap-output.txt >> $output_file
rm -rf nmap-output.txt
echo -en '\n' >> $output_file
echo "Port scanning complete."

# Perform directory scanning using dirb
echo "Starting directory scanning..."
echo -en '\n' >> $output_file
echo "========================================= Fuzzing using Dirb =========================================================" >> $output_file
dirb http://$target_url/ -o dirb-output-http.txt
cat dirb-output-http.txt >> $output_file
rm -rf dirb-output-http.txt
dirb https://$target_url/ -o dirb-output-https.txt
cat dirb-output-https.txt >> $output_file
rm -rf dirb-output-https.txt
echo -en '\n' >> $output_file
echo "Directory scanning complete."

# Perform web server and application scanning using nikto
echo "Starting web server and application scanning..."
echo -en '\n' >> $output_file
echo "========================================= Scan using Nikto =========================================================" >> $output_file
nikto -h $target_url -o nikto-output.txt
cat nikto-output.txt >> $output_file
rm -rf nikto-output.txt
echo -en '\n' >> $output_file
echo "Web server and application scanning complete."

# All scan process complete
echo -en '\n' >> $output_file
echo "Bug bounty scan process complete. Results stored in $output_file."
