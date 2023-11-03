# generated 2023-10-23 21:17:45

#Generic functions
_path2logs='/opt/YAMon4/logs/'
_path2data='/opt/YAMon4/data/'
dailyLogFile='/opt/YAMon4/logs/2023-10-24.html'
_currentInterval='2023-10'
_path2CurrentMonth='/opt/YAMon4/data/2023/10/'
_intervalDataFile='/opt/YAMon4/data/2023/10/2023-10-mac_usage.js'
_uptime='32074.73'
lastCheckinHour='50'
_path2bu='/opt/YAMon4/daily-bu/'
_usersFile='/opt/YAMon4/data/users.js'
tmpUsersFile='/tmp/yamon/users.js'
_lastSeenFile='/opt/YAMon4/data/lastseen.js'
tmpLastSeen='/tmp/yamon/lastseen.js'
rawtraffic_day='/opt/YAMon4/data/2023/10/raw-traffic-2023-10-24.txt'
rawtraffic_hr='/tmp/yamon/raw-traffic-2023-10-24-06.txt'
hourlyDataFile='/tmp/yamon/hourly_2023-10-24.js'
macIPFile='/tmp/yamon/mac-ip.txt'

#ip v4 & v6 paths & functions
YAMON_IPTABLES='YAMONv40'
_generic_ipv4='0.0.0.0/0'
_generic_ipv6='::/0'
_IPCmd='ip neigh show'
send2FTP='Send2FTP_0'

#livedata.sh
_conntrack='/proc/net/nf_conntrack'
_conntrack_awk='BEGIN {printf "var curr_connections=["} { gsub(/(src|dst|sport|dport|bytes)=/, ""); gsub(/192.168.1\.[0-9]+/, "WAN_OUT_IP"); gsub(/10.249.3[45]\.[0-9]+/, "WAN_OUT_IP"); gsub(/192.168.125.[0-9]+/, "192.168.125.x"); gsub(/\[.*OFFLOAD\]/, "OFFLOAD"); if($3 == "tcp"){ if($17 == "OFFLOAD" && $8 != "53" && $8 != "2012" && $8 != "8022" && $6 != "192.168.120.254" && $6 != "WAN_OUT_IP" && $6 != "127.0.0.1" && $6 != "192.168.125.x" && $5 != "WAN_OUT_IP") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$5,$7,$6,$8,$10;} else if($10 != "53" && $10 != "2012" && $10 != "8022" && $8 != "192.168.120.254" && $8 != "WAN_OUT_IP" && $8 != "127.0.0.1" && $8 != "192.168.125.x" && $7 != "WAN_OUT_IP") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$7,$9,$8,$10,$12;} } else if($3 == "udp"){ if($17 == "OFFLOAD" && $4 != "0000:0000:0000:0000:0000:0000:0000:0001" && $4 != "WAN_OUT_IP" && $5 != "WAN_OUT_IP" && $4 != "127.0.0.1" && $5 != "127.0.0.1" && $7 != "53" && $7 != "5060") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$5,$7,$6,$8,$10;} else if($6 != "0000:0000:0000:0000:0000:0000:0000:0001" && $6 != "WAN_OUT_IP" && $7 != "WAN_OUT_IP" && $6 != "127.0.0.1" && $7 != "127.0.0.1" && $9 != "53" && $9 != "5060") {printf "[\"%s\",\"%s\",%s,\"%s\",%s,%s],",$3,$6,$8,$7,$9,$11;} } else { if($3 != "icmp") {printf "[\"%s\",]",$0 } } }'
hourlyDataTemplate='hourlyData4({\"id\":\"%s\",\"hour\":\"%s\",\"down\":\"%s\",\"up\":\"%s\"})'
currentlyUnlimited='0'

#Firmware specfic & dependent entries:
nameFromStaticLeases='StaticLeases_OpenWRT'
deviceIPField='2'
deviceNameField='3'
_dnsmasq_conf='/tmp/etc/dnsmasq.conf'
_dnsmasq_leases='/tmp/dhcp.leases'
_wwwPath='/tmp/www/'
_wwwURL='/yamon'
_iptablesWait=''
_lan_iface='br-lan'
_interfaces='br-lan,eth0,phy1-ap0,wan'
ip6tablesFn='NoIP6'
ip6Enabled=''
nameFromDNSMasqConf='NullFunction'
nameFromDNSMasqLease='DNSMasqLease'
_max_digits='18'
_setRenice='NoRenice'
interface_eth0='431837232,433525139'
interface_wan='12967455,35742866'
interface_br_lan='4171180,1302622'
interface_phy1_ap0='127189,16927'