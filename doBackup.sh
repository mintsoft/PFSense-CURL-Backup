#!/bin/bash
username=$1;
password=$2;

curl -Ss --insecure --cookie-jar cookies.txt https://router/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt

curl -Ss --insecure --location --cookie-jar cookies.txt --cookie cookies.txt --data "login=Login&usernamefld=$username&passwordfld=$password&__csrf_magic=$(cat csrf.txt)" https://router/diag_backup.php  | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf2.txt

curl -Ss --insecure --cookie cookies.txt --cookie-jar cookies.txt --data "Submit=download&donotbackuprrd=yes&__csrf_magic=$(head -n 1 csrf2.txt)" https://router/diag_backup.php > config-router-`date +%Y%m%d%H%M%S`.xml

rm csrf.txt csrf2.txt cookies.txt