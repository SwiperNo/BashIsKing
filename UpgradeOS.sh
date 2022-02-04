#Install script for 7.5 - > 7.9 Upgrade

#Create mount point
mkdir -p /mnt/disc/

#Mount ISO
mount -o loop RHEL7.9.iso /mnt/disc/


#Disable current repos and changing enabled to 0.
#Find all files endingin .repo and perform sed on each file
find /etc/yum.repos.d/ -type f -name '*.repo' | xargs sed -i "s/enabled=1/enabled=0/g"

#Create custom repo file 
cat << EOF >>/etc/yum.repos.d/reporhel7dvd.repo


enabled=1
baseurl=file:///mnt/disc/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release.

[InstallMedia]
name=DVD for Red Hat Enterprise Linux 7.9 Server
mediaid=1359576196.686790
metadata_expire=-1
gpgcheck=1
cost=500
enabled=1
baseurl=file:///mnt/disc/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

EOF


#Update file permissions
chmod 0644 /etc/yum.repos.d/reporhel7dvd.repo


#Clear yum cache
yum clean all

#Verify enabled repolist
yum repolist enabled


#perform system upgrade
yum update 


#Clean up 
rm /etc/yum.repos.d/reporhel7dvd.repo
umount /mnt/disc/
rm -rf /mnt/disc/*

#Clean yum repo
yum clean all

#enable previous repos
find /tmp/conf -type f -name '*.repo' | xargs sed -i "s/enabled=0/enabled=1/g"


#Check for more updates
yum check-update
