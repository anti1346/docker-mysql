#!/bin/bash

read -p "Enter package name (all or node / manager): " package_name

if [[ $package_name == "all" ]] || [[ $package_name == "node" ]]; then
    if dpkg -s mha4mysql-node >/dev/null 2>&1; then
        echo "mha4mysql-node package is already installed."
    else
        # Perl 모듈 설치
        apt-get install -qq -y \
            libdbd-mysql-perl \
            libconfig-tiny-perl \
            liblog-dispatch-perl \
            libparallel-forkmanager-perl
        # mha4mysql-node 설치
        wget -q https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node_0.58-0_all.deb
        dpkg -i mha4mysql-node_0.58-0_all.deb
    fi
elif [[ $package_name == "manager" ]]; then
    if dpkg -s mha4mysql-manager >/dev/null 2>&1; then
        echo "mha4mysql-manager package is already installed."
    else
        # mha4mysql-manager 설치
        wget -q https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager_0.58-0_all.deb
        dpkg -i mha4mysql-manager_0.58-0_all.deb
    fi
else
    echo "Invalid package name!"
    exit 1
fi
