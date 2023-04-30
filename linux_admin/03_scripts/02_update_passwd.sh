#!/bin/bash

# Set the input file name
input_file="users.txt"

# Set the output file name
output_file="password_update.log"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file $input_file does not exist"
  exit 1
fi

DATE=$(date +%c)
echo "$DATE" | tee -a "$output_file"

# Check if the output file exists, and create it if it doesn't
if [ ! -f "$output_file" ]; then
  touch "$output_file"
fi

# Loop through the lines of the input file
while read line; do
  # Split the line into the user and password
  user=$(echo "$line" | awk '{print $1}')
  password=$(echo "$line" | awk '{print $2}')

  # Check if the user already exists
  if id "$user" &>/dev/null; then

    # Create the user with the given password
    echo "$user:$password" | chpasswd >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "Updated password for $user" | tee -a "$output_file"
    else
      echo "Failed to update password for  $user" | tee -a "$output_file"
      exit 1
    fi
  else
    echo "User $user does not exist, skipping" | tee -a "$output_file"
  fi
done < "$input_file"

# Exit with a success code
exit 0

