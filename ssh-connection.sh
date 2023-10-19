#!/bin/bash

SCRIPT="cd Desktop; pwd;  echo -e 'PASSWORD' | sudo -S apt install vlc"
HOSTS=("192.168.1.121" "192.168.1.122" "192.168.1.123")
USERNAMES=("username1" "username2" "username3")
PASSWORDS=("password1" "password2" "password3")

for i in ${!HOSTS[*]} ; do
     echo ${HOSTS[i]}
     SCR=${SCRIPT/PASSWORD/${PASSWORDS[i]}}
     sshpass -p ${PASSWORDS[i]} ssh -l ${USERNAMES[i]} ${HOSTS[i]} "${SCR}"
done
