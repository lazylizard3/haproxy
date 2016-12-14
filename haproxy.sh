#!/bin/bash
#
#
# NOTES
# WHITELIST contains list of single IPs separated by spaces
# eg. 202.42.255.254 192.168.1.1




LIST=`cat haproxy_0.log-* | awk '{print $6}' | grep [0-9] | sort | uniq`
WHITELIST="202.42.255.254 203.116.206.254 118.189.148.172"

for IP in $LIST
do

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

IP_WHITE_RANGE="123.136.68.0-123.136.68.255 202.6.243.0-202.6.243.255 212.64.228.98-212.64.228.100 203.89.150.0-203.89.150.255"



#while read range;
for range in $IP_WHITE_RANGE
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
 #echo "$ip1 out-of-range " >> ${ip1}-alert.log
 alert="$alert $ip1 out-of-range"
 else 
 #echo "$ip1 in-range " >> ${ip1}-alert.log
 alert="$alert $ip1 in-range"
 break
 fi

done
        echo $alert | grep -q in-range
        if [ $? -eq 0 ] ; then
        echo "$IP in range.conf, its fine. $alert" && alert=''
        continue
        elif
        [ $? -ne 0 ] ; then
        #mail -s "haproxy log alert haproxy.sh $alert is not in $WHITELIST or range.conf" lazylizard@tonite.cu.cc < range.conf && echo $alert && alert='' && echo sent mail!
        echo "haproxy log alert $alert is not in $WHITELIST or $IP_WHITE_RANGE" | /bin/mail -S mail.isonet.bii -s "isonet error $alert is not in $WHITELIST or $IP_WHITE_RANGE" somebody@somewhere.somedomain
        fi

echo $alert




fi # end if echo WHITELIST blahlbalh
fi # end if grep -E blahblah
done
