# define input order
group=$1
state=$2
intensity=$3


# define groups
living="1 2 3 4"
kitchen="5 6 7 8"
bed="9"
all="1 2 3 4 5 6 7 8 9"


# validate input
if [ $# -lt 2 ]; then
	echo ""
	echo "usage:  $0 <group> (all|living|kitchen|bed) <state> (on|off|party|status)"
	echo ""
	exit 1
fi

if [ $2 = "on" ]; then
	if [ $# -lt 3 ]; then
		echo ""
		echo "usage:  $0 $1 $2 <intensity> (low|medium|high|random)"
		echo ""
		exit 1
	fi
fi


# traphandler function to turn off party mode
traphandler () {
	echo ""
	echo "	turning off party mode"
		lights_off
	echo ""
        exit 1234
}
trap traphandler SIGHUP SIGINT SIGTERM


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
hash="newdeveloper"
bridge="192.168.0.2"


# light on function
lights_on () {
	if [ $intensity = "low" ]; then
		for light in $lights; do
			on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
			if [ $on = "true" ]; then
				curl -X PUT -d '{"hue":14950,"bri":49,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			elif [ $on = "false" ]; then
				curl -X PUT -d '{"on":true,"hue":14950,"bri":49,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			fi
		done
	elif [ $intensity = "medium" ]; then
		for light in $lights; do
			on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
			if [ $on = "true" ]; then
				curl -X PUT -d '{"hue":14950,"bri":174,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			elif [ $on = "false" ]; then
				curl -X PUT -d '{"on":true,"hue":14950,"bri":174,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			fi
		done
	elif [ $intensity = "high" ]; then
		for light in $lights; do
			on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
			if [ $on = "true" ]; then
				curl -X PUT -d '{"hue":14950,"bri":254,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			elif [ $on = "false" ]; then
				curl -X PUT -d '{"on":true,"hue":14950,"bri":254,"sat":142}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			fi
		done
	elif [ $intensity = "random" ]; then
		for light in $lights; do
			on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
			bri=`shuf -i 0-255 -n 1`
			hue=`shuf -i 0-65535 -n 1`
			sat=`shuf -i 0-255 -n 1`
			if [ $on = "true" ]; then
				curl -X PUT -d '{"bri":'$bri',"sat":'$sat',"effect":"colorloop","transitiontime":2}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
			elif [ $on = "false" ]; then
				curl -X PUT -d '{"on":true,"bri":'$bri',"sat":'$sat',"effect":"colorloop","transitiontime":2}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
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


# party function
lights_party () {
	for light in $lights; do
		on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
		if [ $on = "false" ]; then
			bri=`shuf -i 0-255 -n 1`
			hue=`shuf -i 0-65535 -n 1`
			sat=`shuf -i 0-255 -n 1`
			curl -X PUT -d '{"on":true,"bri":'$bri',"sat":'$sat'}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
		fi
	done
	while true; do
		for light in $lights; do
			bri=`shuf -i 0-255 -n 1`
			hue=`shuf -i 0-65535 -n 1`
			sat=`shuf -i 0-255 -n 1`
			curl -X PUT -d '{"bri":'$bri',"sat":'$sat',"effect":"colorloop","transitiontime":2}' http://$bridge/api/$hash/lights/$light/state > /dev/null 2>&1
		done
	done
}


# status function
lights_status () {
for light in $lights; do
	on=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f1 |cut -d\{ -f3 |cut -d: -f2`
	reachable=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f11 |cut -d: -f2 |sed 's/}//'`
	hue=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f3 |cut -d: -f2`
	sat=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f4 |cut -d: -f2`
	bri=`curl -X GET -s "http://$bridge/api/$hash/lights/$light" |cut -d, -f2 |cut -d: -f2`
	echo "settings for light $light are as follows"
	if [ $on = "true" ]; then
		echo "	the light is ON"
	elif [ $on = "false" ]; then
		echo "	the light is OFF"
	fi
	if [ $reachable = "true" ]; then
		echo "	the light is reachable"
	elif [ $reachable = "false" ]; then
		echo "	the light is not reachable"
	fi
	echo "		color hue : $hue"
	echo "		color saturation : $sat"
	echo "		color brightness : $bri"
	echo ""
	echo ""
done
}


# turn lights on and off
if [ $2 = "on" ]; then
	lights_on
elif [ $2 = "off" ]; then
	lights_off
elif [ $2 = "party" ]; then
	lights_party
elif [ $2 = "status" ]; then
	lights_status
fi
