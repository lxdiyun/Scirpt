ACCESS_DATE=`perl -e '@d=localtime ((stat(shift))[9]); printf "%4d %02d %02d %02d:%02d:%02d\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0]'  $V_LOC/view_db.state`

