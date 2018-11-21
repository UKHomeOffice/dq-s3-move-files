#!/bin/bash
# This script will connect to an S3 bucket, list 25 files at the source location
# A for loop will process one file at a tme and move it from the source to the destination object
# It will then get the appropriate prefix to use based on the timestamp in the file name YYYY|MM|DD
# Using REGEX it will start moving only the files that match the regex into the new prefixes based on the timestamp

set -e

S3_BUCKET_NAME=bucket_name
SOURCE_PATH=src
DESTINATION_PATH=dest
REGEX='PARSED_[0-9]{8}_[0-9]{4}_[0-9]{4}.zip'
FILE_LIMIT=100

# List items from S3
function get_list_new {
  array=$(s3cmd ls --limit $FILE_LIMIT s3://$S3_BUCKET_NAME/$SOURCE_PATH/ | awk '{$1=$2=$3=""; print $0}' | sed 's_s3://bucket_name/src/__' | sed 's/^[ \t]*//')
  echo $array
}

# Move files to the new locations based on the file name obtained from the array
function move_files {
  declare -a array=$(get_list_new)
  for file in ${array[@]}; do
        echo "$(date "+%Y-%m-%d %H:%M:%S") File found '${file}'"
        YEAR=$(echo "${file:7:4}")
        MONTH=$(echo "${file:11:2}")
        DAY=$(echo "${file:13:2}")
        s3cmd mv --no-progress --rexclude ".*"  --rinclude $REGEX s3://$S3_BUCKET_NAME/$SOURCE_PATH/${file} s3://$S3_BUCKET_NAME/$DESTINATION_PATH/$YEAR/$MONTH/$DAY/${file} || continue
        echo "$(date "+%Y-%m-%d %H:%M:%S") Moved file to S3 '${file}'"
  done
}

# Create Main function
function main {
  move_files
}

main

exit
