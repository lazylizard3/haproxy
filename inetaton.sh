ip1=192.168.0.100
ip2=192.168.0.0
ip3=192.168.0.255



function inet_aton ()
{
    local IFS=. ipaddr ip32 i
    ipaddr=($1)
    #echo $ipaddr" is ipaddr"
    for i in 3 2 1 0
    do
        (( ip32 += ipaddr[3-i] * (256 ** i) ))
    done
    echo $ip32 > "$1".log
    echo $ip32 > "$1".log
    echo $ip32 > "$1".log
    #eval "$1=$((ip32))"
    #return $ip32
    #echo $ip32" is ip32 "
}

#echo $ip1
#echo $ip2
#echo $ip3

#ip=$(inet_aton $ip1)
#min=$(inet_aton $ip2)
#max=$(inet_aton $ip3)

inet_aton $ip1
inet_aton $ip2
inet_aton $ip3
#ip4="$(ip32)"
#ip4=`$ip32`
#echo $ip1
#echo $ip32
#echo $ip4


ip="$(cat $ip1.log)"
min="$(cat $ip2.log)"
max="$(cat $ip3.log)"

echo "ip is " $ip
echo "min is " $min
echo "max is " $max


