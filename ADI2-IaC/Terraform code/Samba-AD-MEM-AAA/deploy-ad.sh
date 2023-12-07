#!/bin/bash

DOMAIN="LTADI02"
REALM="${DOMAIN}.TIM.EDU.UY"
ADMINPASWORD="Passw0rd"

sed -i 's/127.0.0.1/8.8.8.8/' /etc/resolv.conf

apt update -y && apt upgrade -y
apt install ldap-utils kinit acl attr samba samba-client winbind libpam-winbind libnss-winbind dnsutils python3-setproctitle -y
rm $(smbd -b | grep "CONFIGFILE" | cut -d ":" -f2)

for VARIABLE in $(smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR" | cut -d ":" -f2)
do
    echo "Limpiando ${VARIABLE}"
    rm -Rf ${VARIABLE}/*.tdb
    rm -Rf ${VARIABLE}/*.ldb

done

systemctl disable systemd-resolved smbd nmbd winbind
systemctl stop systemd-resolved smbd nmbd winbind
systemctl mask systemd-resolved smbd nmbd winbind

samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm="${REALM}" --domain="${DOMAIN}" --adminpass="${ADMINPASWORD}"
sed -i 's/8.8.8.8/127.0.0.1/' /etc/resolv.conf

rm /etc/systemd/system/samba-ad-dc.service

cat << EOF > /etc/systemd/system/samba-ad-dc.service
[Unit]
Description=Samba Active Directory Domain Controller
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/usr/sbin/samba -D
#PIDFile=/usr/local/samba/var/run/samba.pid
ExecReload=/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl enable samba-ad-dc


samba-tool ou create "ou=${REALM},dc=${DOMAIN},dc=tim,dc=edu,dc=uy"
samba-tool ou create "ou=${REALM},dc=${DOMAIN},dc=tim,dc=edu,dc=uy"
samba-tool ou create "ou=Usuarios,ou=${REALM},dc=${DOMAIN},dc=tim,dc=edu,dc=uy"
samba-tool ou create "ou=Grupos,ou=${REALM},dc=${DOMAIN},dc=tim,dc=edu,dc=uy"
samba-tool ou create "ou=Servicios,ou=Usuarios,ou=${REALM},dc=${DOMAIN},dc=tim,dc=edu,dc=uy"

DOMAIN="LTADI02"
REALM="${DOMAIN}.TIM.EDU.UY"
samba-tool user create "lucas.techera" "Passw0rd" --userou="ou=Usuarios,ou=${REALM}" --uid-number=10001 --login-shell=/bin/bash --gid-number=10000
samba-tool user create "freeradius" "Passw0rd" --userou="ou=Servicios,ou=Usuarios,ou=${REALM}" --uid-number=10002 --login-shell=/bin/bash --gid-number=10000
samba-tool user create "proxmox" "Passw0rd" --userou="ou=Servicios,ou=Usuarios,ou=${REALM}"  --uid-number=10003 --login-shell=/bin/bash --gid-number=10000
samba-tool user create "zabbix" "Passw0rd" --userou="ou=Servicios,ou=Usuarios,ou=${REALM}"  --uid-number=10004 --login-shell=/bin/bash --gid-number=10000

samba-tool group addmembers "Domain Admins" lucas.techera
samba-tool group add Sysadmins --groupou="ou=Grupos,ou=${REALM}"
samba-tool group addmembers "Sysadmins" lucas.techera
samba-tool group addunixattrs "Domain Admins" 10000
samba-tool group addunixattrs "Domain Users" 10001
samba-tool group addunixattrs "Sysadmins" 10002
systemctl start samba-ad-dc