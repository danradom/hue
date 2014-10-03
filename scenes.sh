group=$1
color=$2


if [ $# -ne 2 ]; then
        echo ""
        echo "usage:  $0 <group> (living|all|kitchen|bed) <color> (blue|red|green|yellow|orange|purple|pink|warm|tv)"
        echo ""
        exit 1
fi


# define groups
living="1 2 3 4"
kitchen="5 6 7 8"
bed="9"
all="1 2 3 4 5 6 7 8 9"


# define lights
if [ $group = "living" ]; then
        lights="$living"
elif [ $group = "bed" ]; then
        lights="$bed"
elif [ $group = "all" ]; then
        lights="$all"
elif [ $group = "kitchen" ]; then
        lights="$kitchen"
fi


# define connection hash and bridge IP
hash="228a806218fe54d7173fa37e32948ae3"
bridge="192.168.0.2"


# define colors
blue="47000"
red="65535"
green="25600"
orange="4096"
yellow="16384"
purple="49408"
pink="54553"
warm="14708"
tv="47812"


if [ "$color" = "blue" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$blue',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "red" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$red',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "green" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$green',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "orange" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$orange',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "yellow" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$yellow',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "purple" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$purple',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "pink" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$pink',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "warm" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":150,"hue":'$warm',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
elif [ "$color" = "tv" ]; then
        for light in $lights; do
                curl -X PUT -d '{"on":true,"bri":15,"hue":'$tv',"sat":255}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
        done
fi
