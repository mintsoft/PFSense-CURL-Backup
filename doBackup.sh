#!/bin/bash
hostname=$1;
username=$2;
password=$3;

([ -z "$hostname" ] || [ -z "$username" ] || [ -z "$password" ]) && echo "all 3 arguments must be specified: hostname username password " && exit 1;

csrf=$(curl -Ss --insecure --cookie-jar /tmp/$hostname-cookies.txt https://$hostname/diag_backup.php | sed -n 's/.*name=.__csrf_magic. value="\([^"]*\)".*/\1/p');
csrf2=$(curl -Ss --insecure --location --cookie-jar /tmp/$hostname-cookies.txt --cookie /tmp/$hostname-cookies.txt --data "login=Login&usernamefld=$username&passwordfld=$password&__csrf_magic=$csrf" https://$hostname/diag_backup.php | sed -n 's/.*var csrfMagicToken = "\([^"]*\)".*/\1/p');

backupfile=config-router-`date +%Y%m%d%H%M%S`.xml;

curl -Ss --insecure --cookie /tmp/$hostname-cookies.txt --cookie-jar /tmp/$hostname-cookies.txt --data "download=download&donotbackuprrd=yes&__csrf_magic=$csrf2" https://$hostname/diag_backup.php > $backupfile;

grep --silent '^<?xml ' $backupfile || echo "Downloaded file is not XML; is probably broken."

rm /tmp/$hostname-cookies.txt;
