#!/bin/sh
ssh -p 22 $HOSTNAME 
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
rm secrets
rm sql.txt
echo $rsa >> secrets
echo $dsa >> secrets
echo $ecdsa >> secrets
echo $ip >> secrets
echo $port >> secrets
echo $banner >> secrets
echo $version >> secrets
echo "INSERT INTO servers (ip, rsa, dsa, ecdsa, port, banner, version) VALUES ('"$ip"', '"$rsa"', '"$dsa"', '"$ecdsa"', '"$port"', '"$banner"', '"$version"');" >> sql.txt
echo "exit" >>sql.txt
echo RSA: $rsa
echo DSA: $dsa
echo ECDSA $ecdsa
echo IP: $ip
echo Port: $port 
echo Banner: $banner
echo SSH Version: $version
exit
scp $HOSTNAME:secrets.txt ./secrets.txt
scp $HOSTNAME:sql.txt ./sql.txt
if [$CREATE_DATABASE = "yes"]; then
	mysql scan_results < database_setup.txt
fi
mysql scan_results < insert.txt