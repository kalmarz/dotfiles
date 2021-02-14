#!/bin/bash

echo "📦 Installing node.js & npm & yarn"

curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt-get install -y nodejs
sudo npm install -g yarn

echo "Install yarn 2 per project:"
echo "cd /path/to/project"
echo "yarn policies set-version berry # below v1.22"
echo "yarn set version berry # on v1.22+"
echo "update yarn set version latest"

echo "Install vue.js"
echo "yarn add vue@next"
echo "yarn global add @vue/cli"
