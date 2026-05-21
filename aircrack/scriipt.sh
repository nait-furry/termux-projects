#!/bin/bash
name=$(ls ./);
echo $name;

# capturing output into variables;
# passing arguments to the script ie: command-line arguments

file=$1
#<tool> file;

# checking if tool is installed
if command -v <tool> &> /dev/null; then 
	<tool> file
else
	echo "<tool> isn't installed"
fi


