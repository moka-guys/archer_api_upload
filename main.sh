#!/bin/bash

# get command line arguments
file_path=${1}
pw=${2}
job_name=${3}
protocol_id=${4}

# get fastq file path and extension to search all R1 fastq files
file_extension="*R1_001.fastq.gz"
files_to_upload=$file_path$file_extension

# create json for sample list

samples=$(jq -n --arg v "$job_name" '{"job_name": $v}')

# loop over all R1 fastq files and get the pair
for fq in $files_to_upload
do
base_name=$(basename "$fq" _R1_001.fastq.gz) 
mapfile -d '' file_array < <(find $file_path -name "${base_name}*.fastq.gz" -print0 2>/dev/null)
file1=${file_array[0]}
file2=${file_array[1]}
file1_filepath="file-upload://$(basename $file1)"
file2_filepath="file-upload://$(basename $file2)"

# append the paried samples into sample list
temp=$(echo $samples| jq --arg y "$file1_filepath" --arg z "$file2_filepath" '.samples += [{
    "sequence_files": [$y, $z]
}]')
samples=$temp

# upload fastq files to archer
for file in "${file_array[@]}"; do
    echo "Uploading $file"
    curl -X 'POST' \
      'https://analysis.archerdx.com/api/file-uploads/' \
      -H 'accept: application/json' \
      -H 'Content-Type: multipart/form-data' \
      -H "Authorization: Basic $pw" \
      -F "file=@$file;type=application/gzip"

done
echo "Files uploading done"

done
# get sample list for job submission
sample_list=$samples
echo $sample_list | json_reformat > ${file_path}/sample_log.json
# submit job with all samples
echo "Submitting job"
curl -X 'POST' \
  "https://analysis.archerdx.com/api/job-submission/protocols/${protocol_id}/submit-job" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "Authorization: Basic $pw" \
  -d "$sample_list"

echo "Job submission done"


