#!/bin/bash

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install libc6 -y
apt install -y g++-11
mkdir /home/user/123
cd /home/user/123
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
tar -xzvf aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
wget https://raw.githubusercontent.com/forsbors/minescrs/main/qubic_aleo_zk_vrsc.sh
mv qubic_aleo_zk_vrsc.sh qubic.sh
chmod +x qubic.sh
screen -dmS qubic /home/user/123/qubic.sh
