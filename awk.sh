want=123.136.68.256
awk -v want=$want  -F- '
function canon(ip){
    split(" "ip,x,/[^0-9]+/)
    return sprintf("%03d%03d%03d%03d",x[2],x[3],x[4],x[5])
}
BEGIN { val = canon(want) }
{ low = canon($1); high = canon($2);
  if(val>=low && val<=high)print "in range " $0
  else print "out of range"
}

' ./range.conf
  
