# Overview

Template to monitor Round Trip Time latency between list of servers. PING utility is used to get RTT min/avg/max/mdev values.

This template was tested on Zabbix-Server 5.4.

# Setup

### 1. Prepare ```rtt_servers.txt``` file.

Paste servers which needs to checked by the script. It can contain hostnames or ip addresses each from new line. Example:

```
$ cat /etc/zabbix/zabbix_agentd.d/rtt_servers.txt
server-1.example.com
server-2.example.com
server-3.example.com
server-N.example.com
```

### 2. Copy and correct (if required) ```rtt.sh``` script

Location ```/var/lib/zabbix/scripts/rtt.sh```.

### 3. Copy ```rtt.conf``` to Zabbix agent configuration directory

Location ```/etc/zabbix/zabbix_agentd.d/rtt.conf```.

### 4. Correct file permissions

```
$ chmod 744 /etc/zabbix/zabbix_agentd.d/rtt.conf /etc/zabbix/zabbix_agentd.d/rtt_servers.txt
$ chmod 700 /var/lib/zabbix/scripts/rtt.sh
```

### 5. Update crontab

Example:
```
$ crontab -l
# RTT collect for Zabbix
* * * * * /var/lib/zabbix/scripts/rtt.sh raw >/dev/null 2>&1
```

### 6. Restart Zabbix agent

```
systemctl restart zabbix-agent
```

# Zabbix configuration



