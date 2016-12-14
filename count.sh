FILE=./ip.log;
 for ip in `cat $FILE |cut -d ' ' -f 1 |sort |uniq`;
 do { COUNT=`grep ^$ip $FILE |wc -l`;
 if [[ "$COUNT" -gt "0" ]]; then echo "$COUNT:   $ip" >> count.log;
 fi }; done


cat count.log | cut -d ' ' -f 4 > column1.log
