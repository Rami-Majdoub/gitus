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

send(){
  # search for .git repo
  is_new_repo=$(ls -a | grep "\.git" | wc -l)

  if [ $is_new_repo = 0 ]; then
    repo_name=$(basename "$PWD")
    user_name=$(git config --global --get user.name)

    git init
    git branch -M main
    git remote add origin git@github.com:$user_name/$repo_name.git

    git add -A
    git commit -m "first commit"
    git push -u origin main
  else
    git add -A
    git commit -m "$msg"
    git push
  fi
}

recieve(){
  git pull
}

msg="update"
while getopts "hm:sr" flag;
do
    case "${flag}" in
        h) Help
           exit;;

        m) msg=${OPTARG}
           ;;

        s) echo Sending your changes to the cloud.
           send
           ;;

        r) echo Receiving changes from the cloud.
           recieve
           ;;

        \?) # Invalid option
           exit;;
    esac
done
