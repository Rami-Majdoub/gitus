#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help(){
	# Display Help
	echo "gitus is git but simpler."
	echo
	echo "gitus ([-m \"commit message\"] -s) | -r [repo_url] | -(h|l|u)"
	echo "options:"
	echo "h          Print this Help."
	echo "m          Add a commit message, default is \"Update\"."
	echo "s          Send your changes to the cloud."
	echo "r          Receive changes from the cloud."
	echo "l          Activate/deactivate learning mode."
	echo "u          Update gitus."
	echo
}

debug=$(git config --bool --default true gitus.debug)
Run(){
	if [[ $debug = true ]]; then
		echo "[gitus] $ $@"
	fi
	"$@"
}

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
		Run git config --global "$var" "$tmp"
	fi
}

CheckSSH(){
	if [ ! -f ~/.ssh/id_rsa ] ; then
		CheckVar "user.email" "[gitus] what is you'r email? "

		email=$(git config --global --get "user.email")

		echo "[gitus] Generating SSH Key"
		Run ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa
		Run eval "$(ssh-agent -s)"
		Run ssh-add ~/.ssh/id_rsa

		echo
		echo "[gitus] ⚠️  Please add the SSH key to your account before proceeding. For more information"
		echo "[gitus] GitHub: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account"
		read -p "[gitus] press Enter to continue "
	fi
}

Init(){
	CheckVar "user.name" "[gitus] what is you'r user name? "
	CheckVar "user.email" "[gitus] what is you'r email? "
	git config --global init.defaultBranch main # only 1 time !
}

Send(){
	Init
	CheckSSH

	# search for .git repo
	has_git_repo=$( ls -ap | egrep "^\.git/$" | wc -l )
	if [ $has_git_repo = 0 ]; then
		Run git init

		if [ -z "$msg" ]; then
			msg="first commit"
		fi
	fi

	# the remote is not set for new repos and generated projet
	if [ -z "$(git remote)" ]; then
		repo_name="$(basename "$PWD")"
		user_name="$(git config --global --get user.name)"

		Run git remote add origin git@github.com:"$user_name"/"$repo_name".git
		had_no_remote=true # to set default branch to main after commit
	fi

	if [ -z "$msg" ]; then
		msg="Update"
	fi
	Run git add -A
	Run git commit -m "\"$msg\"" # outer quotes needed for Run(), inner quotes for Run.echo
	if [[ $had_no_remote = true ]]; then
		Run git branch -M main # needed only one time after first commit
	fi

	remote="$(git remote show)"
	current_branch="$(git branch --show-current)"
	Run git push -u "$remote" "$current_branch"
}

Receive(){
	if [ -z "$clone_url" ]; then
		Run git pull
	else
		Run git clone "$clone_url"
	fi
}

while getopts "rhm:slu" flag;
do
	case "${flag}" in
		h) Help
			exit
		;;

		m) msg=${OPTARG}
		;;

		s) echo "[gitus] Sending your changes to the cloud."
			Send
		;;

		r) echo "[gitus] Receiving changes from the cloud."
			eval nextopt=\${$OPTIND}
			# echo "$nextopt"
			# https://stackoverflow.com/questions/11517139/optional-option-argument-with-getopts
			if [[ -n $nextopt && $nextopt != -* ]] ; then
	      OPTIND=$((OPTIND + 1))
			fi
			clone_url=${nextopt}
			Receive
		;;

		l)
			d=$(git config --bool --default true gitus.debug)
			if [[ "$d" = true ]]; then
				echo "[gitus] Learning mode is not active"
				git config --global "gitus.debug" false
			else
				echo "[gitus] Learning mode is active"
				git config --global "gitus.debug" true
			fi
		;;

		u)
			echo "[gitus] Downloading updates"
			gitus_folder=$(dirname -- "$0")
			cd $gitus_folder
			git pull
		;;

		\?) # Invalid option
		exit;;
	esac
done
