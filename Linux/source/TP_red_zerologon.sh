#!/bin/bash

# Ce script a pour but d'afficher le TP Red_ZeroLogon
#
# Créateurs		: D'ARCO Adrien, POUDENS Valentin
# Date de création 	: 22/03/2022
# Date de mise à jour 	: 26/03/2022


tp_red_zero_main(){
tp_red_zero_CLEAR_BANNIERE
	tp_red_zero_run_vm
	tp_red_zero_etape_0
	tp_red_zero_etape_1
	tp_red_zero_etape_2
	tp_red_zero_etape_3
	tp_red_zero_etape_4
	tp_red_zero_etape_5
	tp_red_zero_retour_menu
}


tp_red_zero_CLEAR_BANNIERE(){
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
	echo " Mise en pratique sur la vulnérabilité ZeroLogon en Red Team"
}


tp_red_zero_run_vm(){
	echo "[~] Décompression de la VM vulnérable\n"
	if [ ! -e ../VM/vm_red_zero.zip ]
	then
		#wget -o ../VM/vm_red_zero.zip LIEN
	fi
	#unzip ../VM/vm_red_zero.zip
	
	echo "[~] Lancement de la VM vulnérable"
	#vmrun -T ws start../VM/vm_red_zero/vm_red_zero.vmx

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

L'attaque se concentre principalement sur une mauvaise implémentation de la cryptographie. Pour être plus précis, Microsoft a choisi d'utiliser AES-CFB8 pour une fonction appelée ComputeNetlogonCredential, ce qui est normalement sécurisé, sauf que le vecteur d'initialisation a été défini sur une valeur fixe de 16 octets de zéro.

Lorsqu'un attaquant envoie un message contenant uniquement des zéros avec l'IV de zéro, il y a 1 chance sur 256 que le texte chiffré soit zéro.
	
De plus, des tentatives répétés sur un compte utilisateur finissent par bloquer le compte, mais ce n'est pas le cas des comptes machines qui possèdent un mot de passe suffisamment grand pour éviter les attaques par brute-force, et qui ne sont pas censés être utilisés.
	
L'objectif est donc de se connecter au compte machine du contrôleur de domaine avec une attaque par brute-force avec des zéros l'authentification, et ensuite de définir un mot de passe nul.
On peut ensuite utiliser les droits liés au compte machine pour passer d'administrateur du domaine.
	"

	read -p "Appuyer sur une touche pour continuer avec l'étape 2..."
	echo -e "\n"

}


tp_red_zero_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "
Afin de trouver la ou les vulnérabilités à exploiter, il faut explorer la machine victime et obtenir un maximum d'informations dessus.
La méthodologie est donc,
  - dans un premier temps, de scanner le réseau afin de trouver la machine victime.
  - dans un deuxième temps, de scanner les ports ouverts ainsi que les services qui tournent.
  - dans un troisième temps, de vérifier si des applications sont actives
  - dans un quatrième temps, d'explorer si c'est des vulnérabilités sont disponibles sur ces applications.
Il peut être judicieux de prendre des notes pour garder des traces de ses recherches et des trouvailles.
"

	read -p "Lorsque votre exploration est finie. Appuyer sur une touche pour continuer avec l'étape 3..."
	echo -e "\n"

}

tp_red_zero_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'exploitation"
	echo "------------------------------------------------------------------"

	echo "
A ce stade, normalement, vous avez trouvé l'adresse IP de la machine victime, que c'est un serveur Windows qui est en fonctionnement.
Et voici la sortie de la commande NMAP : 
    PORT      STATE SERVICE      VERSION
    53/tcp    open  domain       Simple DNS Plus
    88/tcp    open  kerberos-sec Microsoft Windows Kerberos (server time: 2022-06-27 09:14:19Z)
    135/tcp   open  msrpc        Microsoft Windows RPC
    139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
    389/tcp   open  ldap         Microsoft Windows Active Directory LDAP (Domain: RedBlue.lab, Site: Default-First-Site-Name)
    445/tcp   open  microsoft-ds Microsoft Windows Server 2008 R2 - 2012 microsoft-ds (workgroup: RBLAB)
    464/tcp   open  kpasswd5?
    593/tcp   open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
    636/tcp   open  tcpwrapped
    3268/tcp  open  ldap         Microsoft Windows Active Directory LDAP (Domain: RedBlue.lab, Site: Default-First-Site-Name)
    3269/tcp  open  tcpwrapped
    5985/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
    9389/tcp  open  mc-nmf       .NET Message Framing
    49666/tcp open  msrpc        Microsoft Windows RPC
    49667/tcp open  msrpc        Microsoft Windows RPC
    49669/tcp open  msrpc        Microsoft Windows RPC
    49670/tcp open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
    49672/tcp open  msrpc        Microsoft Windows RPC
    49682/tcp open  msrpc        Microsoft Windows RPC
    54718/tcp open  msrpc        Microsoft Windows RPC

