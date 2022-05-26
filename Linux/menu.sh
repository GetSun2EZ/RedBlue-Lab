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
	echo "Affichage de la bannière"
}


menu(){
	clear_banniere
	echo "Affichage du menu"
}


main(){
	menu
}

main
