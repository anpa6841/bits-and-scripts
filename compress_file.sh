### ./compress_file.sh PE.mov
#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Input file and output file
input_file="$1"
output_file="${input_file%.*}_out.${input_file##*.}"

# Compress the video using ffmpeg (H.264 codec example)
ffmpeg -i "$input_file" -vcodec libx264 -preset fast -crf 28 "$output_file"

# Check if the compression was successful
if [ $? -eq 0 ]; then
  echo "Compression successful: $output_file"
else
  echo "Compression failed!"
fi