Afin de trouver la vulnérabilité à exploiter, fiez-vous aux informations qu'il est fourni par le TP.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Au vu du nom du TP, il s'agit sûrement de la vulnérabilité ZeroLogon qu'il va falloir exploiter.
Pour vérifier si notre hypothèse est juste, il est possible d'écrire un programme python.

Ce programme va tester la première partie de la vulnérabilité, celle où l'on va essayer de s'authentifier. Dans ce programme, il n'est pas encore nécessaire de modifier le mot de passe. Si l'authentification fonctionne, alors le serveur Windows est vulnérable.

Pour écrire ce programme, l'outil impacket peut se révéler extrêmement utile.
"

	read -p "Lorsque que vous pensez avoir déterminer si la vulnérabilité est réalisable. Appuyer sur une touche pour continuer avec l'étape 4..."
	echo -e "\n"

}

tp_red_zero_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Exploitation, obtention des Condensats et Accès Administrateur"
	echo "------------------------------------------------------------------"

	echo "
Si vous n'avez pas réussi à réaliser le programme python pour déterminer si l'attaque ZeroLogon est faisable, le programme est disponible dans le dossier 'Linux/solutions/script_detection_zerologon.py'.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Maintenant que l'on sait que la vulnérabilité ZeroLogon est présente, il va falloir réaliser la deuxième partie de l'attaque.
Dans le script de détection, nous vérifions uniquement s'il est possible de s'authentifier sans le mot de passe. Il faut ensuite passer le mot de passe à NULL.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Si vous n'avez pas réussi à réaliser le programme python pour déterminer si l'attaque ZeroLogon est faisable, le programme est disponible dans le dossier 'Linux/solutions/exploitation_zerologon.py'.

Avec l'outil impacket, un programme python est fourni pour extraire les condensats des comptes, à vous de le trouver.
Lorsque cela est fait, il va être possible de se connecter avec WinRM en Administrateur sur la machine victime. Un programme est aussi disponible dans impacket.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Félicitations, vous avez obtenu le drapeau.
Le drapeau est flag{passwordHasBeenNullified}

Mais attention, le TP n'est pas tout à fait fini, il faut rétablir l'ancien mot de passe.
"

	read -p "Appuyer sur une touche pour continuer avec l'étape 5..."
	echo -e "\n"
}

tp_red_zero_etape_5(){
	echo "------------------------------------------------------------------"
	echo " Etape 5 - Rétablir l'ancien mot de passe"
	echo "------------------------------------------------------------------"

	echo "
Il est possible de rétablir l'ancien mot de passe si le mot de passe est stocké dans le cache de la machine victime. Il va donc falloir le trouver.
Lorsque vous avez trouvé comment obtenir le condensat de l'ancien mot de passe, vous pouvez continuer.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
En utilisant le programme 'secretdump.py' que l'outil impacket fourni et avec l'utilisateur 'Administrateur', il est possible de récupérer plus de condensats qu'avec le compte machine.
On remarque que dans la section LSA, le condensat de l'ancien mot de passe est présent.

Maintenant, nous pouvons créer un programme afin de remettre l'ancien mot de passe.

Indice :  - La méthodologie est identique que sur les autres programmes.
          - La fonction 'NetrServerPasswordSet' doit être créée car elle n'est pas présente dans l'outil impacket.
"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
Si vous n'avez pas réussi à réaliser le programme python pour déterminer si l'attaque ZeroLogon est faisable, le programme est disponible dans le dossier 'Linux/solutions/retablissement_password.py'.
vérifier si le mot de passe a bien été remis en réexécutez la commande secretdump.py.

Félicitations, vous avez terminé le TP.
"
	read -p "Appuyer sur une touche pour finir le TP..."
	echo -e "\n"
}

tp_red_zero_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"

	echo -e "[~] Arret de la machine virtuelle\n"
	vmrun -T ws stop ../VM/vm_red_zero/vm_red_zero.vmx

	echo -e "[~] Suppression du dossier de la machine virtuelle\n"
	rm -dfr ./VM/vm_red_zero

	read -p "Appuyer sur une touche pour retourner au menu..."
}
