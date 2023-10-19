#!/bin/bash
 
set -e
trap "echo 'Error: Script terminated' >&2" ERR
 
# Command to check if a file exists
if [ ! -f /path/to/file ]; then
  echo 'Error: File does not exist' >&2
  exit 1
fi
 
# Command to remove a file
rm /path/to/file || {
  echo 'Error: Unable to remove file' >&2
  exit 1
}
 
# Command to restart Apache web server
sudo service apache2 restart || {
  echo 'Error: Unable to restart Apache' >&2
  exit 1
}
