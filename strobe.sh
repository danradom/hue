# define connection hash and bridge IP
hash="228a806218fe54d7173fa37e32948ae3"
bridge="192.168.0.2"

for light in 1 2 3 4 5 6 7 8; do
        curl -X PUT -d '{"1":"040000FFFF00003333000033330000FFFFFFFFFF"}' http://$bridge/api/$hash/lights/$light/pointsymbol  # blue fast
done

curl -X PUT -d '{"symbolselection":"01010C010101020103010401050106010701080109010A010B010C","duration":4000}' http://$bridge/api/$hash/groups/3/transmitsymbol
