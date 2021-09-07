#!/bin/bash

chmod +x ./gitus.sh

started_edit=false
beginEdit(){
	if [ $started_edit = false ]; then
		echo "##### Begin of gitus edit #####" >> ~/.profile
		started_edit=true
	fi
}

endEdit(){
	if [ $started_edit = true ]; then
		echo "##### End of gitus edit #####" >> ~/.profile
	fi
}

# add gitus directory to PATH
path_contains_dir=$(cat ~/.profile | grep $PWD | wc -l)
if [ $path_contains_dir -eq 0 ]; then
	echo "Adding this directory to PATH"
	beginEdit
	echo "export PATH=\"\$PATH:$PWD\"" >> ~/.profile
fi

# gitus.sh > gitus
alias_exists=$(cat ~/.profile | grep "alias gitus=gitus.sh" | wc -l)
if [ $alias_exists -eq 0 ]; then
	echo "Creating alias"
	beginEdit
	echo alias gitus=gitus.sh >> ~/.profile
fi

endEdit