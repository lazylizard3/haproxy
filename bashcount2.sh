rm 1.log
while read line; 

do
#IN="bla@some.com;john@home.com"
#read ADDR1 ADDR2 <<<$(IFS=";"; echo $IN)



ip1=$line


while read range;

do

read ip2 ip3 <<<$(IFS="-"; echo $range)

function inet_aton ()
{
    #local IFS=. ipaddr ip32 i
    echo ' before loop input is ' $1 >> 1.log
    IFS=. read -r i1 i2 i3 i4 <<< $1
    ip32=$((i1*16777216+i2*65536+i3*256+i4))
    #echo 'i = ' $i >> 1.log
    echo 'ip32 is ' $ip32 >> 1.log
    #echo 'ipaddr is ' $ipaddr >> 1.log
    #done
    echo $1 > "$ip1".log
}

inet_aton $ip1
inet_aton $ip2
inet_aton $ip3


ip="$(cat $ip1.log)"
min="$(cat $ip2.log)"
max="$(cat $ip3.log)"


(if [[ $ip -lt $min || $ip -gt $max ]]
 then
   echo $ip1 " " $ip " Input outside acceptable " $ip2"-"$ip3 "  range." 
 else echo $ip1 " " $ip " in " $ip2"-" $ip3 " range its ok"
fi
)

done < range.conf



done < column1.log
