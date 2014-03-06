#!/bin/sh
ssh -p 22 $1
version=$(ssh -V 2>&1)

banner=$(sed -n '/Banner /p' /etc/ssh/sshd_config | head -1)
banner=${banner#* }

port= $(sed -n '/Port /p' /etc/ssh/sshd_config | head -1)
port=${port#* }

ip=$(host $1)
ip=$(cut -d ' ' -f 4 <<<$ip)

hostkeys= $(sed -n '/HostKey /p' /etc/ssh/sshd_config | head -3)
rsa = $(cut -d ' ' -f 2 <<<$hostkeys)
dsa = $(cut -d ' ' -f 4 <<<$hostkeys)
ecdsa = $(cut -d ' ' -f 6 <<<$hostkeys)

echo $rsa >> secrets
echo $dsa >> secrets
echo $ecdsa >> secrets
echo $ip >> secrets
echo $port >> secrets
echo $banner >> secrets
echo $version >> secrets

echo RSA: $rsa
echo DSA: $dsa
echo ECDSA $ecdsa
echo IP: $ip
echo Port: $port
echo Banner: $banner
echo SSH Version: $version

exit
scp $1:secrets ./secrets