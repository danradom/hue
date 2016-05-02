#
# $0 <group> on|off|status <brightness (percent)>"
#

# define connection hash and bridge IP
hash="YOUR_HASH_HERE"
bridge="192.168.0.2"


# define input order
group=$1
state=$2
bri=$3


# light groups
living="1"
kitchen="2"
office="3"
bedroom="4"
garage="5"
outside="6"
all="1 2 3 4 5 6"


# define lights
if [ $group = "living" ]; then
        lights="$living"
elif [ $group = "kitchen" ]; then
        lights="$kitchen"
elif [ $group = "office" ]; then
        lights="$office"
elif [ $group = "bedroom" ]; then
        lights="$bedroom"
elif [ $group = "garage" ]; then
        lights="$garage"
elif [ $group = "outside" ]; then
        lights="$outside"
elif [ $group = "all" ]; then
        lights="$all"
elif [ $group -eq $group ]; then
        lights="$group"
fi


# light on function
light_on () {
        # determine brightness
        if [ -z $bri ]; then
                bri=100
        fi
        bright=$(($bri*254/100))

        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"modelid/modelid/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c LWB00[46]` = 1 ]; then
                        type="white"
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
                                curl -X PUT -d '{"ct":369,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":369,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                elif [ `echo $ltype |grep -c LST001` = 1 ]; then
                        type="lightstrip"
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"ct":369,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":369,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
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

if [ -t 1 ]; then
        clear
fi

        printf "%-3s %-18s %-14s %-10s %-10s %-10s %-10s\n" "#" "name" "type" "state" "reachable" "bri" "hue"
        echo "------------------------------------------------------------------------------"

        for light in $lights; do
                unset state reach chue on bri type reachable name type
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"modelid/modelid/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c LWB00[46]` = 1 ]; then
                        type="white"
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
                        if [ "$type" = "white" ]; then
                                printf "%-3s %-18s %-14s %-10s %-10s %-10s\n" "$light" "$name" "$type" "$state" "$reach" "$bri"
                        fi
                fi
                if [ "$state" = "OFF" ]; then
                        printf "%-3s %-18s %-14s %-10s %-10s\n"  "$light" "$name" "$type" "$state" "$reach"
                fi

        done
        echo ""
}



# perform action
if [ $2 = "on" ]; then
        light_on
elif [ $2 = "off" ]; then
        light_off
elif [ $2 = "status" ]; then
        light_status
fi
