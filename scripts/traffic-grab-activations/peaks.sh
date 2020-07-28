#!/bin/bash

print_usage() {
    exit_stat=$1
    usg_stm="
Usage: $0 -i IN_PCAP {-d DEV | -t THRES -m MAC} [-o OUT_DIR] [-h]

Determines when smart devices activate.

Example: $0 -i echodot3a.pcap -d echodot

Options:
  -i IN_PCAP the input pcap file to analyze; this option is required
  -d DEV     the device that recorded IN_PCAP; either this option or the -t and
               -m options must be specified
  -t THRES   the threshold of when the device taht recorded IN_PCAP activates;
               either this and the -m option must be specified or the -d option
               must be specified
  -m MAC     the MAC address of the device that recorded IN_PCAP; either this
               and the -t option must be specified or the -d option must be
               specified
  -o OUT_DIR path to an output directory to place the results; directory will be
               generated if it does not exist (Default = results/)
  -h         print this usage statement and exit"

    if [ $exit_stat -eq 0 ]
    then
        echo -e "$usg_stm"
    else
        echo -e "$usg_stm" >&2
    fi
    exit $exit_stat
}

read_args() {
    while getopts "i:o:d:t:m:h" opt
    do
        case $opt in
            i)
                CAPT="$OPTARG"
                ;;
            o)
                out_dir="$OPTARG"
                ;;
            d)
                device="$OPTARG"
                ;;
            t)
                THRESHOLD="$OPTARG"
                ;;
            m)
                MAC_DEV="$OPTARG"
                ;;
            h)
                print_usage 0
                ;;
            *)
                print_usage 1
                ;;
        esac
    done
}

print_err() {
    echo -e "\e[31;1m$0: Error: $1\e[0m" >&2
}

check_args() {
    errors=false
    if [[ $CAPT == "" ]]
    then
        errors=true
        print_err "Input pcap (-i) required."
    elif [[ $CAPT != *.pcap ]]
    then
        errors=true
        print_err "Input pcap file should be a pcap (.pcap) file. Received \"$CAPT\"."
    elif ! [[ -f $CAPT ]]
    then
        errors=true
        print_err "Input pcap file \"$CAPT\" does not exist."
    fi

    if [[ $device == "" ]] && ([[ $THRESHOLD == "" ]] || [[ $MAC_DEV == "" ]])
    then
        errors=true
        print_err "Either a device (-d) or threshold (-t) and MAC (-m) must be specified."
    elif [[ $THRESHOLD != "" ]] && [[ $MAC_DEV != "" ]]
    then
        if ! [[ $THRESHOLD =~ ^[\-0-9]+$ ]] && (( THRESHOLD < 0 ))
        then
            errors=true
            print_err "Threshold must be a positive integer. Recieved $THRESHOLD."
        fi
        if ! [[ $MAC_DEV =~ ([0-9a-f]{2}[:]){5}[0-9a-f]{2}$ ]]
        then
            errors=true
            print_err "Invalid MAC address. Received \"$MAC_DEV\"."
        fi
    fi

    if [[ $errors == true ]]
    then
        print_usage 1
    fi
}

analyze() {
    out_file=${out_dir}/"$(basename ${CAPT%.pcap})"
    if ! [[ -d $out_dir ]]
    then
        mkdir -pv $out_dir
    fi

    if [[ $device != "" ]]
    then
        echo $device
        MAC_DEV="$(grep $device devices.txt | awk {'print $1'})"
    fi

    echo $MAC_DEV

    tshark -r $CAPT -T fields -e frame.time_epoch -e eth.src -e eth.dst -e ip.src -e ip.dst  -e ip.proto -e udp.srcport -e udp.dstport -e tcp.srcport -e tcp.dstport -e frame.len -e dns.qry.name -e dns.resp.name -E separator=\;  -E header=n -E quote=n > ${out_file}.csv

    sed -i '1i frame_time_epoch;eth_src;eth_dst;ip_src;ip_dst;ip_proto;udp_srcport;udp_dstport;tcp_srcport;tcp_dstport;frame_len;dns_qry_name;dns_resp_name' ${out_file}.csv

    if [[ $device == *"echo"* ]]; then
        THRESHOLD=12172
    elif [[ $device == *"homepod"* ]]; then
        THRESHOLD=76366
    elif [[ $device == *"google"* ]]; then
        THRESHOLD=46086
    elif [[ $device == *"invoke"* ]]; then
        THRESHOLD=13568
    elif [[ $device != "" ]]; then
        print_err "Device \"$device\" does not exist."
    fi

    python3 detect_peak.py ${out_file}.csv $THRESHOLD $MAC_DEV > ${out_file}_start_end.csv

    python3 convert_to_timestamp.py ${out_file}_start_end.csv

    if [[ -f "${out_file}_start_end.csv_timestamp" ]]; then
        time_start="$(head -1 ${out_file}_start_end.csv_timestamp | awk -F "," {'print $1'})"
        echo $time_start

        awk -F "," -v var="$time_start" {'print $1-var "," $1 "," $2'} ${out_file}_start_end.csv_timestamp > ${out_file}_temp

        cat ${out_file}_temp > ${out_file}_temp_2

        dos2unix ${out_file}_temp_2

        cat ${out_file}_temp_2 | xargs | sed -e 's/ /,/g' > ${out_file}_peak.csv

        awk -F "," {'print $4 " " $7'} ${out_file}_peak.csv

        rm ${out_file}.csv ${out_file}_temp_2 ${out_file}_temp ${out_file}_start_end.csv ${out_file}_start_end.csv_timestamp

        sed -i '1i start_pcap,time_start_pcap,rel_time_pcap,start_peak,time_start_peak,rel_time_start_peak,end_peak,time_end_peak,rel_time_end_peak' ${out_file}_peak.csv
    fi
}

CAPT=""
out_dir="results"
device=""
THRESHOLD=""
MAC_DEV=""

read_args $@

echo "Running $0..."

check_args
analyze

