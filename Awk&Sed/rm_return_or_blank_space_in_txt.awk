#!gawk -f
BEGIN {
   #   i = 0;
   #   print "begin";
}

/^.*$/ {
   #   print i++;
   $line = $0;
#   non_blank_pos = match($line, "[^ ]");
#   if(non_blank_pos == 5) {
#      $line = substr($line, 5);
#   }
   pos_end_of_line = match($line,"$");
   
   if(pos_end_of_line >= 86 )
   {
      printf("%s", $line);
   }
   else 
   {
      print $line;
   }
}

