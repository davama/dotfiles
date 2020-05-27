#!/bin/bash

# this script calls puppet scripts
# depends on records in /etc/hosts

# help message
if [ $# -eq 0 ]; then
	cat <<-EOL
	USAGE:
	./script.sh <option>
	options include:
	amer emea apac dev
	amerweb emeaweb apacweb
	others
	sshuttle
	dynamic
	teamam
	EOL
	sleep 3
	exit
fi

trap 'rm output-$$' EXIT

source ~/dmz/bin/source.sh

function tunnel_sshuttle () {
	~/dmz/bin/puppet-tunnel-sshuttle.exp $USER $zone
}
function tunnel_teamam () {
	sudo openvpn --config .teamam-vpn/client.ovpn
	if [ $? -eq 0 ]; then echo " TeaAM VPN Tun " >> /tmp/ssh-remote.txt; fi
}
# call puppet scripts
function ssh_dsb () {
	~/dmz/bin/puppet-tunnel-in.exp $USER $zone
}
function ssh_dsb_web () {
	~/dmz/bin/puppet-tunnel-in-web.exp $USER $zone $dsb $inmon $inmonport $dsbwebport $inmon2 $inmon2port
	if [ $? -eq 0 ]; then echo " $name SSH Web Tun " >> /tmp/ssh-remote.txt; fi
}
function ssh_dsb_other () {
	#~/dmz/bin/puppet-tunnel-in-others.exp $USER $zone $dsbamer $dsbemea $dsbapac $zabbix $racktables $intranet $usrds006 $redmine
	~/dmz/bin/puppet-tunnel-in-others.exp $USER $zone $dsbamer $dsbemea $dsbapac $zabbix $racktables $intranet $windowsbox $redmine $mail $testing1 $testing2 $testing3 $testing4 $testing5 $archbox
	if [ $? -eq 0 ]; then echo " $name SSH Tun " >> /tmp/ssh-remote.txt; fi
}
function dynamic_ssh () {
	read -p "Remote IP you need to connect to: " remote_ip
	read -p "Service port # on remote IP $remote_ip: " remote_port
	read -p "Local port # to forward: " local_port
	~/dmz/bin/puppet-tunnel-in-dynamic.exp $USER $zone $local_port $remote_ip $remote_port
	echo
	if [ $remote_port -eq 443 ]; then
		echo "https://localhost:$local_port"
	elif [ $remote_port -eq 80 ]; then
		echo "http://localhost:$local_port"
	fi
}
function name_amer () {
	name="AMER"
}
function name_emea () {
	name="EMEA"
}
function name_apac () {
	name="APAC"
}
function name_teamam () {
	name="TeamAM"
}

function select_region () {
	PS3="SSH server to forward to: "
	select remote_ssh in "AMER" "EMEA" "APAC" "DEV" "TEAMAM"; do
		case "$remote_ssh" in
			"AMER")		name_amer; zone=$AMER; break;;
			"EMEA")		name_emea; zone=$EMEA; break;;
			"APAC")		name_apac; zone=$APAC; break;;
			"DEV")		zone=$DEV; break;;
			*)		echo "Not in list. Exiting"; exit 1;;
		esac
	done
}

# make $1 all caps
zone=$(echo $1 | tr '[:lower:]' '[:upper:]')

# do nothing unless wrong
case $zone in
	AMER)		name_amer; ssh_dsb ;;
	EMEA)		name_emea; ssh_dsb ;;
	APAC)		name_apac; ssh_dsb ;;
	DEV)		ssh_dsb ;;
	TEAMAM)		name_teamam; tunnel_teamam ;;
	SSHUTTLE)	select_region; tunnel_sshuttle;;
	AMERWEB)	select_region; dsb=$dsbamer; inmon2=$inmonamer; inmon2port=10441; inmon=$inmonusa; inmonport=10443; dsbwebport=10444; ssh_dsb_web ;;
	EMEAWEB)	select_region; dsb=$dsbemea; inmon2=$inmonamer; inmon2port=11441; inmon=$inmonemea; inmonport=11443; dsbwebport=11444; ssh_dsb_web ;;
	APACWEB)	select_region; dsb=$dsbapac; inmon2=$inmonamer; inmon2port=12441; inmon=$inmonapac; inmonport=12443; dsbwebport=12444; ssh_dsb_web ;;
	OTHERS)		select_region; ssh_dsb_other ;;
	DYNAMIC)	select_region; dynamic_ssh ;;
	*)		echo Error; exit 1;;
esac
