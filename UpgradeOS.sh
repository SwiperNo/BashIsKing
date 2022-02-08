#Install script for 7.5 - > 7.9 Upgrade

#Create mount point
sudo mkdir -p /mnt/disc/

#Mount ISO
sudo mount -o loop RHEL7.9.iso /mnt/disc/

#Verify iso was mounted
mount | grep -i "RHEL7.9.iso"


#Disable current repos and changing enabled to 0.
#Find all files endingin .repo and perform sed on each file
find /etc/yum.repos.d/ -type f -name '*.repo' | xargs -p sed -i "s/enabled=1/enabled=0/g"

#Verify all was disabled
cat /etc/yum.repos.d/* | grep -i "enabled=1"

#Create custom repo file 
sudo bash -c 'cat << EOF >>/etc/yum.repos.d/reporhel7dvd.repo

[InstallMedia]
name=DVD for Red Hat Enterprise Linux 7.9 Server
mediaid=1359576196.686790
metadata_expire=-1
gpgcheck=1
cost=500
enabled=1
baseurl=file:///mnt/disc/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

EOF'


#Update file permissions
sudo chmod 0644 /etc/yum.repos.d/reporhel7dvd.repo


#Clear yum cache
sudo yum clean all

#Verify enabled repolist
sudo yum repolist enabled


#perform system upgrade
sudo yum update 


#Clean up 
sudo rm /etc/yum.repos.d/reporhel7dvd.repo
sudo umount /mnt/disc/
sudo rm -rf /mnt/disc/*

#Clean yum repo
sudo yum clean all

#enable previous repos
find /etc/yum.repos.d/ -type f -name '*.repo' | xargs sed -i "s/enabled=0/enabled=1/g"


#Check for more updates
sudo yum check-update
