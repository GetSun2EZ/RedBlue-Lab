#!/bin/bash

# Ce script à pour but d'afficher le menu pour accéder aux différents TP
#
# Créateurs 		: D'ARCO Adrien, POUDENS Valentin 
# Date de création 	: 22/03/2022
# Date de mise à jour 	: 26/05/2022

source source/TP_blue_log4shell.sh
#Fonctions disponibles : 	tp_blue_log_CLEAR_BANNIERE
#				tp_blue_log_.........

source source/TP_blue_zerologon.sh
#Fonctions disponibles :	tp_blue_zero_CLEAR_BANNIERE
#				tp_blue_zero_.........

source source/TP_red_log4shell.sh
#Fonctions disponibles :	tp_red_log_CLEAR_BANNIERE
#				tp_red_log_...........

source source/TP_red_zerologon.sh
#Fonctions disponibles :	tp_red_log_CLEAR_BANNIERE
#				tp_red_log_...........



clear_banniere(){
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
	echo " Menu principal"
	echo "------------------------------------------------------------------"
	echo -e "\n"
}

choix(){
	finish=0
	PS3='Veuillez sélectionner le TP : '
	options=("TP Blue Team sur Log4Shell" "TP Blue Team sur ZeroLogon" "TP Red Team sur Log4Shell" "TP Red Team sur ZeroLogon" "Quit")
	select opt in "${options[@]}"
	do
    		case $opt in
        		"TP Blue Team sur Log4Shell")
            			echo "C'est parti pour le $opt"
				tp_blue_log_CLEAR_BANNIERE
				sleep 5
				break
            			;;
        		"TP Blue Team sur ZeroLogon")
            			echo "C'est parti pour le $opt"
				tp_blue_zero_CLEAR_BANNIERE
				break
				;;
        		"TP Red Team sur Log4Shell")
            			echo "C'est parti pour le $opt"
				tp_red_log_CLEAR_BANNIERE
            			break
				;;
			"TP Red Team sur ZeroLogon")
				echo "C'est parti pour le $opt"
				tp_red_zero_CLEAR_BANNIERE
				break
				;;
        		"Quit")
				finish=1
            			break
            			;;
        		*) echo "L'option $REPLY n'est pas valide";;
    		esac
	done
}

menu(){
	clear_banniere
	choix
	while [ $finish -eq 0 ]
	do
		clear_banniere
		choix
	done
}


main(){
	menu
}

main
