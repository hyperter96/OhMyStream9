#/bin/bash

# 安装EPEL Repository
yum install epel-release

# 安装 yum-utils tools
yum install yum-utils -y

# 安装rpmconf to resolve RPM packages
yum install rpmconf -y

rpmconf -a

# Perform a clean-up of all the packages you don’t require.
package-cleanup --leaves
package-cleanup --orphans

# 安装dnf (package manager) on CentOS 7
yum install dnf -y

# 删掉YUM package manager
dnf remove yum yum-metadata-parser
rm -rf /etc/yum

# Upgrade CentOS 7 to Centos 8
dnf upgrade -y
dnf install http://vault.centos.org/8.5.2111/BaseOS/x86_64/os/Packages/{centos-linux-repos-8-3.el8.noarch.rpm,centos-linux-release-8.5-1.2111.el8.noarch.rpm,centos-gpg-keys-8-3.el8.noarch.rpm}
dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf clean all

# Remove the old CentOS 7 Kernel
rpm -e `rpm -qa kernel-ml`
rpm -e `rpm -qa kernel-lt`
rpm -e --nodeps sysvinit-tools
rpm -e --nodeps `rpm -qa gdbm`
dnf remove python36
dnf remove iprutils
dnf remove initscripts
dnf clean all
rm -rf /var/cache/dnf
dnf upgrade

#需要更新源
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
dnf install iprutils
rm -f /var/lib/rpm/__db*
db_verify /var/lib/rpm/Packages
rpm --rebuilddb
dnf install initscripts
dnf update


dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync

annobin=$(find /var/cache/dnf/ -name annobin-9.72-1.el8_5.2.x86_64*)
redhat_rpm_config=$(find /var/cache/dnf/ -name redhat-rpm-config-125-1.el8.noarch*)
mariadb=$(find /var/cache/dnf/ -name mariadb-connector-c-3.1.11-2.el8_3.x86_64*)

rpm -ivh --nodeps --force $annobin
rpm -ivh --nodeps --force $redhat_rpm_config
rpm -ivh --nodeps --force $mariadb

dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync

#  Install new kernel for CentOS 8
dnf -y install kernel-core

rmdir /etc/yum/pluginconf.d/ /etc/yum/protected.d/ /etc/yum/vars/

# Install CentOS 8 minimal packages
dnf -y groupupdate "Core" "Minimal Install"

sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
