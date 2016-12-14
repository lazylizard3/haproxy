#!/bin/bash


LIST=`less haproxy.log | awk '{print $6}' | grep [0-9] | sort | uniq`
WHITELIST="202.42.255.254 203.116.206.254 118.189.148.172"

for IP in $LIST

do

echo $IP | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
if [ $? -ne 0 ] ; then
echo "$IP is not valid"
fi

echo $LIST
echo $IP
echo $WHITELIST | grep -q $IP
if [ $? -eq 0 ] ; then
echo "$IP in WHITELIST, its fine"
 elif
   [ $? -ne 0 ] ; then
#fi
#done

echo "$IP not in WHITELIST, see if in range"


#grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' haproxy.log > ip.log


#rm count.log
rm -f [0-9]*-alert.log

#FILE=./ip.log;
# for ip in `cat $FILE |cut -d ' ' -f 1 |sort |uniq`;
# do { COUNT=`grep ^$ip $FILE |wc -l`;
## if [[ "$COUNT" -gt "0" ]]; then echo "$COUNT:   $ip" >> count.log;
# fi }; done


#cat count.log |cut -d ' ' -f 4 > column1.log




#while read line; 

#do

ip1=$IP


 while read range;

 do

 read ip2 ip3 <<<$(IFS="-"; echo $range)

 function inet_aton ()
 {
    IFS=. read -r i1 i2 i3 i4 <<< $1
    ip32=$((i1*16777216+i2*65536+i3*256+i4))
    echo $ip32 > "$1".log
 }


 inet_aton $ip1
 inet_aton $ip2
 inet_aton $ip3

 echo $ip1
 echo $ip2
 echo $ip3

 ip="$(cat $ip1.log)"
 min="$(cat $ip2.log)"
 max="$(cat $ip3.log)"

 echo $ip
 echo $min
 echo $max

 (if [[ $ip -lt $min || $ip -gt $max ]]
 then
     echo "$ip1 out-of-range " >> ${ip1}-alert.log
 else echo "$ip1 in-range " >> ${ip1}-alert.log
 fi
 )

 done < range.conf

#done < column1.log


FILES="*alert.log"
for f in $FILES
do
	if grep -q in-range $f; then
        echo found
    else
        mail -s "$f haproxy logalertbash.sh" liangzhu@bii.a-star.edu.sg < $f && echo sent mail!
fi
done

fi
done
