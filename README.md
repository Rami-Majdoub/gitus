# gitus
gitus is Git but simpler.

Language: English, [Français](./README-fr.md)
## Installation
1- Open Git bash (right click -> Git Bash Here)

2- Navigate to home

	cd ~

3- Download this repository

	git clone https://github.com/Rami-Majdoub/gitus.git

4- Navigate inside the folder

	cd gitus

5- Install it

	chmod +x ./install.sh
	./install.sh

6- Open **another** window of Git Bash **(if you don't this won't work)** and check if it works

	gitus -h

## Basic options
Receive changes from the cloud (GitHub).

	gitus -r

Send your changes to the cloud (GitHub).

	gitus -s

## Advance options
the default commit message is "Update", to change it use

	gitus -m "added awesome feature" -s
