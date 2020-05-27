#!/bin/bash

# rdp into remove windows computers

source ~/.xmonad/dzen2/source-config.sh

if [[ $HOSTNAME == "ARCH" ]]; then
	X=1672
	Y=1029
elif [[ $HOSTNAME == "ARCHWORK" ]]; then
	Y=874
	X=1600
else
	X=1672
	Y=1029
	#Y=1040
	#X=1910
fi

function default_vars () {
	TITLE="/t:\"xfreerdp $SERVER\""
	OTHER_OPTIONS="/dynamic-resolution /cert-ignore -grab-keyboard +clipboard +toggle-fullscreen"
	SERVER_HOST="/v:$SERVER"
	SOUND="/sound:sys:alsa /microphone:sys:alsa"
	SOUND=""
	SIZE_delta="/size:$X"
	SIZE=$(echo $SIZE_delta | sed "s/$/x$Y/g")
	#SIZE="/w:$X /h:$Y"
	#SIZE="/f"
	DOMAIN_CREDENTIALS="/u:$USER@BETHEL /p:$pass"
	SHARE_DRIVE="/drive:ARCH,$HOME"
}
function teamam_vars () {
	DOMAIN_CREDENTIALS="/u:$USER@TEAMAM /p:$pass"
}

pass=$(/usr/bin/pass show domain/windows)
# switch "-K" key machines key bindings

case $1 in
	1)	SERVER="usrds078";
		default_vars;
		;;
	2)	SERVER="windowsbox"
		default_vars;
		;;
	3)	SERVER="localhost" # if ssh tunneling
		default_vars;
		;;
	4)	SERVER="nlrds004"
		default_vars;
		;;
	5)	SERVER="windowsw";
		pass=$(/usr/bin/pass show teamam/windows);
		default_vars;
		teamam_vars;
		;;
	6)	SERVER="teamamDM";
		pass=$(/usr/bin/pass show teamam/ad-vadmin);
		USER=vadmin;
		default_vars;
		teamam_vars;
		;;
	7)	SERVER="teamvoxel";
		pass=$(/usr/bin/pass show teamam/teamvoxel);
		USER=administrator;
		default_vars;
		DOMAIN_CREDENTIALS="/u:$USER /p:$pass"
		#teamam_vars;
		;;
	8)	SERVER="dummy-dev";
		pass=$(/usr/bin/pass show teamam/ad-vadmin);
		USER=vadmin;
		default_vars;
		teamam_vars;
		;;
	*)	echo Missing paramater 1; exit 1
esac

#ping -c 2 $SERVER
# quit script if already running
if ps ux | grep xfreerdp | grep -q $SERVER ; then
	exit 0
fi


# ctrl-alt-enter to toggle full screen mode
if [ $SERVER == "windowswork" ] || [ $SERVER == "windowsbox" ]; then
	xfreerdp /t:"xfreerdp $SERVER" $OTHER_OPTIONS $SERVER_HOST $SOUND $SIZE $SHARE_DRIVE $DOMAIN_CREDENTIALS &> /tmp/rdp-log-$SERVER.txt &
else
	xfreerdp /t:"xfreerdp $SERVER" $OTHER_OPTIONS $SERVER_HOST $SIZE $SHARE_DRIVE $DOMAIN_CREDENTIALS &> /tmp/rdp-log-$SERVER.txt &
fi

while true; do
	sleep 2
	if ps ux | grep xfreerdp | grep -q $SERVER; then
		:
	else
		beep
		notify-send xfreerdp "$SERVER died"
		exit 1
	fi
done
