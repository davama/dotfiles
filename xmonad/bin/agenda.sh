#!/bin/bash

# small script to create pop-up window with agenda from google calendar

TODAY=$(date +"%m/%d/%Y")
WEEKFROMTODAY=$(date -d "+7 days" +"%m/%d/%Y")

#gcalcli --config-folder ~/.gcalcli-davama --nocolor agenda $TODAY $WEEKFROMTODAY | zenity --text-info --title "Agenda for this Week"


function week_agenda () {
	gcalcli --config-folder ~/.gcalcli-davama agenda $TODAY $WEEKFROMTODAY
}
function month_agenda () {
	gcalcli --config-folder ~/.gcalcli-davama calm
}

while true; do
	echo -e '\0033\0143'
	case $1 in
		1) week_agenda
		;;
		2) month_agenda
		;;
		*) week_agenda
	esac
	sleep 10
done

