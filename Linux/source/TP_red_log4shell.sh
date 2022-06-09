#!/bin/bash

# Ce script a pour but d'afficher le TP Red_Log4Shell
#
# Créateurs		: D'ARCO Adrien, POUDENS Valentin
# Date de création 	: 22/03/2022
# Date de mise à jour 	: 26/03/2022

#
# Remarque : Tous les chemins partent de RedBlue-Lab/Linux/.
#

tp_red_log_main(){
        tp_red_log_CLEAR_BANNIERE
	#tp_red_log_run_vm
	tp_red_log_etape_0
	tp_red_log_etape_1
	tp_red_log_etape_2
	tp_red_log_etape_3
	tp_red_log_etape_4
	tp_red_log_etape_5
	tp_red_log_retour_menu
}


tp_red_log_CLEAR_BANNIERE(){
/bin/clear
	echo "#################################################################"
	echo "# ______         _______ _                   _           _      #"
	echo "# | ___ \       | | ___ \ |                 | |         | |     #"
	echo "# | |_/ /___  __| | |_/ / |_   _  ___ ______| |     __ _| |__   #"
	echo "# |    // _ \/ _\` | ___ \ | | | |/ _ \______| |    / _\` | '_ \  #"
	echo "# | |\ \  __/ (_| | |_/ / | |_| |  __/      | |___| (_| | |_) | #"
	echo "# \_| \_\___|\__,_\____/|_|\__,_|\___|      \_____/\__,_|_.__/  #"
	echo "#                                                               #"
	echo "#################################################################"
	echo "------------------------------------------------------------------"
	echo " Mise en pratique sur la vulnérabilité Log4Shell en Red Team"
	echo "------------------------------------------------------------------"
	echo -e "\n"
}


tp_red_log_run_vm(){

	echo "[~] Décompression de la VM vulnérable"
	if [ -e ../VM/vm_red_log.zip ]
	then
		unzip ../VM/vm_red_log.zip
	fi

	echo "[~] Lancement de la VM vulnérable"
	 ../VM/vm_red_log/vm_red_log.vmx

	echo -e "\n\n"
}

tp_red_log_etape_0(){
	echo "------------------------------------------------------------------"
	echo " Etape 0 - Prérequis sur la machine attaquante"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."
	echo -e "\n"

	echo "Dans cette étape, il sera nécessaire d'obtenir certains paquets et outils sur votre machine servant à attaquer."
	echo "Le(s) paquet(s) suivant(s) sont à installer : maven"
	echo -e "\n"

	read -p "Appuyer sur une touche pour continuer..."
	echo -e "\n"

	echo "La version de Java 8u181-b13 est recommandée et peut-etre installée avec le lien suivant : ' https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz '"
	echo "Enfin de décompresser le fichier .tar.gz : 'tar xzvf jdk-8u181-linux-x64.tar.gz'"
	echo "Deux binaires seront intéressants dans ce dossier : 'jdk1.8.0_181/bin/java' et 'jdk1.8.0_181/bin/javac'"
	echo -e "\n"

	read -p "Appuyer sur une touche pour continuer..."
	echo -e "\n"

	echo "L'outil marshalsec est recommandé et peut-etre obtenu avec le lien suivant : ' https://github.com/mbechler/marshalsec '"
	echo -e "\n"

	read -p "Appuyer sur une touche pour continue avec l'étape 1..."
	echo -e "\n"

}

tp_red_log_etape_1(){
	echo "------------------------------------------------------------------"
	echo " Etape 1 - Explication de la vulnérabilité"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_red_log_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	#nmap
	#quelle application ?
	#version ?
	#vulnérabilité disponibles ?
}

tp_red_log_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	#Recherche sur internet des potientiels outils, l'application a des failles connu bien particuliere ?

}

tp_red_log_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Exploitation et capture du drapeau utilisateur"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_red_log_etape_5(){
	echo "------------------------------------------------------------------"
	echo " Etape 5 - Escalade de privilége et capture du drapeau administrateur"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_red_log_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}
