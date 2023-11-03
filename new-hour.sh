#!/bin/sh

##########################################################################
# Yet Another Monitor (YAMon)
# Copyright (c) 2013-present Al Caughey
# All rights reserved.
#
# runs tasks needed to start a new hour
# run: by cron
# History
# 2020-01-26: 4.0.7 - no changes
# 2020-01-03: 4.0.6 - no changes
# 2019-12-23: 4.0.5 - no changes
# 2019-11-24: 4.0.4 - no changes (yet)
# 2019-06-18: development starts on initial v4 release
#
##########################################################################
the_hour=$(date +"%H")
[ "$the_hour" == "00" ]  && sleep 60
#sleep 60 to wait new-day.sh

d_baseDir=$(cd "$(dirname "$0")" && pwd)
source "${d_baseDir}/includes/shared.sh"

hr=$(echo $_ts | cut -d':' -f1)
Send2Log "new hour: Start of hour $hr" 1

rawtraffic_hr="${tmplog}raw-traffic-$_ds-$hr.txt"
ChangePath 'rawtraffic_hr' "$rawtraffic_hr"

[ ! -f "$rawtraffic_hr" ] && > "$rawtraffic_hr"
Send2Log "new hour: created new temporary hour file: $rawtraffic_hr"

#hourlyDataFile='/tmp/yamon/hourly_2022-02-13.js'
_ds=$(date +"%Y-%m-%d")
v_hourlyDataFile="${tmplog}hourly_${_ds}.js"

[ "$hourlyDataFile" != "$v_hourlyDataFile" ] && Send2Log "hourlyDataFile $hourlyDataFile not right, should be $v_hourlyDataFile" 2 && hourlyDataFile="$v_hourlyDataFile" &&ChangePath 'hourlyDataFile' "$hourlyDataFile" 

[ ! -f "$hourlyDataFile" ] && Send2Log "file hourlyDataFile $hourlyDataFile not exits" 2 && echo -e "var hourly_created=\"${_ds} ${_ts}\"\nvar hourly_updated=\"${_ds} ${_ts}\"\nvar disk_utilization=\"\"\nvar serverUptime=\"$_uptime\"\nvar freeMem=\"\",availMem=\"\",totMem=\"\"" > "$hourlyDataFile"

sleep 5
[ -z "$(grep "// Hour: $hr" "$hourlyDataFile")" ] && echo -e "\n// Hour: $hr" >> "$hourlyDataFile"

LogEndOfFunction
