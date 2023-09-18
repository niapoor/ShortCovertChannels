#!/bin/bash

# Keeping the program running while it's waiting
i=0
while [[ !(-f "tmp/tmp.txt") ]]
do
	i=$(( i + 1 ))
done

prev_link_int=0
# ignore_first=true
# Run while the tmp directory and tmp file both exist
while [[ -f "tmp/tmp.txt" ]]
do
	current_link_int=$(ls -l tmp/tmp.txt 2> /dev/null | cut -c 12-13)
	if [[ $current_link_int -ne $prev_link_int ]]
	then
		# Cut down the permissions to just those that are relevant
		raw_perms=$(ls -l tmp/tmp.txt  2> /dev/null)
		perms=$(cut -c 2-10 <<< $raw_perms | cut -c 1,2-9)
		binary_with_w=$(echo $perms | sed 's/r/1/g' | sed 's/w/1/g' | sed 's/x/1/g' | sed 's/-/0/g')

		# Remove the first w from the binary
		binary_r=$(cut -c 1 <<< $binary_with_w)	
		binary_after_rw=$(cut -c 3-9 <<< $binary_with_w)
		binary="${binary_r}${binary_after_rw}"
		
		# Don't account for the permissions of the file initially
		if [[ "$binary" -ne "10100100" ]]
		then
			echo $binary | perl -lpe '$_=pack"B*",$_'
		fi
			
		# Update the previous link int
		prev_link_int=$current_link_int
	fi
done
