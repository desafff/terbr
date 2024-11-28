#!/bin/bash

echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install libc6 -y
apt install -y g++-11
mkdir -p /hive/miners/custom/downloads
cd /hive/miners/custom/downloads
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
tar -xzvf /hive/miners/custom/downloads/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz -C /hive/miners/custom
/hive/miners/custom/aleo_prover/aleo_prover
cd /home/user
mkdir 123
cd 123
wget https://raw.githubusercontent.com/forsbors/minescrs/main/qubic_aleo_zk_vrsc.sh
mv qubic_aleo_zk_vrsc.sh qubic.sh
chmod +x qubic.sh
screen -dmS qubic /home/user/123/qubic.sh
miner restart
sleep 30
miner start
