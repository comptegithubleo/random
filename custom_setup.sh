#!/usr/bin/env bash

while :
do
	echo "| ==--== INSTALL ==--==
| PROGRAMS
|       1) ranger
|       2) docker-compose
|       3) all
|
| MISC
|       4) cowsay
|       5) all
|
| 'q' or 'quit' to quit
"

	read -p "Select things to install  > " input

	if [[ $input = q ]] || [[ $input = quit ]]; then
		break
	else
		case $input in
        	1)
        	        yes | apt install ranger
			printf "\nranger installed\n\n"
        	        ;;
        	2)
                        yes | apt install docker-compose
                        printf "\ndocker-compose installed\n\n"
			;;
		*)
                        yes | apt install cowsay
			cp ~/.bashrc ~/.bashrc.$(date +"%d-%m-%Y-%Hh%M")
			printf "cowsay bjr bon courage\nalias clear='clear; cowsay CLEAR'" >> ~/.bashrc
			source ~/.bashrc
                        printf "\ncowsay installed\n\n"
			;;
		esac
	fi
done
