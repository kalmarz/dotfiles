#!/bin/bash

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

## basics
install awscli
install gopass
install jq
install mosh
install net-tools
install nmap
install openvpn

## docker 
install docker
install docker-compose

## torrent
install deluged
install deluge-console

## fun stuff
install figlet
install lolcat

## kernel building shit
install git
install bc
install bison
install flex
install libssl-dev
install make
