#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help(){
	# Display Help
	echo "gitus is git but simpler."
	echo
	echo "gitus ([-m \"commit message\"] -s)|(-r)"
	echo "options:"
	echo "h          Print this Help."
	echo "m          Add a commit message, default is \"Update\"."
	echo "s          Send your changes to the cloud."
	echo "r          Receive changes from the cloud."
	echo
}

CheckSSH(){
	if [ ! -f "~/.ssh/id_rsa" ] ; then
		email=$(git config --global --get "user.email")
		if [ -z "$email" ]; then
			read -p "[gitus] what is you're email? " email
		fi

		echo "[gitus] Generating SSH Key"
		ssh-keygen -t rsa -b 4096 -C "$email"
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_rsa

		echo "[gitus] Please add the SSH key to your account before proceeding. For more information"
		echo "[gitus] GitHub: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account"
	fi
}

Init(){
	git_vars_not_set_msg_shown=false

	CheckVar(){
		var=$1
		message=$2
		tmp=$(git config --global --get "$var")
		if [ -z "$tmp" ]; then
			if [ $git_vars_not_set_msg_shown = false ]; then
				echo "[gitus] Oh no! you haven't set git global variables yet. Let's do that"

				git_vars_not_set_msg_shown=true
			fi

			read -p "$message" tmp
			git config --global --add "$var" "$tmp"
		fi
	}

	CheckVar "user.name" "[gitus] what is you're user name? "
	CheckVar "user.email" "[gitus] what is you're email? "
}

Send(){
	# search for .git repo
	has_git_repo=$( ls -a | grep "^.git" | wc -l )

	if [ $has_git_repo = 0 ]; then
		Init
		CheckSSH
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

		s) echo "[gitus] Sending your changes to the cloud."
		Send
		;;

		r) echo "[gitus] Receiving changes from the cloud."
		Recieve
		;;

		\?) # Invalid option
		exit;;
	esac
done
