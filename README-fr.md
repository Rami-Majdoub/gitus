# gitus
gitus est Git mais plus simple.

Langue: [English](./README.md), Français
## Installation
1- Ouvrez Git bash (clic droit -> Git Bash Here)

2- Accédez au dossier racine

	cd ~

3- Télécharger ce dossier

	git clone https://github.com/Rami-Majdoub/gitus.git

4- Accédez au dossier gitus

	cd gitus

5- Installez-le

	chmod +x ./install.sh
	./install.sh
	source ~/.bashrc

6- Vérifiez si cela fonctionne

	gitus -h

## Options de base
Recevez les modifications depuis le cloud (GitHub).

	gitus -r

Envoyez vos modifications vers le cloud (GitHub).

	gitus -s

## Options avancées
le message de validation par défaut est "Update", pour le changer, utilisez

	gitus -m "ajout d'une fonctionnalité géniale" -s
