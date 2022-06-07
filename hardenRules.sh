# 1 upgrade to latest version of Apache Tomcat 
# Upgrade to latest version of ST

# 2 upgrade Kernel
sudo yum upgrade kernel -y 

# 3 upgrade OMI or remove
sudo yum remove omi
sudo yum upgrade omi

#4 Disable redirections - Must review behavior. ST may rely on this.
sudo touch /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "#ICMP redirects removed: $now" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv4.conf.all.secure_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv4.conf.default.secure_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv6.conf.all.accept_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf
sudo echo "net.ipv6.conf.all.send_redirects=0" >> /etc/sysctl.d/50-icmp_redirect.conf


sudo firewall-cmd --permanent --add-icmp-block=redirect



sudo sysctl --system --vv


#Remove 3DES, MD5, 96-bit HMAC, CBC cipher removed, weak Key Exchanges, ssh support diffie hellman

#5 Update /etc/secretty entries
sudo mv /etc/securetty /etc/secretty.vuln
sudo mv /etc/securetty.vuln /tmp/axway/backup
sudo bash -c ' cat << EOF >>/etc/securetty
vc/1
vc/2
vc/3
vc/4
vc/5
vc/6
vc/7
vc/8
vc/9
tty1
tty2
tty3
tty4
tty5
tty6
tty7
tty8
tty9

EOF'

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

gssapikexalgorithms gss-gex-sha1-,gss-group1-sha1-,gss-group14-sha1-
ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-cbc
macs umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
kexalgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1






#Create tmp log file
sudo touch /tmp/sshlog

#Output enabled ciphers, algos, and mac
#Source https://access.redhat.com/discussions/2143791
sudo sshd -T | grep "\(ciphers\|macs\|kexalgorithms\)"


#Harden SSH configurations - Ciphers, Algorithms, and MACS
#This will be completed using the root user - User must be in the sudoers file
sudo su root


###Update Ciphers
sudo echo "#Cipers updated: $now" >> /etc/ssh/sshd_config
sudo echo "Ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com" >> /etc/ssh/sshd_config
sudo echo "" >> /etc/ssh/sshd_config


##Update kexalgoritms
sudo echo "#kexAlgorithms updated: $now" >> /etc/ssh/sshd_config
sudo echo "KexAlgorithms diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256" >> /etc/ssh/sshd_config
sudo echo "" >> /etc/ssh/sshd_config


##Update MACs
sudo echo "#MACs updated: $now" >> /etc/ssh/sshd_config
sudo echo "MACs umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512" >> /etc/ssh/sshd_config
sudo echo "" >> /etc/ssh/sshd_config







sudo systemctl restart sshd
#Verify permitroot login is not set
sudo cat sshd_config | grep -i rootlogin

#If exsist 
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g"
sed -i "s/PermitRootLogin yes/#PermitRootLogin yes/g"


#6 New certificate

#7 Partition Mounting Weakness - This may be referring to the default settings

#8 Disable any MD5 or 96 bit HMAC algo

#Verify which ciphers are in use
ssh -Q cipher
ssh -Q mac
ssh -T
ssh –vv Servername ciphers listed
ssh –Q kex
  ssh -Q cipher
  ssh -Q cipher-auth
  ssh -Q mac
  ssh -Q kex
  ssh -Q key
  
# Check currently enabled
sshd -T | grep "\(ciphers\|macs\|kexalgorithms\)"


#Update Ciphers
echo "" >> /etc/ssh/ssh_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/ssh_config
echo "" >> /etc/ssh/ssh_config

#update HMACs
echo "macs hmac-sha2-256,hmac-sha2-512,hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com" >> /etc/ssh/ssh_config
echo "" >> /etc/ssh/ssh_config

#update algos
echo "kexalgorithms diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256,curve25519-sha256@libssh.org" >> /etc/ssh/ssh_config
echo "" >> /etc/ssh/ssh_config


#9 Upgrade Apache Log4j Core - We will need to upgrade ST again once we figure out bugs or move to latest release

#10 Remove world write permissions. Reviewing permissions on ST servers.

#11 Disable SSH support for 3DES - Already done in ssh_config we can remove it from the config

#12  Disable CBC cipher suite done in step 8 - new to review with security

#13 Fix comman name field in the certificate - we will need a named certificate

#14 Disabled TLS/SSL support for static key cipher suites - researching with RHEL

#15 Disable weak key exchange algo - done in step 8 more review to verify

#16 upgrade openldap
sudo yum update openldap -y
sudo yum check-update openldap 

#17 Disable SSH support for ssh-diffie helman group1 - sha1 completed in #8

#18 upgrade cyrus-sasl - do not see this

#19 More log4j updates

#20 Disable ICMP timestamp response on linux sysctl.conf

#21  Disable TCP timestamp respoonses - add to sysctl.conf
#Done in step 4.
