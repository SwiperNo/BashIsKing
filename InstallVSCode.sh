#! /bin/bash

#Instal Visual Studio code on RHEL 7/8

#Import GPG KEY
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

#Create custom REPO
sudo tee /etc/yum.repos.d/vscode.repo <<ADDREPO
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
ADDREPO

#install VS Code - Enjoy
sudo dnf install code



#Launch VSCode
code
