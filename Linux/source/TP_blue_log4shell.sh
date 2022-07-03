#!/bin/bash

# Ce script a pour but d'afficher le TP Blue_Log4Shell
#
# Créateurs		: D'ARCO Adrien, POUDENS Valentin
# Date de création 	: 22/03/2022
# Date de mise à jour 	: 26/03/2022


tp_blue_log_main(){
     tp_blue_log_CLEAR_BANNIERE
	tp_blue_log_run_vm
	tp_blue_log_etape_1
	tp_blue_log_etape_2
	tp_blue_log_etape_3
	tp_blue_log_etape_4
	tp_blue_log_retour_menu
}


tp_blue_log_CLEAR_BANNIERE(){
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
	echo " Mise en pratique sur la vulnérabilité Log4Shell en blue Team"
	echo "------------------------------------------------------------------"
	echo -e "\n"
}


tp_blue_log_run_vm(){

	echo "[~] Décompression de la VM vulnérable\n"
	if [ ! -e ../VM/vm_blue_log.zip ]
	then
		#wget 
	fi
	#unzip ../VM/vm_blue_log.zip
	
	echo "[~] Lancement de la VM vulnérable"
	#vmrun -T ws start../VM/vm_blue_log/vm_blue_log.vmx

	echo -e "\n\n"
}

tp_red_log_etape_1(){
	echo "------------------------------------------------------------------"
	echo " Etape 1 - Explication de la vulnérabilité"
	echo "------------------------------------------------------------------"

	echo "
La vulnérabilité Log4Shell a été découverte en fin 2021 par l'équipe de sécurité cloud d'Alibaba.
Le score CVSS de cette vulnérabilité est de 10 : CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H

Un score aussi haut est dû au fait que la vulnérabilité permet à l'attaquant d'exécuter facilement du code arbitraire sur la machine distance, sans s'authentifier. C'est une RCE.
"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
La vulnérabilité se base sur le framework Log4J développé par Apache Software Foundation qui permet de gérer toutes les journalisations des applications Java.
Ce framework est tellement utile qu'il est utilisé dans la plupart des logiciels Java. Beaucoup de bibliothèque Java utilise également ce framework. Cette utilisation massive a permit à log4Shell d'etre exploitée à grande échelle.
Dans les versions du framework vulnérables à Log4Shell, il était possible de faire des rêquetes LDAP, DNS, RMI et JNDI qui n'était pas vérifié et donc de faire appel à des ressources externes.
"

	read -p "Appuyer sur une touche pour continue avec l'étape 2..."
	echo -e "\n"

}

tp_blue_log_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "Les identifiants pour se connecter a la machine sont getsun2ez:getsun2ez.
	Tout d'abord, il faut définir la surface attaquée :

	- Quels sont les services utilisés sur le serveur, quels sont leurs versions ?

	- Ou sont stockés les logs qui pourraient servir a retracer l'attaque pour ces services ?
	"
	
	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_log_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'IOCs"
	echo "------------------------------------------------------------------"

	echo "Nous pouvons tout d'abord constater que la technologie utilisé est 'Apache Solr' sur le port '8983', que sa version est '8.11.0', et que la version de Java utilisé par celui-ci est la '1.8.0_181'. 
	On peut également constater que le site n'est joignable qu'en local, et qu'un proxy est défini sur le port 80 qui redirige vers le Solr.

	Pour les sources de logs, on peut constater en regardant la page d'accueil de Solr, que ses logs sont stockés dans /var/solr/logs selon la variable Dsolr.log.dir. Nous pouvons aussi voir les logs d'apache2 pour le proxy, dans /var/log/apache2/{access/error}.log

	Lorsque les sources de logs sont trouvés, il faut alors y dénicher les éléments pertinents qui pourrais dévoiler une attaque.

	Il faut donc trouver un maximum d'informations qui soit liés a l'attaquant, tel que les commandes utilisés, la période de temps dans laquelle est survenue l'attaque, les IP utilisés par celui-ci.
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_log_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Remédiation / Mitigation"
	echo "------------------------------------------------------------------"

	echo " Remédiation de la vulnérabilité log4j

	On peut apercevoir dans les logs Solr ou encore dans ceux d'apache, des requetes jndi qui ont été faites vers le serveur de l'attaquant, qui ensuite redirige le flux vers un serveur http pour récupérer l'exploit. Nous pouvons donc récupérer l'heure, ainsi que l'ip et le nom de l'exploit de la machine attaquante.
	On voit également que la page vulnérable exploitée par l'attaquant est /admin/cores, car elle permet d'accéder a l'API jndi.
	On peut voir ensuite que les règles du proxy WAF on permis de bloquer les commandes jndi classique, mais derrière l'attaquant arrive a contourner cela avec de l'obfuscation.
	

	Afin de remédier a cette faille de sécurité critique, de nombreuses options s'offre a nous :

	- Mettre a jour Solr vers la version 8.11.1, qui patche la faille de log4j en incluant une version plus récente(>=2.16.0), ou mettre a jour la version de log4j manuellement vers une version patchée.

	- Pour éviter l'obfuscation, implémenter des règles de securité plus stricts dans l'analyse des données envoyés.
	"

	read -p "Appuyer sur une touche pour continuer..."

	echo " Remédiation générales de sécurité / Hardening

	La machine, hormis avec sa version obsolète de java permettant d'exploiter log4shell, possède également plusieurs failles de sécurité plus courantes.

	On peut par exemple ajouter une politique de mot de passe et modifier celui de l'utilisateur getsun2ez, bien trop explicite(user=mdp).

	De plus le WAF possède une règle assez basique, qui est facile a contourner. Il faudrais donc mieux exploiter la puissance de celui-ci avec des règles plus complexes (voir notamment https://github.com/coreruleset/coreruleset).
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_log_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}

