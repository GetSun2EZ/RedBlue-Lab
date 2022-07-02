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
	tp_red_log_run_vm
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
	read -p "Appuyer sur une touche pour continuer..."
	echo -e "\n"
}


tp_red_log_run_vm(){

	echo "[~] Décompression de la VM vulnérable\n"
	if [ ! -e ../VM/vm_red_log.zip ]
	then
		#wget -o ../VM/vm_red_log.zip LIEN
	fi
	#unzip ../VM/vm_red_log.zip
	
	echo "[~] Lancement de la VM vulnérable"
	#vmrun -T ws start../VM/vm_red_log/vm_red_log.vmx

	echo -e "\n\n"
}

tp_red_log_etape_0(){
	echo "------------------------------------------------------------------"
	echo " Etape 0 - Prérequis sur la machine attaquante"
	echo "------------------------------------------------------------------"

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

	read -p "Appuyer sur une touche pour continuer avec l'étape 1..."
	echo -e "\n"

}

tp_red_log_etape_1(){
	echo "------------------------------------------------------------------"
	echo " Etape 1 - Explication de la vulnérabilité"
	echo "------------------------------------------------------------------"

	echo "
La vulnérabilité Log4Shell a été découverte en fin 2021 par l'équipe de sécurité cloud d'Alibaba.
Le scrore CVSS de cette vulnérabilité est de 10 : CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H

Un score aussi haut est dû au fait que la vulnérabilité permet à l'attaquant d'exécuter du code arbitraire sur la machine distance. C'est une RCE.
"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
La vulnérabilité se base sur le framework Log4J développé par Apache Software Foundation qui permet de gérer toutes les journalisations des applications Java.
Ce framework est tellement utile, qu'il est utilisé dans la plupart des logiciels Java. Beaucoup de bibliothèques Java utilise aussi ce framework. Cette utilisation massive a permit à log4Shell d'etre exploitée à grande échelle.
Dans les versions vulnérables du framework Log4J, il était possible de faire des rêquetes LDAP, DNS, RMI et JNDI qui n'était pas vérifiées et donc de faire appel à des ressources externes.
"

	read -p "Appuyer sur une touche pour continuer avec l'étape 2..."
	echo -e "\n"

}

tp_red_log_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "
Enfin de trouver la ou les vulnérabilités à exploiter, il faut explorer la machine victime et obtenir un maximum d'informations dessus.
La méthodologie est donc,
	- dans un premier temps, de scanner le réseau afin de trouver la machine victime.
	- dans un deuxième temps, de scanner les ports ouverts ainsi que les services qui tournent.
	- dans un troisième temps, de vérifier si des applications sont actives
	- dans un quatième temps, d'explorer si c'est des vulnérabilités sont disponibles sur ces applications.

Il peut être juditieux de prendre des notes pour garder des traces de ses recherches et des trouvailles.
"

	read -p "Lorsque votre exploration est finie. Appuyer sur une touche pour continuer avec l'étape 3..."
	echo -e "\n"

}

tp_red_log_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'exploitation"
	echo "------------------------------------------------------------------"

	echo "
A ce stade, normalement, vous avez trouvé l'adresse IP de la machine victime, que la technologie utilisé est 'Apache Solr' sur le port '80'
La version d'Apache Solr est '8.11.0'.
La version de Java utilisé '1.8.0_181'.

Après avoir obtenu toutes ces informations, il faut rechercher s'il est possible de trouver des vulnérabilités sur ces applications et versions.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Maintenant grâce à internet, il faut chercher s'il existe des vulnérabilités bien connues sur cette application et si des exploits peuvent être utilisés avec ou sans modifications.
"

	read -p "Lorsque que vous pensez avoir trouver la méthode d'exploitation. Appuyer sur une touche pour continuer avec l'étape 4..."
	echo -e "\n"

}

tp_red_log_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Exploitation et capture du drapeau utilisateur"
	echo "------------------------------------------------------------------"

	echo "
Lors des recherches, on remarque que l'application qu'on utilise est vulnérable à Log4Shell car Solr est en version 8.11.0 et utilise la version 1.8.0_181 de Java, ce qui est exactement ce qu'il faut pour utiliser la vulnérabilité Log4Shell.

Pour exploiter la vulnérabilité, il faut trouver l'URI où l'on peut intéragir avec une entrée utilisateur.
Après avoir trouvé le champs que l'on peut contrôler, il faut injecter une charge utile simple pour vérifier si la vulnérabilité est présente.
Ensuite, lorsqu'on a détecté et confirmé l'endroit où la charge utile doit être positionné, il faut exploiter correctement la vulnérabilité afin d'obtenir un accès shell.
"
	read -p "Appuyer sur une touche pour obtenir un indice si vous avez des difficultés à exploiter la vulnérabilité..."

	echo "
Indice : 
	- Un WAF est peut-être présent
	- Il sera peut-être nécessaire de trouver des moyens de contournement afin d'exploiter la vulnérabilité.
"

	echo "
Lorsqu'on obtient un accès shell, un drapeau est disponible dans le dossier courant.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Si vous n'arrivez pas à exploiter la vulnérabilité, la solution est disponible en MarkDown dans le dossier 'Linux/solutions'
"

	read -p "Appuyer sur une touche pour continuer avec l'étape 5..."
	echo -e "\n"
}

tp_red_log_etape_5(){
	echo "------------------------------------------------------------------"
	echo " Etape 5 - Escalade de privilége et capture du drapeau administrateur"
	echo "------------------------------------------------------------------"

	echo "
A cette étape, vous devriez avoir obtenir le drapeau de l'utilisateur. Le drapeau utilisateur est flag{jndiIsAGoodAPI}.

Pour finir completement le TP, il faut obtenir le drapeau administrateur. Il faut donc trouver un moyen de faire un escalade de privilèges.

Des outils sont très pratiques pour trouver des moyens de faire des escalades de privilèges.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Félicitations, vous avez terminé le TP et obtenu tous les drapeaux.
Le drapeau administrateur est flag{becarefulWithSUID}
"
	read -p "Appuyer sur une touche pour finir le TP..."
	echo -e "\n"
}

tp_red_log_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"

	echo "[~] Arret de la machine virtuelle\n"
	vmrun -T ws stop ../VM/vm_red_log/vm_red_log.vmx

	echo "[~] Suppression du dossier de la machine virtuelle\n"
	rm -dfr ./VM/vm_red_log

	read -p "Appuyer sur une touche pour retourner au menu..."

}
