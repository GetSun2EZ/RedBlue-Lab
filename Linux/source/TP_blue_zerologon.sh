#!/bin/bash

# Ce script a pour but d'afficher le TP Blue_zerologon
#
# Créateurs		: D'ARCO Adrien, POUDENS Valentin
# Date de création 	: 22/03/2022
# Date de mise à jour 	: 26/03/2022


tp_blue_zero_main(){
     tp_blue_zero_CLEAR_BANNIERE
	tp_blue_zero_run_vm
	tp_blue_zero_etape_1
	tp_blue_zero_etape_2
	tp_blue_zero_etape_3
	tp_blue_zero_etape_4
	tp_blue_zero_retour_menu
}


tp_blue_zero_CLEAR_BANNIERE(){
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
	echo " Mise en pratique sur la vulnérabilité Zerologon en blue Team"
	echo "------------------------------------------------------------------"
	echo -e "\n"
}


tp_blue_zero_run_vm(){

	if [ ! -d ../VM/vm_blue_zero] && [ ! -e ../VM/vm_blue_zero.zip ]
	then
	  wget -q --show-progress http://62.212.90.183:9090/vm_blue_zero.zip -O ../VM/vm_blue_zero.zip
	  unzip ../VM/vm_blue_zero.zip
	fi
	if [ ! -d ../VM/vm_blue_zero] && [ -e ../VM/vm_blue_zero.zip ]
	then
	  unzip ../VM/vm_blue_zero.zip
	fi
	
	echo "[~] Lancement de la VM vulnérable"
	vmrun -T ws start../VM/vm_blue_zero/vm_blue_zero.vmx

	echo -e "\n\n"
}

tp_blue_zero_etape_1(){
	echo "------------------------------------------------------------------"
	echo " Etape 1 - Explication de la vulnérabilité"
	echo "------------------------------------------------------------------"

	echo "
Le 11 août 2020, Microsoft publie une mise à jour de sécurité comprenant un correctif pour une vulnérabilité critique du protocole NETLOGON (CVE-2020-1472) découverte par les chercheurs de Secura. 
La vulnérabilité possède un score CVSS de 10 : CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H

Cette vulnérabilité est critique car elle permet à un attaquant non authentifié disposant seulement d'un accès réseau à un contrôleur de domaine, d'établir une session Netlogon vulnérable et éventuellement d'obtenir des privilèges d'administrateur de domaine. 
	"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
Cette vulnérabilité exploite une faille cryptographique dans le protocole MS-NRPC (Active Directory Netlogon Remote Protocol) de Microsoft. Elle permet aux utilisateurs de se connecter à des serveurs qui utilisent NT LAN Manager (NTLM).

L'attaque se concentre principalement sur une mauvaise implémentation de la cryptographie. Pour être plus précis, Microsoft a choisi d'utiliser AES-CFB8 pour une fonction appelée ComputeNetlogonCredential, ce qui est normalement sécurisé, sauf que le vecteur d'initialisation a été défini sur une valeur fixe de 16 octets de zéro.

Lorsqu'un attaquant envoie un message contenant uniquement des zéros avec l'IV de zéro, il y a 1 chance sur 256 que le texte chiffré soit zéro.
	
De plus, des tentatives répétés sur un compte utilisateur finissent par bloquer le compte, mais ce n'est pas le cas des comptes machines qui possèdent un mot de passe suffisamment grand pour éviter les attaques par brute-force, et qui ne sont pas censés être utilisés.
	
L'objectif est donc de se connecter au compte machine du contrôleur de domaine avec une attaque par brute-force avec des zéros l'authentification, et ensuite de définir un mot de passe nul.
On peut ensuite utiliser les droits liés au compte machine pour passer d'administrateur du domaine.
	"

	read -p "Appuyer sur une touche pour continuer avec l'étape 2..."
	echo -e "\n"

}

tp_blue_zero_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "
Les identifiants pour se connecter à la machine sont 'RBLAB\Administrateur:Imanadministrator123;'.
Tout d'abord, il faut définir la surface attaquée :
	- Quels sont les services utilisés sur le serveur, quelles sont leurs versions ?
	- Où sont stockés les journaux qui pourraient servir à retracer l'attaque pour ces services ?
	"
	
	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'IOCs"
	echo "------------------------------------------------------------------"

	echo "
Nous pouvons tout d'abord constater que la technologie utilisée est un Windows Server 2016.

Pour les sources de journaux, on sait que les journaux Windows peuvent être visibles dans l'observateur d'événements. Les journaux qui nous intéressent sont donc les journaux de sécurité.

Lorsque les sources de journaux sont trouvés, il faut alors y dénicher les éléments pertinents qui pourraient dévoiler une attaque.

Les journaux de sécurité sont fournis sur Windows, il faut donc savoir quels éléments vont nous servir à identifier que l'attaque a eu lieu selon les différentes étapes :
	- Sur quel compte l'attaquant agit ?
	- Quelles sont les actions de celui-ci sur le compte?
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Remédiation / Mitigation"
	echo "------------------------------------------------------------------"

	echo "
Suivant le schéma de l'attaque Zerologon, on sait que l'attaquant effectue une connexion avec le compte machine du contrôleur de domaine, soit WIN-KSJNGF0GUAR$.

Il faut donc rechercher les journaux de connexion réussis (event id 4624) concernant ce compte, qui ne sont pas en local sur la machine.
	
On sait également que dans l'attaque, le mot de passe est changé pour être mis à NULL et permettre la connexion au compte. On peut également repérer un journal de réinitialisation de mot de passe, toujours sur le même compte. L'Event Id correspondant est 4742, et doit être proche de la connexion réussie.
Cela permet notamment de récupérer l'IP depuis laquelle l'attaquant a agit.
	"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Microsoft a appliqué 2 mise à jour pour prévenir l'exploitation de zerologon :
	-La première a pour effet de rejeter les authentifications dont les 5 premiers octets sont identiques.
	-La deuxième a pour but de rejeter toutes les connexions NetLogon qui ne sont pas signées ou scellées pour les comptes de machines Windows.

Les remédiations possibles seraient donc de mettre à jour la machine et de surveiller à l'aide d'un SOC ou d'un EDR l'utilisation de techniques telles que les attaques de silver/golden tickets, ou les pass-the-hash.
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}
