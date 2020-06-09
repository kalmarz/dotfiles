#!/bin/bash

echo '🤵 Install Hugo'
HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.tag_name')
HUGO=https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_${HUGO_VERSION: -6}_Linux-ARM.deb 
wget $HUGO
sudo dpkg -i $HUGO
hugo version
rm hugo_*.deb
