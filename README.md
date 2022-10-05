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

### Macros used

Name | Description | Default |
-----|-------------|---------|
{$RTT_AVG_THRESHOLD} | ms | 100

# Template links

There are no template links in this template.

# Discovery rules

Name | Description | Type | Key and additional info |
-----|-------------|------|-------------------------|
RTT Hosts discovery | - | ZABBIX_PASSIVE | rtt.discovery <br /> LLD Macros: {#PEER} <br /> JSONPath: $.peer

# Items collected

Group | Name | Description | Type | Key and additional info |
------|------|-------------|------|-------------------------|
RTT | RTT Raw | - | ZABBIX_PASSIVE | rtt.host.raw
RTT | {#PEER}: rtt_avg_ms | - | DEPENDENT | rtt_avg_ms_[{#PEER}] <br /> JSONPath: $.[?(@.peer=='{#PEER}')].rtt_avg_ms <br /> REGEX: (\[0\-9\]\+\\.\[0\-9\])\|(\[0\-9\]\\.\[0\-9\]\+)\|(\[0\-9\]\+)
RTT | {#PEER}: rtt_min_ms | - | DEPENDENT | rtt_min_ms_[{#PEER}] <br /> JSONPath: $.[?(@.peer=='{#PEER}')].rtt_min_ms <br /> REGEX: (\[0\-9\]\+\\.\[0\-9\])\|(\[0\-9\]\\.\[0\-9\]\+)\|(\[0\-9\]\+)
RTT | {#PEER}: rtt_max_ms | - | DEPENDENT | rtt_max_ms_[{#PEER}] <br /> JSONPath: $.[?(@.peer=='{#PEER}')].rtt_max_ms <br /> REGEX: (\[0\-9\]\+\\.\[0\-9\])\|(\[0\-9\]\\.\[0\-9\]\+)\|(\[0\-9\]\+)
RTT | {#PEER}: rtt_mdev_ms | - | DEPENDENT | rtt_mdev_ms_[{#PEER}] <br /> JSONPath: $.[?(@.peer=='{#PEER}')].rtt_mdev_ms <br /> REGEX: (\[0\-9\]\+\\.\[0\-9\])\|(\[0\-9\]\\.\[0\-9\]\+)\|(\[0\-9\]\+)

# Triggers

# Feedback

an0th3rdba@gmail.com

