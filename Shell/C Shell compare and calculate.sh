#!/bin/sh
l=0;

for i in `cat  $HOME/viewstate_list`
do
   l=`expr $l + 1`
   echo $l;
   if  [  99 -le $l ];  then
      echo "done"
      break;
   fi

done
