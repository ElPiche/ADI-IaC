wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb
dpkg -i zabbix-release_6.0-4+debian11_all.deb
apt update -y
apt install zabbix-agent2 zabbix-agent2-plugin-*

cat << EOF > /etc/zabbix/zabbix_agent2.conf
PidFile=/var/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=0
Server=127.0.0.1,176.160.0.214
ServerActive=127.0.0.1,176.160.0.214
HostnameItem=system.hostname
HostMetadata=68febe260234ecd1df74042417053a97
Include=/etc/zabbix/zabbix_agent2.d/*.conf
PluginSocket=/run/zabbix/agent.plugin.sock
ControlSocket=/run/zabbix/agent.sock
Include=./zabbix_agent2.d/plugins.d/*.conf
EOF

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
