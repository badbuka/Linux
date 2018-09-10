#!/bin/bash
#This file was created by root
#The last modyfy on 20.09.2017
#This script is created for:adding virtual users to FTP-server
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/admin/.local/bin:/home/admin/bin
usage="Password not match.\nUsage: $0 newlogin password"
adding(){
if [ $# -eq 2 ] ; then
echo "$1" >> "/etc/vsftpd/logins.txt" && echo "$2" >> "/etc/vsftpd/logins.txt" && db_load -T -t hash -f "/etc/vsftpd/logins.txt" "/etc/vsftpd/login.db" && db_load -T -t hash -f "/etc/vsftpd/logins.txt" "/etc/vsftpd/logins.db" && mkdir -p "/home/ftp_home/$1/$1/" && chown -R virtual:virtual "/home/ftp_home/$1" && chmod 555 "/home/ftp_home/$1" && chmod 755 "/home/ftp_home/$1/$1" && echo "OK"
fi
}
if [ $# -eq 2 ] ; then
adding $1 $2
else
read -t 60 -p "Username:" user
read -s -t 60 -p "Password:" pass
echo
read -s -t 60 -p "Retype password:" repass
if [ $pass == $repass ] ; then
adding $user $pass
exit 0
else 
echo
echo -e "$usage"
exit 1
fi
fi
