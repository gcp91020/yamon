#/bin/sh

ignore_ip='"192.168.1.101"|"192.168.125.x"|"8.8.8.8"|"8.8.4.4"'

_conntrack_awk='BEGIN {printf "var curr_connections=["} { gsub(/(src|dst|sport|dport|bytes)=/, ""); gsub(/192.168.1\.[0-9]+/, "WAN_OUT_IP"); gsub(/10.249.3[45]\.[0-9]+/, "WAN_OUT_IP"); gsub(/192.168.125.[0-9]+/, "192.168.125.x"); gsub(/\[.*OFFLOAD\]/, "OFFLOAD"); if($3 == "tcp"){ if($17 == "OFFLOAD" && $8 != "53" && $8 != "2012" && $8 != "8022" && $6 != "192.168.120.254" && $6 != "WAN_OUT_IP" && $6 != "127.0.0.1" && $6 != "192.168.125.x" && $5 != "WAN_OUT_IP") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$5,$7,$6,$8,$10;} else if($10 != "53" && $10 != "2012" && $10 != "8022" && $8 != "192.168.120.254" && $8 != "WAN_OUT_IP" && $8 != "127.0.0.1" && $8 != "192.168.125.x" && $7 != "WAN_OUT_IP") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$7,$9,$8,$10,$12;} } else if($3 == "udp"){ if($17 == "OFFLOAD" && $4 != "0000:0000:0000:0000:0000:0000:0000:0001" && $4 != "WAN_OUT_IP" && $5 != "WAN_OUT_IP" && $4 != "127.0.0.1" && $5 != "127.0.0.1" && $7 != "53" && $7 != "5060") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$5,$7,$6,$8,$10;} else if($6 != "0000:0000:0000:0000:0000:0000:0000:0001" && $6 != "WAN_OUT_IP" && $7 != "WAN_OUT_IP" && $6 != "127.0.0.1" && $7 != "127.0.0.1" && $9 != "53" && $9 != "5060") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$6,$8,$7,$9,$11;} } else { if($3 != "icmp") {printf "[\"%s\",]",$0 } } }'

_conntrack_awk_1=${_conntrack_awk//'printf "[\"'/'printf "\n[\"'}
# _conntrack_awk_1=${_conntrack_awk_1/'"var curr_connections=["'/'""'}
_conntrack_awk_1=${_conntrack_awk_1/'{printf "var curr_connections=["}'/'{printf ""}'}


# local _conntrack_awk_1=$(sed 's/printf "[\"'/'printf "\n[\"/g' <<< "$_conntrack_awk")
_conntrack='/proc/net/nf_conntrack'

ddd=$(awk "$_conntrack_awk_1" "$_conntrack")


ip="192.168.120.162"
conn_records=$(echo -e "$ddd" | grep "\"$ip\"" | grep -v -E $ignore_ip )

echo "${conn_records%,}" 


