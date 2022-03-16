#! /bin/bash

#grab IP address of system and store it in varaibles
# Source: https://unix.stackexchange.com/questions/8518/how-to-get-my-own-ip-address-and-save-it-to-a-variable-in-a-shell-script
ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')


#Store current user in a varaible 
user=$(whoami)

#Add date stamp
date
date +"%FORMAT"
var=$(date)
var=`date`
echo "$var"
now=$(date)


#Create tmp log file
sudo touch /tmp/sshlog

#Output enabled ciphers, algos, and mac
#Source https://access.redhat.com/discussions/2143791
sudo sshd -T | grep "\(ciphers\|macs\|kexalgorithms\)"


#Harden SSH configurations - Ciphers, Algorithms, and MACS
#This will be completed using the root user - User must be in the sudoers file
sudo su root


###Update Ciphers
sudo echo "#Cipers updated: $now" >> /etc/ssh/ssh_config
sudo echo "Ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com" >> /etc/ssh/ssh_config
sudo echo "" >> /etc/ssh/ssh_config


##Update kexalgoritms
sudo echo "#kexAlgorithms updated: $now" >> /etc/ssh/ssh_config
sudo echo "KexAlgorithms diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256" >> /etc/ssh/ssh_config
sudo echo "" >> /etc/ssh/ssh_config


##Update MACs
sudo echo "#MACs updated: $now" >> /etc/ssh/ssh_config
sudo echo "MACs umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512" >> /etc/ssh/ssh_config
sudo echo "" >> /etc/ssh/ssh_config


echo "Restarting services......"
sleep 10
#Verify and restart services
sudo systemctl daemon-reload
sleep 10
echo "Services restarted!"


#SSH into the system and pull debug information
ssh -vvv "$user@$ip"  >> /tmp/sshlog 2>&1



