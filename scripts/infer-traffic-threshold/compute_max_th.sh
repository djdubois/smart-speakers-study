#!/bin/bash

CAPT=$1
RES_DIR=$2
device=$3

MAC_DEV="$(grep $device devices.txt | awk {'print $1'})"

tshark -r $CAPT -T fields -e frame.time_epoch -e eth.src -e eth.dst -e ip.src -e ip.dst  -e ip.proto -e udp.srcport -e udp.dstport -e tcp.srcport -e tcp.dstport -e frame.len -e dns.qry.name -e dns.resp.name -E separator=\;  -E header=n -E quote=n>${CAPT}.csv

sed  -i '1i frame_time_epoch;eth_src;eth_dst;ip_src;ip_dst;ip_proto;udp_srcport;udp_dstport;tcp_srcport;tcp_dstport;frame_len;dns_qry_name;dns_resp_name'  ${CAPT}.csv

python compute_max_th.py ${CAPT}.csv $MAC_DEV>${RES_DIR}/threshold_max.csv

sed -i "s/$/;${device}/" ${RES_DIR}/threshold_max.csv
