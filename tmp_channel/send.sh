#!/bin/bash

# Store the secret message
secret=$1

# Account for a preexisting tmp directory
rm -rf tmp

# Create a new tmp directory and go into it
mkdir tmp
cd tmp

# Create a tmp file with an arbitrary message
touch tmp.txt
echo "This is a test" >> tmp.txt

# Cut down the permissions to just those that are relevant
raw_perms=$(ls -l tmp.txt)
perms=$(cut -c 2-10 <<< $raw_perms | cut -c 1,2-9)

# Returns the current count of links the file has
current_link_count=$(ls -l tmp.txt | cut -c 12)

# The length of the secret message
len=${#secret}

# Loop through the secret message
for ((j = 0; j < len; j++));
do
	# Get the current char of the secret message
	char=${secret:j:1}
	
	# Account for if the character is a space
	if [[ "$char" == " " ]]
	then
		chmod 200 tmp.txt
	else
		# Convert the current char to binary
		binary_char=$(echo $char | perl -lpe '$_=unpack"B*"')

		# Add a 1 in the second binary spot to signify the first w in chmod
		binary_r=$(cut -c 1 <<< $binary_char)	
		binary_after_rw=$(cut -c 2-8 <<< $binary_char)
		binary_char_with_write="${binary_r}1${binary_after_rw}"

		# Split the binary into 3 rwx commands and convert them to decimal
		rwx1=$(cut -c 1-3 <<< $binary_char_with_write)
		rwx1="$((2#$rwx1))"
		rwx2=$(cut -c 4-6 <<< $binary_char_with_write)
		rwx2="$((2#$rwx2))"
		rwx3=$(cut -c 7-9 <<< $binary_char_with_write)
		rwx3="$((2#$rwx3))"
	
		# Change the file permissions
		chmod $rwx1$rwx2$rwx3 tmp.txt
	fi

    # Create a symbolic link to indicate the permissions of the file should be read again
	ln tmp.txt $j
		
	# Give the reciever program a little time to update
	sleep .5
done

# Give the recieve program a second to catch up, if needed
sleep 1
# Remove the tmp directory and all contents within
cd ..
rm -rf tmp
