#
# $0 <group> on|off|status <brightness>"
#

# define connection hash and bridge IP
hash="1234567890"
bridge="192.168.0.2"


# define input order
group=$1
state=$2
bright=$3


# light #
# $0 <group> on|off|status <brightness>"
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
front="14"
garage="15"
back="16"
outside="14 15 16"
honda="17"
bus="18"
away="9 10 11 13 17"
overnight="9 10 13"
all="1 2 3 4 5 6 7 8 9 10 11 12 13 15 16 17 18"


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
elif [ $group = "front" ]; then
        lights="$front"
elif [ $group = "garage" ]; then
        lights="$garage"
elif [ $group = "back" ]; then
        lights="$back"
elif [ $group = "outside" ]; then
        lights="$outside"
elif [ $group = "honda" ]; then
        lights="$honda"
elif [ $group = "bus" ]; then
        lights="$bus"
elif [ $group = "away" ]; then
        lights="$away"
elif [ $group = "overnight" ]; then
        lights="$overnight"
elif [ $group = "all" ]; then
        lights="$all"
elif [ $group -eq $group ]; then
        lights="$group"
fi


# light on function
light_on () {
        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"type/type/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c Dimmable` = 1 ]; then
                        type="lux"
                else
                        type="hue"
                fi
                if [ "$type" = "lux" ]; then
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                fi
                if [ "$type" = "hue" ]; then
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"ct":365,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":365,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
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
        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"type/type/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c Dimmable` = 1 ]; then
                        type="lux"
                else
                        type="hue"
                fi
                on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                if [ $type = "lux" ]; then
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f5 |cut -d: -f2 |sed 's/}//'`
                elif [ $type = "hue" ]; then
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f11 |cut -d: -f2 |sed 's/}//'`
                        if [ $on = "true" ]; then
                                ct=`curl -X GET -s "http://$bridge/api/$hash/lights/5" |cut -d, -f7 |cut -d: -f2 |sed 's/}//'`
                        fi
                fi
                bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
                echo "light: $light"
                echo "type:  $type"

                if [ $on = "true" ]; then
                        echo "  state ON"
                elif [ $on = "false" ]; then
                        echo "  state OFF"
                fi

                if [ $reachable = "true" ]; then
                        echo "  reachable YES"
                elif [ $reachable = "false" ]; then
                        echo "  reachable NO"
                fi

                if [ $on = "true" ]; then
                        echo "  brightness: $bri"
                fi
                if [ $type = "hue" ] && [ $on = "true" ]; then
                        echo "  color temp: $ct"
                fi
                echo ""
                echo ""
        done
}


# perform action
if [ $2 = "on" ]; then
        light_on
elif [ $2 = "off" ]; then
        light_off
elif [ $2 = "status" ]; then
        light_status
fiassignments for reference
living="1 2 3 4"
kitchen="5 6 7 8"
sink="9"
hall="10"
bedroom="11"
sam="12"
bailey="13"
front="14"
garage="15"
back="16"
outside="14 15 16"
honda="17"
bus="18"
away="9 10 11 13 17"
overnight="9 10 13"
all="1 2 3 4 5 6 7 8 9 10 11 12 13 15 16 17 18"


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
elif [ $group = "front" ]; then
        lights="$front"
elif [ $group = "garage" ]; then
        lights="$garage"
elif [ $group = "back" ]; then
        lights="$back"
elif [ $group = "outside" ]; then
        lights="$outside"
elif [ $group = "honda" ]; then
        lights="$honda"
elif [ $group = "bus" ]; then
        lights="$bus"
elif [ $group = "away" ]; then
        lights="$away"
elif [ $group = "overnight" ]; then
        lights="$overnight"
elif [ $group = "all" ]; then
        lights="$all"
elif [ $group -eq $group ]; then
        lights="$group"
fi


# light on function
light_on () {
        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"type/type/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c Dimmable` = 1 ]; then
                        type="lux"
                else
                        type="hue"
                fi
                if [ "$type" = "lux" ]; then
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                fi
                if [ "$type" = "hue" ]; then
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"ct":365,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"ct":365,"bri":'$bright'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
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
        for light in $lights; do
                ltype=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |sed -e 's/.*\"type/type/' -e 's/\,.*//' -e 's/type\": \"//' -e 's/\"//'`
                if [ `echo $ltype |grep -c Dimmable` = 1 ]; then
                        type="lux"
                else
                        type="hue"
                fi
                on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                if [ $type = "lux" ]; then
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f5 |cut -d: -f2 |sed 's/}//'`
                elif [ $type = "hue" ]; then
                        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f11 |cut -d: -f2 |sed 's/}//'`
                        if [ $on = "true" ]; then
                                ct=`curl -X GET -s "http://$bridge/api/$hash/lights/5" |cut -d, -f7 |cut -d: -f2 |sed 's/}//'`
                        fi
                fi
                bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
                echo "light: $light"
                echo "type:  $type"

                if [ $on = "true" ]; then
                        echo "  state ON"
                elif [ $on = "false" ]; then
                        echo "  state OFF"
                fi

                if [ $reachable = "true" ]; then
                        echo "  reachable YES"
                elif [ $reachable = "false" ]; then
                        echo "  reachable NO"
                fi

                if [ $on = "true" ]; then
                        echo "  brightness: $bri"
                fi
                if [ $type = "hue" ] && [ $on = "true" ]; then
                        echo "  color temp: $ct"
                fi
                echo ""
                echo ""
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
