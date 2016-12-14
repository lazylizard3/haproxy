while read line; do

(want=$line
awk -v want=$want  -F- '
function canon(ip){
    split(" "ip,x,/[^0-9]+/)
    return sprintf("%03d%03d%03d%03d",x[1],x[2],x[3],x[4])
print ip "is ip"
print want "is want"
}
BEGIN { val = canon(want) }
{ low = canon($1); high = canon($2);
  if(val>=low && val<=high)print want " in range" $0 ip
  else print want " out-of-range" $0 ip
}

' ./range.conf)

done < column1.log

