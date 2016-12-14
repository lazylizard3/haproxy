echo -n "Enter VPS IP address, min IP address, max IP address:"
read userinput




FILE=./range.conf;
 for ip in `cat $FILE |cut -d ' ' -f 1 |sort |uniq`;
 do { COUNT=`grep ^$ip $FILE |wc -l`;
 if [[ "$COUNT" -gt "0" ]]; then echo "$COUNT:   $ip" >> count.log;
 fi }; done



ip1=`echo "$userinput" | cut -d' ' -f1`
ip2=`echo "$userinput" | cut -d' ' -f2`
ip3=`echo "$userinput" | cut -d' ' -f3`

lookupip="vps $ip1"

ip=`inet_aton $ip1`
min=`inet_aton $ip2`
max=`inet_aton $ip3`
