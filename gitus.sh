#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help(){
	# Display Help
	echo "gitus is git but simpler."
	echo
	echo "gitus ([-m "commit message"] -s)|(-r)"
	echo "options:"
	echo "h          Print this Help."
	echo "m          Add a commit message, default is \"Update\"."
	echo "s          Send your changes to the cloud."
	echo "r          Receive changes from the cloud."
	echo
}

Init(){
	git_vars_not_set_msg_shown=false

	CheckVar(){
		var=$1
		message=$2
		tmp=$(git config --global --get "$var")
		if [ -z "$tmp" ]; then
			if [ $git_vars_not_set_msg_shown = false ]; then
				echo "Oh no! you haven't set git global variables yet. Let's do that"

				git_vars_not_set_msg_shown=true
			fi

			read -p "$message" tmp
			git config --global --add "$var" "$tmp"
		fi
	}

	CheckVar "user.name" "what is you're user name? "
	CheckVar "user.email" "what is you're email? "
}

Send(){
	# search for .git repo
	has_git_repo=$( ls -a | grep "^.git" | wc -l )

	if [ $has_git_repo = 0 ]; then
		Init
		repo_name="$(basename "$PWD")"
		user_name="$(git config --global --get user.name)"

		git init
		git branch -M main
		git remote add origin git@github.com:"$user_name"/"$repo_name".git
		
		if [ -z "$msg" ]; then
			msg="first commit"
		fi
	fi
	if [ -z "$msg" ]; then
		msg="Update"
	fi
	git add -A
	git commit -m "$msg"

	remote="$(git remote show)"
	current_branch="$(git branch --show-current)"
	git push -u "$remote" "$current_branch"
}

Recieve(){
	git pull
}

while getopts "hm:sr" flag;
do
	case "${flag}" in
		h) Help
		exit;;

		m) msg=${OPTARG}
		;;

		s) echo Sending your changes to the cloud.
		Send
		;;

		r) echo Receiving changes from the cloud.
		Recieve
		;;

		\?) # Invalid option
		exit;;
	esac
done
