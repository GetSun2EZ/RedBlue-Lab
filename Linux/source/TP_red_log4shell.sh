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
	read -p "Appuyer sur une touche pour continue avec l'étape 1..."
	echo -e "\n"
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

	echo "
Dans cette étape, il sera nécessaire d'obtenir certains paquets et outils sur votre machine servant à attaquer."
Le(s) paquet(s) suivant(s) sont à installer : maven
"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
La version de Java 8u181-b13 est recommandée et peut-etre installée avec le lien suivant : ' https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz '
Enfin de décompresser le fichier .tar.gz : 'tar xzvf jdk-8u181-linux-x64.tar.gz'
Deux binaires seront intéressants dans ce dossier : 'jdk1.8.0_181/bin/java' et 'jdk1.8.0_181/bin/javac'
"
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

	echo "
La vulnérabilité Log4Shell a été découverte en fin 2021 par l'équipe de sécurité cloud d'Alibaba.
Le scrore CVSS de cette vulnérabilité est de 10 : CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H

Un score aussi haut est du au fait que la vulnérabilité permet à l'attaquant d'exécuter du code arbitraire sur la machine distance. C'est une RCE.
"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
La vulnérabilité se base sur le framework Log4J développé par Apache Software Foundation qui permet de gérer toutes les journalisations des applications Java.
Ce framework est tellement utile, qui est utilisé dans la plupart des logiciels Java. Beaucoup de bibliothèque Java utilise aussi ce framework. Cette utilisation massive a permit à log4Shell d'etre exploité à grande échelle.
Dans les versions vulnérables à Log4Shell de framework, il était possible de faire des rêquetes LDAP, DNS, RMI et JNDI qui n'était pas vérifié et donc de faire appel à des ressources externes.
"

	read -p "Appuyer sur une touche pour continue avec l'étape 2..."
	echo -e "\n"

}

tp_red_log_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Enfin de trouver la ou les vulnérabilités à exploiter, il faut explorer la machine victime et obtenir un maximum d'informations dessus.
La méthodologie est donc,
	- dans un premier temps, de scanner le réseau afin de trouver la machine victime.
	- dans un deuxieme temps, de scanner les ports ouverts ainsi que les services qui tournent.
	- dans un troisième temps, de vérifier si des applications sont actives
	- dans un quartième temps, d'explorer si c'est des vulnérabilités sont disponibles sur ces applications.

Il peut être juditieux de prendre des notes pour garder des traces de ses recherches et des trouvailles.
"

	read -p "Lorsque votre exploration est finie. Appuyer sur une touche pour continue avec l'étape 3..."
	echo -e "\n"

	#nmap
	#quelle application ?
	#version ?
	#vulnérabilité disponibles ?
}

tp_red_log_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'exploitation"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
A ce stade, normalement, vous avez trouvé l'adresse IP de la machine victime, que la technologie utilisé est 'Apache Solr' sur le port '8983'
La version d'Apache Solr est '8.11.0'.
La version de Java utilisé '1.8.0_181'.

Après avoir obtenu toutes ces informations, il faut rechercher s'il est possible de trouver des vulnérabilités sur ces applications et versions.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "

"

	read -p "Lorsque que vous pensez avoir trouver la méthode d'exploitation. Appuyer sur une touche pour continue avec l'étape 4..."
	echo -e "\n"


	#Recherche sur internet des potientiels outils, l'application a des failles connu bien particuliere ?

}

tp_red_log_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Exploitation et capture du drapeau utilisateur"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	

	read -p "Appuyer sur une touche pour continue avec l'étape 5..."
	echo -e "\n"
}

tp_red_log_etape_5(){
	echo "------------------------------------------------------------------"
	echo " Etape 5 - Escalade de privilége et capture du drapeau administrateur"
	echo "------------------------------------------------------------------"

	read -p "Appuyer sur une touche pour continuer..."

	

	read -p "Appuyer sur une touche pour finir le TP..."
	echo -e "\n"
}

tp_red_log_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}
