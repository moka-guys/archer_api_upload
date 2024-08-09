# archer_api_upload

This script uploads fastq.gz files from a given dir onto Archer platform and sumbits the job 

## Required inputs
- file path (string)
- archer password in Base64 Encoded format (string)
- job name (string)
- protocol id (integer)

## Expected outputs
- logfile.txt - txt file containg the log for file uploading and job submission
- sample_log.json - json file containing list of samples submitted for job
In addition to the output files above, it is expected that the submitted job starts running on Archer job platform (https://analysis.archerdx.com/home#running_jobs) 

### How to run the script
`bash main.sh <path/to/dir> <archer-passward> <job_name> <protocol_id> 2>&1 | tee -a /path/to/logfile/logfile.txt`

### How to run in Docker

Create docker image 
`docker build -t <image_name> .`

Run docker image
`docker run --user $UID:$GID -v </host/volume>:/<container/volume> <image_name> <path/for/container/volume> <archer-passward> <job_name> <protocol_id> | tee -a /path/to/logfile/logfile.txt`

Save docker image into targz for dnanexus app

`docker save <image_name>:<Tag> | gzip > <image_name>.tar.gz`