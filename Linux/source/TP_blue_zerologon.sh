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

	read -p "Appuyer sur une touche pour continuer..."

	echo "
	"
	read -p "Appuyer sur une touche pour continuer..."

	echo "
	"

	read -p "Appuyer sur une touche pour continue avec l'étape 2..."
	echo -e "\n"

}

tp_blue_zero_etape_2(){
	echo "------------------------------------------------------------------"
	echo " Etape 2 - Exploration de la machine vulnérable"
	echo "------------------------------------------------------------------"

	echo "
	"
	
	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_3(){
	echo "------------------------------------------------------------------"
	echo " Etape 3 - Recherche d'IOCs"
	echo "------------------------------------------------------------------"

	echo "
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_etape_4(){
	echo "------------------------------------------------------------------"
	echo " Etape 4 - Remédiation / Mitigation"
	echo "------------------------------------------------------------------"

	echo "
	"

	read -p "Appuyer sur une touche pour continuer..."

	echo "
	"

	read -p "Appuyer sur une touche pour continuer..."

}

tp_blue_zero_retour_menu(){
	echo "------------------------------------------------------------------"
	echo " Ce TP est maintenant terminé."
	echo "------------------------------------------------------------------"
	read -p "Appuyer sur une touche pour retourner au menu..."

}

