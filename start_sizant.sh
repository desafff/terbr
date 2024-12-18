#!/bin/bash

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
apt update
apt install libc6 -y
apt install -y g++-11
mkdir /home/user/123
cd /home/user/123
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix2/aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz
tar -xzvf aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz
wget https://github.com/apool-io/apoolminer/releases/download/v2.7.5/apoolminer_hiveos-v2.7.5.tar.gz
tar -xzvf apoolminer_hiveos-v2.7.5.tar.gz
wget https://raw.githubusercontent.com/forsbors/minescrs/main/qubic_aleo_zk_sizant.sh
mv qubic_aleo_zk_sizant.sh qubic.sh
chmod +x qubic.sh
screen -dmS qubic /home/user/123/qubic.sh
