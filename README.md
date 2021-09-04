# gitus
gitus is git but simpler.

## Installation
Download this repository to the preferred location, open the terminal (cmd) in that location and run.
````
chmod +x ./install.sh
./install.sh
````

## Basic options
Receive changes from the cloud.
````
gitus -r
````

Send your changes to the cloud.
````
gitus -s
````

## Advance options
the default commit message is "Update", to change it use
````
gitus -m "added awesome feature" -s
````
