#!/bin/bash

DOMAIN="LTADI02"
REALM="${DOMAIN}.TIM.EDU.UY"
ADMINPASWORD="Passw0rd"


apt update -y && apt upgrade -y
apt-get install acl attr samba samba-client winbind libpam-winbind libnss-winbind dnsutils python3-setproctitle -y
systemctl stop nmbd smbd winbind

rm -Rf $(smbd -b | grep "CONFIGFILE" | cut -d ":" -f2)
for linea in $(smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR" | cut -d ":" -f2)
do

  echo "Borrando *.tdb y *.ldb en: $linea"
  rm -Rf $linea/*.tdb
  rm -Rf $linea/*.ldb
done

#Crear /etc/krb5.conf
cat << EOF > /etc/krb5.conf
[libdefaults]
	default_realm = ${REALM}
	dns_lookup_realm = false
	dns_lookup_kdc = true
EOF

cat << EOF > /etc/samba/smb.conf
security = ADS
workgroup = ${DOMAIN}
realm = ${REALM}

log file = /var/log/samba/%m.log
log level = 1

idmap config * : backend = tdb
idmap config * : range = 3000-7999

idmap config ${DOMAIN}:backend = ad
idmap config ${DOMAIN}:schema_mode = rfc2307
idmap config ${DOMAIN}:range = 10000-999999
idmap config ${DOMAIN}:unix_nss_info = yes

vfs objects = acl_xattr
map acl inherit = yes
store dos attributes = yes
winbind enum users = yes
winbind enum groups = yes

EOF


net ads join -U administrator%Passw0rd

sed -i 's/systemd/winbind/' /etc/nsswitch.conf
pam-auth-update --enable mkhomedir

systemctl restart winbind

