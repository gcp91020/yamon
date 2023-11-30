#!/bin/sh

##########################################################################
# Yet Another Monitor (YAMon)
# Copyright (c) 2013-present Al Caughey
# All rights reserved.
#
# updates the data for the live tab
# run: by cron
# History
# 2020-01-26: 4.0.7 - no changes
# 2020-01-03: 4.0.6 - added current traffic to the output file
# 2019-12-23: 4.0.5 - no changes
# 2019-11-24: 4.0.4 - no changes (yet)
# 2019-06-18: development starts on initial v4 release
#
##########################################################################

d_baseDir=$(cd "$(dirname "$0")" && pwd)
source "${d_baseDir}/includes/shared.sh"
source "${d_baseDir}/includes/traffic.sh"

Send2Log "Running update-live-data"

ignore_ip='"192.168.1.101"|"192.168.125.x"|"8.8.8.8"|"8.8.4.4"|"17.57.145.|"192.168.120.227"|"222.73.192.|"221.229.52|"49.4.47'
#17.57.145. apple
#192.168.120.227 TM-Genie
#222.73.192. gateway.fe.apple-dns.cn
#221.229.52 tencent
#49.4.47 huaweikid

CurrentConnections_0()
{ #_doCurrConnections=0 --> do nothing, the option is disabled
	return
}

CurrentConnections_1()
{ #_doCurrConnections=1

	IP6Enabled(){
		echo "$(ip6tables -L "$YAMON_IPTABLES" "$vnx" | grep -v RETURN | awk '{ print $2,$7,$8 }' | grep "^[1-9]")"
	}
	NoIP6(){
		echo ''
	}

	Send2Log "Running CurrentConnections_1 --> $_liveFilePath"

	ArchiveLiveUpdates_0()
	{ #_doArchiveLiveUpdates=0 --> do nothing, the option is disabled
		return
	}
	ArchiveLiveUpdates_1()
	{ #_doArchiveLiveUpdates=1
		local dpct=$(df $d_baseDir | grep "^/" | awk '{print $5}')
		local dspace=$(printf %02d $(echo "${dpct%\%} "))

		if [ "$dspace" -lt '90' ] ; then
			cat "$_liveFilePath" >> $_liveArchiveFilePath
		else
			Send2Log "ArchiveLiveUpdates_: skipped because of low disk space: $dpct" 3
		fi
	}

	#to-do - grab the iptables data and send along with the live data
	local vnx='-vnx'
	local ip4t=$(iptables -L "$YAMON_IPTABLES" "$vnx" | grep -v RETURN | awk '{ print $2,$8,$9 }' | grep "^[1-9]")
	local ip6t="$ip6tablesFn"
	local ipt="$ip4t\n$ip6"
	local macIP=$(cat "$macIPFile")
	local _conntrack_awk_1=${_conntrack_awk//'printf "[\"'/'printf "\n[\"'}
	_conntrack_awk_1=${_conntrack_awk_1/'{printf "var curr_connections=["}'/'{printf ""}'}

	# local _conntrack_awk_1=$(sed 's/printf "[\"'/'printf "\n[\"/g' <<< "$_conntrack_awk")
	local ddd=$(awk "$_conntrack_awk_1" "$_conntrack")
	[ -z "$ds" ] && local ds=$(date +"%Y-%m-%d")
	[ -z "$hour" ] && local hour=$(date +"%H")
	[ -z "$minute" ] && local minute=$(date +"%M")
	local hourly_conn_file="/tmp/yamon/hourly_conn_${ds}.js"
	local minute_conn_file="/tmp/yamon/minute_conn_${ds}_${hour}.js"
	local hourly_conn_live_file_path="/tmp/yamon/hourly_conn_live_${ds}_ip.js"
	local grep_ignore_ips="grep -v \"192.168.1.1\" "
	for ig_i in ${ignore_ip}; do
		grep_ignore_ips="${grep_ignore_ips} | grep -v \"${ig_i}\""
	done

	local date_f=""
	while true
	do
		[ -z "$ipt" ] && break
		fl=$(echo -e "$ipt" | head -n 1)
		[ -z "$fl" ] && break
		local ip=$(echo "$fl" | cut -d' ' -f2)
		if [ "$_generic_ipv4" == "$ip" ] || [ "$_generic_ipv6" == "$ip" ] ; then
			ip=$(echo "$fl" | cut -d' ' -f3)
		fi
		local tip="\b${ip//\./\\.}\b"
		if [ "$_generic_ipv4" == "$ip" ] || [ "$_generic_ipv6" == "$ip" ] || [[ "${ignore_ip}" == *"${ip}"* ]] ; then
			ipt=$(echo -e "$ipt" | grep -v "$fl")
		else
			local do=$(echo "$ipt" | grep -E "($_generic_ipv4|$_generic_ipv6) $tip\b" | cut -d' ' -f1)
			local up=$(echo "$ipt" | grep -E "$tip ($_generic_ipv4|$_generic_ipv6)" | cut -d' ' -f1)
			local mac=$(echo "$macIP" | grep $tip | awk '{print $1}')
			[ -z "$mac" ] && mac=$(GetMACbyIP "$tip")
			local ip_f=${ip/\//_}

			local ip_livefile=${hourly_conn_live_file_path/ip/${ip_f}}
			#XY todo: get connctions from ddd

			# local conn_records=$(echo -e "$ddd" | grep "$ip" | ${grep_ignore_ips})
			local conn_records=$(echo -e "$ddd" | grep "\"$ip\"" | grep -v -E $ignore_ip | awk -F "[,\[\" ]"  '{print $3" "$10}' | sort | uniq -c)
			if [ -n "$conn_records" ]; then
				[ ! -f $ip_livefile ] && touch $ip_livefile
				[ ! -f $ip_livefile ] && touch $hourly_conn_file
				echo -e "\n# \"$mac-$ip\" $(date +\"%Y-%m-%d-%H:%M\")" >> $ip_livefile
				if [ -z "$date_f" ]; then
					echo -e "\n# $(date +\"%Y-%m-%d-%H:%M\")" >> $hourly_conn_file
					date_f="1"
				fi

				local err=$(echo "${conn_records%,}" 2>&1 1>> $ip_livefile)

				# local ldata=$(echo -e "${conn_records%,} | awk -F "[,\[\" ]"  '{print $3" "$6" "$10}' | sort | uniq -c")
				# local err=$(echo -e $ldata 2>&1 1>> $ip_livefile)
				[ -n "$err" ] && Send2Log "ERROR >>> doliveUpdates:  $(IndentList "$err")" 3

				local amount=$(echo "${conn_records%,}" | wc -l)
				err=$(echo -e "hourlyConnData({\"id\":\"$mac-$ip\", \"hour\":\"$hour\", \"minute\":\"$minute\", \"conns\":\"$amount\"})" 2>&1 1>> $hourly_conn_file)

				[ -n "$err" ] && Send2Log "$err" 2

				# [ -n "$err" ] && Send2Log "ERROR >>> doliveconnUpdates:  $(IndentList "$err")" 3
				# Send2Log "curr_connections >>>\n$ddd" 0
			fi

			# local conn_records=$(echo -e "$ddd" | grep "$ip")
			ipt=$(echo -e "$ipt" | grep -v "$tip")

		fi
	done

	# $doArchiveLiveUpdates
}

doCurrConnections=CurrentConnections_1
$doCurrConnections

#LogEndOfFunction

