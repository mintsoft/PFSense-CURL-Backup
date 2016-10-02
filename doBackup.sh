#!/bin/bash
hostname=$1;
username=$2;
password=$3;

csrf=$(curl -Ss --insecure --cookie-jar /tmp/cookies.txt https://$hostname/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/')

csrf2=$(curl -Ss --insecure --location --cookie-jar cookies.txt --cookie cookies.txt --data "login=Login&usernamefld=$username&passwordfld=$password&__csrf_magic=$csrf" https://$hostname/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' | head -n 1)

curl -Ss --insecure --cookie cookies.txt --cookie-jar cookies.txt --data "Submit=download&donotbackuprrd=yes&__csrf_magic=$csrf2" https://$hostname/diag_backup.php > config-router-`date +%Y%m%d%H%M%S`.xml

rm csrf.txt csrf2.txt cookies.txt