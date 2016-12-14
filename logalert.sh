echo "" > a.alert.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' haproxy.log > ip.log


rm count.log
rm *alert.log

FILE=./ip.log;
 for ip in `cat $FILE |cut -d ' ' -f 1 |sort |uniq`;
 do { COUNT=`grep ^$ip $FILE |wc -l`;
 if [[ "$COUNT" -gt "0" ]]; then echo "$COUNT:   $ip" >> count.log;
 fi }; done


cat count.log |cut -d ' ' -f 4 > column1.log




while read line; do    

(want=$line
awk -v want=$want  -F- '
function canon(ip){
    split(" "ip,x,/[^0-9]+/)
    return sprintf("%03d%03d%03d%03d",x[2],x[3],x[4],x[5])
}
BEGIN { val = canon(want) }
{ low = canon($1); high = canon($2);
  if(val>=low && val<=high)print want " in-range" >> want"alert.log"
  else print want " out-of-range" >> want"alert.log"
}

' ./range.conf)

done < column1.log





FILES="*alert.log"
for f in $FILES
do
	if grep -q in-range $f; then
        echo found
    else
        sendmail somebody@somewhere.somedomain < $f
fi

done
