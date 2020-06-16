#!/bin/bash
#./peaks.sh $FILE_PATH $DEVICE
CAPT=$1

device=$2
echo $device
MAC_DEV="$(grep $device devices.txt | awk {'print $1'})"

echo $MAC_DEV

tshark -r $CAPT -T fields -e frame.time_epoch -e eth.src -e eth.dst -e ip.src -e ip.dst  -e ip.proto -e udp.srcport -e udp.dstport -e tcp.srcport -e tcp.dstport -e frame.len -e dns.qry.name -e dns.resp.name -E separator=\;  -E header=n -E quote=n>${CAPT}.csv

sed  -i '1i frame_time_epoch;eth_src;eth_dst;ip_src;ip_dst;ip_proto;udp_srcport;udp_dstport;tcp_srcport;tcp_dstport;frame_len;dns_qry_name;dns_resp_name'  ${CAPT}.csv

if [[ $device == *"echo"* ]]; then
	THRESHOLD=12172
elif [[ $device = *"homepod"* ]]; then
	THRESHOLD=76366
elif [[ $device = *"google"* ]]; then
        THRESHOLD=46086
elif [[ $device = *"invoke"* ]]; then
        THRESHOLD=13568
fi

python detect_peak.py ${CAPT}.csv $THRESHOLD $MAC_DEV>${CAPT}_start_end.csv

python3 convert_to_timestamp.py ${CAPT}_start_end.csv

if [[ -f "${CAPT}_start_end.csv_timestamp" ]]; then

time_start="$(head -1 ${CAPT}_start_end.csv_timestamp | awk -F "," {'print $1'})"

echo $time_start

awk -F "," -v var="$time_start" {'print $1-var "," $1 "," $2'} ${CAPT}_start_end.csv_timestamp > ${CAPT}_temp

cat ${CAPT}_temp>${CAPT}_temp_2

dos2unix ${CAPT}_temp_2

cat ${CAPT}_temp_2 | xargs | sed -e 's/ /,/g' > ${CAPT}_peak.csv

awk -F "," {'print $4 " " $7'} ${CAPT}_peak.csv

rm ${CAPT}.csv ${CAPT}_temp_2 ${CAPT}_temp ${CAPT}_start_end.csv ${CAPT}_start_end.csv_timestamp

sed  -i '1i start_pcap,time_start_pcap,rel_time_pcap,start_peak,time_start_peak,rel_time_start_peak,end_peak,time_end_peak,rel_time_end_peak' ${CAPT}_peak.csv
fi

