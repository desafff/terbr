#!/bin/bash

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
apt update
apt install libc6 -y
apt install -y g++-11
wget https://github.com/apool-io/apoolminer/releases/download/v2.7.5/apoolminer_hiveos-v2.7.5.tar.gz
tar -xzvf apoolminer_hiveos-v2.7.5.tar.gz
