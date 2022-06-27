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
	echo " Mise en pratique sur la vulnérabilité zerologon en blue Team"
	echo "------------------------------------------------------------------"
	echo -e "\n"
}


tp_blue_zero_run_vm(){

	echo "[~] Décompression de la VM vulnérable\n"
	if [ ! -e ../VM/vm_blue_zero.zip ]
	then
		#wget 
	fi
	#unzip ../VM/vm_blue_zero.zip
	
	echo "[~] Lancement de la VM vulnérable"
	#vmrun -T ws start../VM/vm_blue_zero/vm_blue_zero.vmx

	echo -e "\n\n"
}

tp_red_zero_etape_1(){
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

	L'attaque se concentre principalement sur une mauvaise implémentation de la cryptographie. Pour être plus précis, Microsoft a choisi d'utiliser AES-CFB8 pour une fonction appelée ComputeNetlogonCredential, ce qui est normalement sécurisé, sauf que le vecteur d'initialisation a été défini sur une valeur fixe de 16 octets de zero.

	Lorsqu'un attaquant envoie un message contenant uniquement des zéros avec l'IV de zéro, il y a 1 chance sur 256 que le texte chiffré soit zéro.
	
	De plus, des tentatives répétés sur un compte utilisateur finira par bloquer le compte, mais ce n'est pas le cas des comptes machines qui possèdent un mot de passe suffisamment grand pour éviter le bruteforce, et qui ne sont pas censés être utilisé.
	
	L'objectif est donc de se connecter au compte machine du controleur de domaine en bruteforcant avec des zeros l'authentification, et ensuite de définir un mot de passe nul.
	On peut ensuite utiliser les droits lié au compte machine pour passer d'administrateur du domaine.
	"

	read -p "Appuyer sur une touche pour continue avec l'étape 2..."
	echo -e "\n"

}

tp_blue_zero_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "
	Les credentials pour se connecter a la machine sont RBLAB\Administrateur:Imanadministrator123;.
	Tout d'abord, il faut définir la surface attaquée :

	- Quels sont les services utilisés sur le serveur, quels sont leurs versions ?

	- Ou sont stockés les logs qui pourraient servir a retracer l'attaque pour ces services ?
	"
	
	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'IOCs"
	echo "------------------------------------------------------------------"

	echo "
	Nous pouvons tout d'abord constater que la technologie utilisé est un windows server 2016.

	Pour les sources de logs, on sait que les logs windows peuvent être visible dans l'observateur d'évenements. Les logs qui nous interessent sont donc les logs de sécurité.

	Lorsque les sources de logs sont trouvés, il faut alors y dénicher les éléments pertinents qui pourrais dévoiler une attaque.

	Les logs de sécurité sont fournis sur windows, il faut donc savoir quels éléments vont nous servir a identifier que l'attaque a eu lieu selon les différentes étapes :
	- Sur quel compte l'attaquant agit ?
	
	- Quels sont les actions de celui-ci sur le compte?
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Remédiation / Mitigation"
	echo "------------------------------------------------------------------"

	echo "
	Suivant le schéma de l'attaque zerologon, on sait que l'attaquant effectue une connexion avec le compte machine du controleur de domaine, soit WIN-KSJNGF0GUAR$.

	Il faut donc rechercher les logs de connexion réussis (event id 4624) concernant ce compte, qui ne sont pas en local sur la machine.
	
	On sait également que dans l'attaque, le mot de passe est changé pour être mis a nul et permettre la connexion au compte. On peut alors également repérer un log de réinitialisation de mot de passe, toujours sur le même compte. L'event id correspondant est 4742, et doit être proche de la connexion réussie.
	Cela permet notamment de récuperer l'IP depuis laquelle l'attaquant a agit.
	"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
	Microsoft a appliqué 2 patchs pour prévenir l'exploitation de zerologon :
	-La première a pour effet de rejeter les authentifications dont les 5 premiers octets sont identiques.

	-La deuxième a pour but de rejeter toute les connexions netlogon qui ne sont pas signés ou scellés pour les compte de machines Windows.

	Les remédiations possibles seraient donc de mettre a jour la machine, et de surveiller a l'aide d'un SOC ou d'un EDR l'utilisation de techniques tels que les attaques de silver/golden tickets, ou les pass-the-hash.
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}

