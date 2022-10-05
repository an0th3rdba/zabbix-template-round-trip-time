#!/bin/bash

set -e

PING="$(which ping)"
PING_TIME_LIMIT="59"
PING_SEND_INTERVAL="0.5"
HOSTS="/etc/zabbix/zabbix_agentd.d/rtt_servers.txt"
OUT_FILE="/tmp/rtt.out"
TMP_FILE="/tmp/rtt.tmp"

get_json_host_info() {

    RTT_RAW=$(${PING} -nq -w ${PING_TIME_LIMIT} -i ${PING_SEND_INTERVAL} ${1} | tail -1 | awk '{print $4}')
    if ! [[ -z ${RTT_RAW} ]]; then
        RTT_MIN_MS=$(echo ${RTT_RAW} | cut -d '/' -f 1)
        RTT_AVG_MS=$(echo ${RTT_RAW} | cut -d '/' -f 2)
        RTT_MAX_MS=$(echo ${RTT_RAW} | cut -d '/' -f 3)
        RTT_MDEV_MS=$(echo ${RTT_RAW} | cut -d '/' -f 4)
        JSON_HOST="{\"peer\":\"${HOST}\",\"rtt_min_ms\":\"${RTT_MIN_MS}\",\"rtt_avg_ms\":\"${RTT_AVG_MS}\",\"rtt_max_ms\":\"${RTT_MAX_MS}\",\"rtt_mdev_ms\":\"${RTT_MDEV_MS}\"},"
    else
        JSON_HOST="${JSON_HOST}{\"peer\":\"${HOST}\",\"rtt_min_ms\":\"-100\",\"rtt_avg_ms\":\"-100\",\"rtt_max_ms\":\"-100\",\"rtt_mdev_ms\":\"-100\"},"
    fi
    echo ${JSON_HOST} >> ${TMP_FILE}
}

if [[ ${1} == "discovery" ]]; then
    if [[ ! -f ${HOSTS} ]] || [[ ! -s ${HOSTS} ]]; then
        printf "ERROR: Failed to discover peer servers.\n"
        exit 1
    fi
    JSON_DISCOVERY="["
    while read HOST; do
        JSON_DISCOVERY="${JSON_DISCOVERY}{\"peer\":\"${HOST}\"},"
    done < ${HOSTS}
    printf "${JSON_DISCOVERY%?}]\n"
    exit 0
fi

if [[ ${1} == "raw" ]] && [[ -s ${HOSTS} ]]; then
    printf "[" > ${TMP_FILE}
    while read HOST; do
       get_json_host_info $HOST &
    done < ${HOSTS}
    wait
    sed -i '$ s/.$//' ${TMP_FILE}
    printf "]" >> ${TMP_FILE}
fi

cat ${TMP_FILE} > ${OUT_FILE}