# dq-s3-move-files

Bash script that moves files between key prefixes in S3.
It creates key prefixes based on the timestamp found in the file name.

# Dependencies:
 - aws cli
 - s3cmd
 - AWS creds and profile setup with *s3cmd*

# S3CMD CLI modules to use:
- s3cmd ls s3://bucket-name: to list the content
- s3cmd mv s3://bucket-name/file.txt s3://bucket-name/subfolder/file.txt

# Variables:

|Variable Name|Value|Usage|
| ------------- |:-------------:| -----:|
|S3_BUCKET_NAME|bucket_name|Working S3 bucket|
|SOURCE_PATH|src|Bucket source prefix|
|DESTINATION_PATH|src|Bucket destination prefix|
|REGEX|'PARSED_[0-9]{8}_[0-9]{4}_[0-9]{4}.zip'|Regular expression value|
|FILE_LIMIT|100|Batch size|
