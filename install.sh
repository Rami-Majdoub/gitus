#!/bin/bash

chmod +x ./gitus.sh

# ~/.bashrc
##### Begin of gitus edit #####
# if [ -d "$PWD" ] ; then
# 	PATH="$PATH:$PWD"
# fi
##### End of gitus edit #####

# ~/.bash_aliases
#alias gitus=gitus.sh


# add gitus directory to PATH
file=~/.bash_profile
path_contains_dir=$(cat $file | grep "PATH=\"\$PATH:$PWD\"" | wc -l)
if [ $path_contains_dir -eq 0 ]; then
	echo "Adding this directory to PATH"
	
	echo "" >> "$file"
	echo "##### Begin of gitus edit #####" >> "$file"
	echo "if [ -d "$PWD" ] ; then" >> "$file"
	echo "  export PATH=\"\$PATH:$PWD\"" >> "$file"
	echo "fi" >> "$file"
	echo "##### End of gitus edit #####" >> "$file"
fi

# gitus.sh > gitus
file=~/.bash_aliases
alias_exists=$(cat $file | grep "alias gitus=gitus.sh" | wc -l)
if [ $alias_exists -eq 0 ]; then
	echo "Creating alias"
	
	echo "alias gitus=gitus.sh" >> "$file"
fi

