# archer_api_upload v1.0.0

This repository contains the scripts required for use in uploading fastq files and submitting job on Archer, via the API.

## Required inputs
- file path (string) - dir where all fastq files are located
- archer password file (string) - file path containing authentication password for archer
- job name (string)
- protocol id (integer)

## Expected outputs
- logfile.txt - txt file containg the log for file uploading and job submission
- sample_log.json - json file containing the list of samples submitted for the job.
In addition to the output files above, it is expected that the submitted job starts running on Archer job platform (https://analysis.archerdx.com/home#running_jobs) 

### How to run the script
```
bash main.sh <path/to/dir> <archer-passward> <job_name> <protocol_id> 2>&1 | tee -a /path/to/logfile/logfile.txt
```

## Docker image
Build the docker container which contains all scripts with `make`

The docker image can be run as follows:
```
docker run --user $UID:$GID -v </host/volume>:/<container/volume> <image_name> <path/for/container/volume> <archer/passward/file/path> <job_name> <protocol_id> | tee -a /path/to/logfile/logfile.txt
```
