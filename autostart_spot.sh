#!/bin/bash

sleep 60
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install --force-confdef --force-confold libc6 -y
apt install -y --force-confdef --force-confold g++-11
miner start
