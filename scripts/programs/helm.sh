#!/bin/bash

echo "📦 Installing helm"

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install -y apt-transport-https
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee -a /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm
