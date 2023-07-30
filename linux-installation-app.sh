#  Author: Daibel Inle Martínez Sáchez [Konrad]
#  Date  : 2023-07-30 00:10
#  This is a script squeleeton to verify system distribution [GNU/Linux]
#  and package manager and execute a bash function to perform app/package installation
#  from  oficial repository private hosting service or downloaded package.
#  Uding this you are accepting the disclaimer on this github project README.



#!/bin/bash
(
set -e   # close script on error descriptor found

echo "Starting the installation ..."

# DEBIAN BASED - Ubuntu / Mint / Molinux / Recient debian based Kali / Parrot 
install_deb() {
    # INSTALL BASIC DEPENDENSIES 
    apt-get install -y curl wget nano apt-transport-https ca-certificates gnupg --reinstall
    
    # Download pgp key for ptivate repository DEPRECATED ----- WONT BE IMPPLEMENTED - OLD APT -
    #curl https://mywebsite.com/app.key | apt-key add -

    # Download pgp key for ptivate repository ----- WONT BE IMPPLEMENTED 
    wget https://mywebsite.com/app.gpg -O /usr/share/keyrings/app_name.gpg

    # Install actual repo - NO IMPLEMENTED- 
    #wget https://mywebsite.com/app_debian-vX.repo -O /etc/apt/sources.list.d/app_name.list
    #apt-get update || true
    #apt-get install -y repo_signed-app

    # Download directly the package || a sinngle .deb or .tgz
    wget https://mywebsite.com/app_debian-vX.repo.deb -O /tmp/app/app_debian-vX.repo.deb
    dpkg -i /tmp/app/app_debian-vX.repo.deb
    
    # Pending implement tgz untar and install - which is completelly easy - can create if to verify the kind of package and check downloaded 
    # package pgp singning key
    
    }
    
    
# Alpine or alpine based - TO DO!    
install_apk() {
    apk add -y curl
    # Import Alpine linux repo pgp key
    # apk  https://mywebsite.com/app.key
    # wget https://mywebsite.com/app_apk.repo -O /etc/yum.repos.d/app_name.repo
    yum install -y repo_signed-app
}    

# REDHAT or rpm based - Centos / Fedora / 
install_yum() {
    yum install -y curl
    rpm --import https://mywebsite.com/app.key
    wget https://mywebsite.com/app_rpm.repo -O /etc/yum.repos.d/app_name.repo
    yum install -y repo_signed-app
}

# Pending
install_pacman() {
   
}



enable_service() {
    if ! systemctl >/dev/null; then
        echo " systemd not founnd,install/manage app as service."
        echo 
        echo "Make sure the app is executed at system startup."
    else
        systemctl daemon-reload
        systemctl enable app_service
        systemctl start app_service
    fi
}

# verify usser privileges if id -u is zero it root so
if [ "$(id -u)" != 0 ]; then
    echo "Error: use the script as root."
    exit 1
fi

if apt-get --version >/dev/null 2>/dev/null; then
    install_deb
elif apk --version >/dev/null 2>/dev/null; then
    install_apk    
elif yum --version >/dev/null 2>/dev/null; then
    install_yum
elif pacman -V --version >/dev/null 2>/dev/null; then
    install_pacman
else
    echo "Currently only apt-get/apk/yum/pacman based distros are supported."
    echo "Please follow manual installation method on https://mywebsite.com"
    exit 1
fi

# Uncoment below if need too enable as service
#enable_service

echo "App_name successfully installed on your system"
)
