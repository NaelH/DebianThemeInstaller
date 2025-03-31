#!/bin/bash

# material.sh
# Permet de mettre d'installer material theme
# Usage : ./material.sh [username]
#
# Auteur : NaelH
# Version : 1.0.0
#
# Dépendace :
# git
# npm
# droit administrateur

# Variables
havenpm=0
havemeson=0
localdirectory="/tmp/material-install"
# Fonction d'erreur
erreur() {
	echo "************************************************************"
	echo "Erreur: $1"
	echo "ERRCODE: $2"
	echo "************************************************************"
	exit $2

}

# Blindage
[ "$EUID" != "1" ] && erreur "Vous devez lancer ce script avec sudo." 2
[ $# -ne 1 ] && erreur "./material.sh [votre nom d'utilisateur]"
lienicon = "/home/$1"
[ ! -e "$lienicon" ] && erreur "Le nom d'utilisateur/dossier d'installation n'est pas correct." 10
[ ! -r "$lienicon" ] && erreur "Le dossier d'installation n'est pas accessible en lecture." 20

# Est-ce que l'utilisateur a npm
echo "Avez-vous installer npm ? (Y/n)"
read npm
[ "$npm" == "Y" -o "$npm" == "y" ] && havenpm=1
clear

# Est-ce que l'utilisateur a meson
echo "Avez-vous installer meson ? (Y/n)"
read meson
[ "$meson" == "Y" -o "$meson" == "y" ] && havemeson=1

# Installation de npm

if [ havenpm -eq 0 ]; then

	clear
	echo "Souhaitez vous installer npm? (Y/n)"
	read reponse
	[ "$reponse" != "Y" -o "$reponse" != "y" ] && erreur "Nous ne pouvons pas fonctionner sans npm." 3
	# Installation de npm pre-accepter
	apt install npm -y
	echo "Installation de npm réussi."
fi

if [ havemeson -eq 0 ]; then
	clear
	echo "Souhaitez-vous installer meson ? (Y/n)"
	read reponse
	[ "$reponse" != "Y" -o "$reponse" != "y" ] && erreur "Nous ne pouvons fonctionner sans meson." 5
	apt install meson -y
	echo "Installation de meson réussi"
fi

clear
echo "Création d'un dossier temporaire..."
mkdir "$localdirectory"
echo "Création du dossier local : OK"
echo "Création du dossier d'icone ($lienicon)..."
mkdir "$lienicon"
echo "Création du dossier d'icone : OK"
cd "$localdirectory"
echo "Déplacement vers le dossier temporaire : OK"
echo "Clonage du repository github..."
git clone "https://github.com/nana-4/materia-theme"
echo "Clonage du repository github : OK"
echo "Installation du theme..."
cd materia-theme
meson _build
meson install -C _build
meson _build -Dprefix="$localrepository/.local" -Dcolors=default,dark -Dsizes=compact
echo "Installation du theme : OK"
echo "Installation des icones"
cd "$lienicon"
echo "Lancement de wget vers https://github.com/Macintosh98/Material-Originals-Icons/archive/refs/heads/main.zip"
wget "https://github.com/Macintosh98/Material-Originals-Icons/archive/refs/heads/main.zip"
echo "Récupération des icones : OK"
echo "==================================================================="
echo "Installation effectuée avec succès. Veuillez suivre les étapes suivantes : "
echo "1 : Aller dans Applications > Settings > Appareance puis cocher Material-Theme-[Dark-compact/Dark/Light]"
echo "2 : Cliquer sur Icons et cliquer sur add"
echo "3 : Aller dans $lienicon et double cliquer sur le fichier zip"
echo "4 : Profiter de votre poste"


echo "Script d'installation arrêter avec succès"
exit 0 
