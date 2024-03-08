#/bin/bash

# 切换到vault源
minorver=8.5.2111
sudo sed -e "s|^mirrorlist=|#mirrorlist=|g" \
         -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/$minorver|g" \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo

# 更新CentOS Stream 8
sudo dnf install \
    http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-8-4.el8.noarch.rpm \
    http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-release-8.6-1.el8.noarch.rpm \
    http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-4.el8.noarch.rpm \
    -y --allowerasing

sudo dnf distro-sync --allowerasing -y
