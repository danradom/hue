# define input order
light=$1
status=$2
intensity=$3


# define lights
front="10"
back="11"
all="10 11"


# define intensity
low="85"
medium="170"
high="255"


if [ "$light" = "front" ]; then
        lights="$front"
elif [ "$light" = "back" ]; then
        lights="$back"
elif [ "$light" = "all" ]; then
        lights="$all"
fi


# validate input
if [ $# -lt 2 ]; then
        echo ""
echo "usage:  $0 <light> (front|back|all) state (on|off|status)"
        echo ""
        exit 1
fi

if [ $2 = "on" ]; then
        if [ $# -lt 3 ]; then
                echo ""
                echo "usage:  $0 $1 $2 <intensity> (low|medium|high)"
                echo ""
                exit 1
        fi
fi


# define connection hash and bridge IP
hash="228a806218fe54d7173fa37e32948ae3"
bridge="192.168.0.2"


# light on function
lights_on () {
        if [ $intensity = "low" ]; then
                for light in $lights; do
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$low'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$low'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                done
        elif [ $intensity = "medium" ]; then
                for light in $lights; do
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$medium'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$medium'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                done
        elif [ $intensity = "high" ]; then
                for light in $lights; do
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                        if [ $on = "true" ]; then
                                curl -X PUT -d '{"bri":'$high'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        elif [ $on = "false" ]; then
                                curl -X PUT -d '{"on":true,"bri":'$high'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        fi
                done
        fi
}


# light off function
lights_off () {
        for light in $lights; do
                on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                while [ $on = "true" ]; do
                        curl -X PUT -d '{"on":false}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
                        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
                done
        done
}



# status function
lights_status () {
for light in $lights; do
        on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
        reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f5 |cut -d: -f2 |sed 's/}//'`
        bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
        echo "light $light"
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
                echo "  brightness : $bri"
        fi
        echo ""
done
}


# turn lights on and off
if [ $2 = "on" ]; then
        lights_on
elif [ $2 = "off" ]; then
        lights_off
elif [ $2 = "status" ]; then
        lights_status
fi
