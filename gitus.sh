#!/bin/bash

# declare repo=$0
# echo $repo

# declare g=$(git status)
# echo $g

############################################################
# Help                                                     #
############################################################
Help(){
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo gitus send|recieve|s|r [-option]
   echo "options:"
   echo "h          Print this Help."
   echo "s|send     Send your changes to the cloud."
   echo     [-m "message"] add a commit message, default is "Update".
   echo "r|recieve  Recieve the changes from the cloud."
   echo
}

send(){
    if false; then
      git init
      git branch -M main
      git remote add origin git@github.com:Rami-Majdoub/gitus.git

      git add -A
      git commit -m "first commit"
      git push -u origin main
    else
      git add -A
      git commit -m "update"
      git push
    fi
}

recieve(){
  git pull
}

while getopts "hsrm:" flag;
do
    case "${flag}" in
        h) Help
           exit;;

        m) msg=${OPTARG}
           ;;

        \?) # Invalid option
           Help
           exit;;
    esac
done

case $1 in
  send | s)
    echo send
    send
    ;;

  recieve | r)
    echo recieve
    recieve
    ;;
esac