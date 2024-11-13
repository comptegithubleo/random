#!/usr/bin/env bash

dpkg_from_url() {
        TEMP_DEB="$(mktemp)" &&
        wget -O "$TEMP_DEB" $1 &&
        dpkg --skip-same-version -i "$TEMP_DEB"
        rm -f "$TEMP_DEB"
}

install_x2go() {
        read -p "Install [client] or [server] ? > " input
        if [ "$input" = "client" ]; then
                apt install xg2goclient
        elif [ "$input" = "server" ]; then
                apt install openssh-server
                systemctl restart ssh
                apt install x2goserver x2goserver-session x2godesktopsharing
        fi
}

while :
do
        echo "| ==--== INSTALL ==--==
| PROGRAMS
|       ranger
|       docker-compose
|	codium
|           - open-source vscode
|       nvm
|           - npm version manager - v0.40.1
|       all-programs
|
| REMOTE CONNECTION
|       wireguard (Work in progress)
|       x2go
|           - uses ssh-server
|           - choose between client & server, startup config etc
| MISC
|       cowsay
|	editor
|           - choose default editor (nano, vim, ...)
|       all-misc
|
| 'q' or 'quit' to quit
"

        read -p "Select things to install  > " input

        if [ "$input" = "q" ] || [ "$input" = "quit" ]; then
                break
        else
                case $input in
                ranger)
                        yes | apt install ranger
                        printf "\nranger installed\n\n"
                        ;;
                docker-compose)
                        yes | apt install docker-compose
                        printf "\ndocker-compose installed\n\n"
                        ;;
                codium)
                        dpkg_from_url https://github.com/VSCodium/vscodium/releases/download/1.95.2.24313/codium_1.95.2.24313_amd64.deb
                        ;;
                nvm)
                        # https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
                        wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
                        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
                        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                        ;;
                vnc)
                        install_x2go
                        ;;
                cowsay)
                        yes | apt install cowsay
                        cp ~/.bashrc ~/.bashrc.$(date +"%d-%m-%Y-%Hh%M")
                        printf "cowsay bjr bon courage\nalias clear='clear; cowsay CLEAR'" >> ~/.bashrc
                        source ~/.bashrc
                        printf "\ncowsay installed\n\n"
                        ;;
                editor)
                        update-alternatives --config editor
                        ;;
                *)
                        ;;
                esac
        fi
done
