#!/bin/bash

##recon automation for Nmap, Gobuster, and WhatWeb

##valid use case
if [ -z "$1" ]
then
        echo "Usage: ./icyrecon.sh <IP>"
        exit 1
fi

##Banner

#   ██▓▄████▓██   ██▓██▀███ ▓█████ ▄████▄  ▒█████  ███▄    █        ██████ ██░ ██ 
#  ▓██▒██▀ ▀█▒██  ██▓██ ▒ ██▓█   ▀▒██▀ ▀█ ▒██▒  ██▒██ ▀█   █      ▒██    ▒▓██░ ██▒
#  ▒██▒▓█    ▄▒██ ██▓██ ░▄█ ▒███  ▒▓█    ▄▒██░  ██▓██  ▀█ ██▒     ░ ▓██▄  ▒██▀▀██░
#  ░██▒▓▓▄ ▄██░ ▐██▓▒██▀▀█▄ ▒▓█  ▄▒▓▓▄ ▄██▒██   ██▓██▒  ▐▌██▒       ▒   ██░▓█ ░██ 
#  ░██▒ ▓███▀ ░ ██▒▓░██▓ ▒██░▒████▒ ▓███▀ ░ ████▓▒▒██░   ▓██░ ██▓ ▒██████▒░▓█▒░██▓
#  ░▓ ░ ░▒ ▒  ░██▒▒▒░ ▒▓ ░▒▓░░ ▒░ ░ ░▒ ▒  ░ ▒░▒░▒░░ ▒░   ▒ ▒  ▒▓▒ ▒ ▒▓▒ ▒ ░▒ ░░▒░▒
#   ▒ ░ ░  ▒ ▓██ ░▒░  ░▒ ░ ▒░░ ░  ░ ░  ▒    ░ ▒ ▒░░ ░░   ░ ▒░ ░▒  ░ ░▒  ░ ░▒ ░▒░ ░
#   ▒ ░      ▒ ▒ ░░   ░░   ░   ░  ░       ░ ░ ░ ▒    ░   ░ ░  ░   ░  ░  ░  ░  ░░ ░
#   ░ ░ ░    ░ ░       ░       ░  ░ ░         ░ ░          ░   ░        ░  ░  ░  ░
#     ░      ░ ░                  ░                            ░                  
printf "\n----- ICYRECON by ICYSABER -----\n\n"                                                                                  



#nmap scan
printf "\n----- NMAP -----\n\n" > results

echo "Running Nmap..."
nmap -T4 -p- -A $1 | tail -n +5 | head -n -3 >> results

#Gobuster and WhatWeb
while read line
do
        if [[ $line == *open* ]] && [[ $line == *http* ]]
        then
                echo "Running Gobuster..."
                gobuster dir -u $1 -w /usr/share/wordlists/dirb/common.txt -qz > temp1

        echo "Running WhatWeb..."
        whatweb $1 -v > temp2
        fi
done < results

if [ -e temp1 ]
then
        printf "\n----- DIRS -----\n\n" >> results
        cat temp1 >> results
        rm temp1
fi

if [ -e temp2 ]
then
    printf "\n----- WEB -----\n\n" >> results
        cat temp2 >> results
        rm temp2
fi

cat results