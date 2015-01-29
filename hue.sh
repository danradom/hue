#
# $0 <group> on|off|status|state <brightness>"
#

# define connection hash and bridge IP
hash="1234567890"
bridge="192.168.0.2"


# define input order
group=$1
state=$2
bright=$3


# light groups
living="1 2 3 4"
kitchen="5 6 7 8"
sink="9"
hall="10"
bedroom="11"
sam="12"
bailey="13"
ofront="14"
ogarage="15"
oback="16"
inside="1 2 3 4 5 6 7 8 9 10 11 12 13 17 18"
outside="14 15 16"
bus="17"
honda="18"
garage="17 18"
upstairs="12 13"
away="9 10 11 13 17"
overnight="9 10 13"
outside="14 15 16"
lux="14 15 16 17 18"
ls="19 20"
ls1="19"
ls2="20"
all="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"


# define lights
if [ $group = "living" ]; then
        lights="$living"
elif [ $group = "kitchen" ]; then
        lights="$kitchen"
elif [ $group = "sink" ]; then
        lights="$sink"
elif [ $group = "hall" ]; then
        lights="$hall"
elif [ $group = "bedroom" ]; then
        lights="$bedroom"
elif [ $group = "sam" ]; then
        lights="$sam"
elif [ $group = "bailey" ]; then
        lights="$bailey"
elif [ $group = "ofront" ]; then
        lights="$ofront"
elif [ $group = "ogarage" ]; then
        lights="$ogarage"
elif [ $group = "oback" ]; then
        lights="$oback"
elif [ $group = "outside" ]; then
        lights="$outside"
elif [ $group = "inside" ]; then
        lights="$inside"
elif [ $group = "honda" ]; then
        lights="$honda"
elif [ $group = "bus" ]; then
        lights="$bus"
elif [ $group = "upstairs" ]; then
        lights="$upstairs"
elif [ $group = "away" ]; then
        lights="$away"
elif [ $group = "outside" ]; then
        lights="$outside"
elif [ $group = "overnight" ]; then
        lights="$overnight"
elif [ $group = "lux" ]; then
        lights="$lux"
elif [ $group = "ls" ]; then
        lights="$ls"
elif [ $group = "ls1" ]; then
        lights="$ls1"
elif [ $group = "ls2" ]; then
        lights="$ls2"
elif [ $group = "all" ]; then
        lights="$all"
elif [ $group -eq $group ]; then
        lights="$group"
fi


# light on function
light_on () {
        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"modelid/modelid/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c LWB004` = 1 ]; then
                        type="lux"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                elif [ `echo $ltype |grep -c LCT00[12]` = 1 ]; then
                        type="hue"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"ct":153,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":153,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                elif [ `echo $ltype |grep -c LST001` = 1 ]; then
                        type="lightstrip"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"ct":153,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":153,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                fi
        done
}


# light off function
light_off () {
        for light in $lights; do
                on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                while [ $on = "true" ]; do
                        curl -X PUT -d '{"on":false}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                done
        done
}


# light status function
light_status () {

        printf "%-3s %-18s %-14s %-10s %-10s %-10s %-10s\n" "#" "name" "type" "state" "reachable" "bri" "hue"
        echo "------------------------------------------------------------------------"

        for light in $lights; do
                unset state reach chue on bri type reachable name type
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"modelid/modelid/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c LWB004` = 1 ]; then
                        type="lux"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f4 |cut -d: -f2 |sed 's/}//'`
                        name=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f6 |cut -d: -f2 |sed -e 's/}//' -e 's/"//' -e 's/\"//'`
                        if [ $on = "true" ]; then
                                bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
                        fi
                elif [ `echo $ltype |grep -c LCT00[12]` = 1 ]; then
                        type="hue"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f11 |cut -d: -f2 |sed 's/}//'`
                        name=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f13 |cut -d: -f2 |sed -e 's/}//' -e 's/"//' -e 's/\"//'`
                        if [ $on = "true" ]; then
                                hue=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f3 |cut -d: -f2 |sed 's/}//'`
                                bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
                        fi
                elif [ `echo $ltype |grep -c LST001` = 1 ]; then
                        type="lightstrip"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f10 |cut -d: -f2 |sed 's/}//'`
                        name=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f12 |cut -d: -f2 |sed -e 's/}//' -e 's/"//' -e 's/\"//'`
                        if [ $on = "true" ]; then
                                hue=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f3 |cut -d: -f2 |sed 's/}//'`
                                bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
                        fi
                fi

                if [ $reachable = "true" ]; then
                        reach="YES"
                else
                        reach="NO"
                fi

                if [ $on = "true" ]; then
                        state="ON"
                else
                        state="OFF"
                fi

                if [ "$state" = "ON" ]; then
                        if [ "$type" = "hue" ]; then
                                printf "%-3s %-18s %-14s %-10s %-10s %-10s %-10s\n" "$light" "$name" "$type" "$state" "$reach" "$bri" "$hue"
                        fi
                        if [ "$type" = "lightstrip" ]; then
                                printf "%-3s %-18s %-14s %-10s %-10s %-10s %-10s\n" "$light" "$name" "$type" "$state" "$reach" "$bri" "$hue"
                        fi
                        if [ "$type" = "lux" ]; then
                                printf "%-3s %-18s %-14s %-10s %-10s %-10s\n" "$light" "$name" "$type" "$state" "$reach" "$bri"
                        fi
                fi
                if [ "$state" = "OFF" ]; then
                        printf "%-3s %-18s %-14s %-10s %-10s\n"  "$light" "$name" "$type" "$state" "$reach"
                fi

        done
}



# perform action
if [ $2 = "on" ]; then
        light_on
elif [ $2 = "off" ]; then
        light_off
elif [ $2 = "status" ]; then
        light_status
fi
