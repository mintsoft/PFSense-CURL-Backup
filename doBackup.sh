#!/bin/bash
hostname=$1;
username=$2;
password=$3;

csrf=$(curl -Ss --insecure --cookie-jar /tmp/$hostname-cookies.txt https://$hostname/diag_backup.php | sed -n 's/.*name=.__csrf_magic. value="\([^"]*\)".*/\1/p')
csrf2=$(curl -Ss --insecure --location --cookie-jar /tmp/$hostname-cookies.txt --cookie /tmp/$hostname-cookies.txt --data "login=Login&usernamefld=$username&passwordfld=$password&__csrf_magic=$csrf" https://$hostname/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' | head -n 1)
curl -Ss --insecure --cookie /tmp/$hostname-cookies.txt --cookie-jar /tmp/$hostname-cookies.txt --data "Submit=download&donotbackuprrd=yes&__csrf_magic=$csrf2" https://$hostname/diag_backup.php > config-router-`date +%Y%m%d%H%M%S`.xml

rm /tmp/$hostname-cookies.txt;