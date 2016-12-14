#!/bin/bash
#
#
# NOTES
# WHITELIST contains list of single IPs separated by spaces
# eg. 202.42.255.254 192.168.1.1

LIST=`less haproxy.log | awk '{print $6}' | grep [0-9] | sort | uniq`
WHITELIST="202.42.255.254 203.116.206.254 118.189.148.172"

for IP in $LIST
do
#echo $IP

# check that IP is well formed/in range 0.0.0.0-255.255.255.255
echo $IP | grep -E -q '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][1-9]?)$'
if [ $? -eq 0 ] ; then
  
# check that IP is in WHITELIST
	echo $WHITELIST | grep -q $IP
	if [ $? -eq 0 ] ; then
	echo "$IP in WHITELIST, its fine"
	continue
 	elif
   	[ $? -ne 0 ] ; then
	echo "$IP not in WHITELIST, see if in range"
        # check range 

ip1=$IP

#
# range.conf is a file with IP ranges
# eg 123.136.68.0-123.136.68.255
#

rm -f [0-9]*-alert.log

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

 if [[ $ip -lt $min || $ip -gt $max ]]; then
 echo "$ip1 out-of-range " >> ${ip1}-alert.log
 else 
 echo "$ip1 in-range " >> ${ip1}-alert.log
 fi
done < range.conf


FILES="[0-9]*-alert.log"
for f in $FILES
do
if grep -q in-range $f; then
        echo found
    else
        mail -s "haproxy log alert test.sh" liangzhu@bii.a-star.edu.sg < $f && echo sent mail!
fi
done


fi # end if echo WHITELIST blahlbalh
fi # end if grep -E blahblah
done