#!/bin/sh
#
#
STGLOC1=/net/gdnt228/vol/vol0/MG/viewstore_MG
STGLOC2=/net/gdnt118/vol/mg/view_store
USAGE1=`(cd ${STGLOC1}; df -bk . ) | grep net | awk '{print $5}'`
USAGE2=`(cd ${STGLOC2}; df -bk . ) | grep net | awk '{print $5}'`

CT=/usr/atria/bin/cleartool
#cd /home/dellairj/bin/checkview
cd /net/gdnt56/MG/viewmgmt/bin
USER=`who am i|awk '{print $1}'`
APP_GROUP=mg
CC_LIST=`cat $APP_GROUP/cc_list`
TOTAL_SIZE1=0
TOTAL_SIZE2=0
VIEW_NUM1=0
VIEW_NUM2=0
#MAILLIST="sherryzhu@gdnt.com.cn,chrisjiang@gdnt.com.cn,sabrinali@gdnt.com.cn"
MAILLIST="adli@gdnt.com.cn"
USERMAIL=`/usr/bin/ypcat passwd|grep $USER":"|grep "\@"|cut -f5 -d':'|cut -f1 -d','`
#MAILLIST="$MAILLIST"",""$USERMAIL"

################ delete temporary file in advance ##########################################

rm  $HOME/viewstate_list 2>/dev/null
rm  $HOME/check_viewstate* 2>/dev/null
rm  $HOME/viewstate_report* 2>/dev/null
rm  $HOME/viewstate_tmp_sort 2>/dev/null

########## Collect list of views on gdnt228 ##################################################################### 

	$CT lsview | sed 's/*/ /'|grep " "|grep "viewstore_MG"|grep -v "\-tag"|awk '{print $1}'>> $HOME/viewstate_list
        $CT lsview | sed 's/*/ /'|grep " "|grep "mg/view_store"|grep -v "\-tag"|awk '{print $1}'>> $HOME/viewstate_list

################ Generate view list #################################################################

l=0;

for i in `cat  $HOME/viewstate_list`
do
   l=`expr $l + 1`
   echo $l;
   if  [  99 -le $l ];  then
      echo "done"
      break;
   fi
	V_LOC=`$CT lsview $i| sed 's/*/ /'|grep " "|awk '{print $2}'`


#############  Collect detail view information  ###################################################

	USE_STAT=`find $V_LOC/view_db.state -print 2>> $HOME/check_viewstate.log` 

	if [ "$USE_STAT" != "" ] ; then
		echo "Collecting information of view: "$i
		OWNER=`ls -l $V_LOC/view_db.state|grep " "|awk '{print $3}'`
		#ACCESS_DATE=`ls -l $V_LOC/view_db.state|grep " "|awk '{print $9" "$6" "$7" "$8}'`
		ACCESS_DATE=`perl -e '@d=localtime ((stat(shift))[9]); printf "%4d %02d %02d %02d:%02d:%02d\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0]'  $V_LOC/view_db.state`
		V_SIZE=`du -ks $V_LOC|grep "/net/"|awk '{print $1}'`
                SERVER=`$CT lsview $i| sed 's/*/ /'|grep " "|awk '{print $2}'|awk '{FS="/"};{print $3}'`
	
            if [ "$SERVER" = "gdnt228" ] ; then
                  TOTAL_SIZE1=`expr $TOTAL_SIZE1 + $V_SIZE`
                  VIEW_NUM1=`expr $VIEW_NUM1 + 1`

            else
                  TOTAL_SIZE2=`expr $TOTAL_SIZE2 + $V_SIZE`
                  VIEW_NUM2=`expr $VIEW_NUM2 + 1`

            fi
	
	#	TOTAL_SIZE=`expr $TOTAL_SIZE + $V_SIZE`
	#	VIEW_NUM=`expr $VIEW_NUM + 1`
		V_SIZE_G=`expr $V_SIZE \* 10 / 1024 / 10`"."`expr $V_SIZE \* 10 / 1024 % 10`



echo "$i\t$OWNER\t$ACCESS_DATE\t$V_SIZE_G\t$SERVER" >>  $HOME/viewstate_tmp_sort
	fi
done 


#############  Sort view information file ################################################################

sort +6rn  $HOME/viewstate_tmp_sort -o  $HOME/viewstate_tmp_sort
TOTAL_SIZE_G1=`expr $TOTAL_SIZE1 \* 10 / 1024 / 1024 / 10`"."`expr $TOTAL_SIZE1 \* 10 / 1024 / 1024 % 10`
TOTAL_SIZE_G2=`expr $TOTAL_SIZE2 \* 10 / 1024 / 1024 / 10`"."`expr $TOTAL_SIZE2 \* 10 / 1024 / 1024 % 10`


############  Use loop to generate mail content ##########################################################

cat  $HOME/viewstate_tmp_sort | while read line
do
	echo $line
	TAG=`echo $line | awk '{print $1}'`
	OWNER=`echo $line | awk '{print $2}'`
	ACCESS_DATE=`echo $line | awk '{print $3" "$4" "$5" "$6}'`
	V_SIZE_G=`echo $line | awk '{print $7}'`
        SERVER=`echo $line | awk '{print $8}'`


################ Continue generate the mail content ######################################################

                echo " <tr style='mso-yfti-irow:1;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <td width=300 nowrap style='width:489.0pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.content
                echo "  border-top:none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:">> $HOME/viewstate_report.content
                echo "  solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:">> $HOME/viewstate_report.content
                echo "  0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <p class=MsoNormal align=left style='text-align:left;mso-pagination:widow-orphan'><span">> $HOME/viewstate_report.content
                echo "  lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>">> $HOME/viewstate_report.content
                echo $TAG>> $HOME/viewstate_report.content
                echo "<o:p></o:p></span></p>">> $HOME/viewstate_report.content
                echo "  </td>">> $HOME/viewstate_report.content
                echo "  <td width=78 nowrap style='width:58.8pt;border-top:none;border-left:none;">> $HOME/viewstate_report.content
                echo "  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;">> $HOME/viewstate_report.content
                echo "  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;">> $HOME/viewstate_report.content
                echo "  padding:0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <p class=MsoNormal align=left style='text-align:left;mso-pagination:widow-orphan'><span">> $HOME/viewstate_report.content
                echo "  class=SpellE><span lang=EN-US style='font-size:12.0pt;font-family:Arial;">> $HOME/viewstate_report.content
                echo "  mso-font-kerning:0pt'>">> $HOME/viewstate_report.content
                echo $OWNER>> $HOME/viewstate_report.content
                echo "</span></span><span lang=EN-US style='font-size:">> $HOME/viewstate_report.content
                echo "  12.0pt;font-family:Arial;mso-font-kerning:0pt'><o:p></o:p></span></p>">> $HOME/viewstate_report.content
                echo "  </td>">> $HOME/viewstate_report.content
                echo "  <td width=139 nowrap style='width:104.0pt;border-top:none;border-left:none;">> $HOME/viewstate_report.content
                echo "  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;">> $HOME/viewstate_report.content
                echo "  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;">> $HOME/viewstate_report.content
                echo "  padding:0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <p class=MsoNormal align=right style='text-align:right;mso-pagination:widow-orphan'><span">> $HOME/viewstate_report.content
                echo "  lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>">> $HOME/viewstate_report.content
                echo $ACCESS_DATE>> $HOME/viewstate_report.content
                echo " </span><span lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'><o:p></o:p></span></p>">> $HOME/viewstate_report.content
                echo "  </td>">> $HOME/viewstate_report.content
                echo "  <td width=84 nowrap style='width:63.0pt;border-top:none;border-left:none;">> $HOME/viewstate_report.content
                echo "  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;">> $HOME/viewstate_report.content
                echo "  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;">> $HOME/viewstate_report.content
                echo "  padding:0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <p class=MsoNormal align=right style='text-align:right;mso-pagination:widow-orphan'><span">> $HOME/viewstate_report.content
                echo "  lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>">> $HOME/viewstate_report.content
                echo $V_SIZE_G>> $HOME/viewstate_report.content
                echo "<o:p></o:p></span></p>">> $HOME/viewstate_report.content
                echo "  </td>">> $HOME/viewstate_report.content
                echo "  <td width=84 nowrap style='width:63.0pt;border-top:none;border-left:none;">> $HOME/viewstate_report.content
                echo "  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;">> $HOME/viewstate_report.content
                echo "  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;">> $HOME/viewstate_report.content
                echo "  padding:0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.content
                echo "  <p class=MsoNormal align=right style='text-align:right;mso-pagination:widow-orphan'><span">> $HOME/viewstate_report.content
                echo "  lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>">> $HOME/viewstate_report.content
                echo $SERVER>> $HOME/viewstate_report.content
                echo "<o:p></o:p></span></p>">> $HOME/viewstate_report.content
                echo "  </td>">> $HOME/viewstate_report.content
                echo " </tr>">> $HOME/viewstate_report.content

done


######### Generate Mail Content -- Header ###########################################################################

echo "<html><body lang=EN-US style='tab-interval:21.0pt;text-justify-trim:punctuation'>">> $HOME/viewstate_report.head
echo "<div class=Section1 style='layout-grid:15.6pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal style='layout-grid-mode:char'><b style='mso-bidi-font-weight:">> $HOME/viewstate_report.head
echo "normal'><span lang=EN-US style='font-size:14.0pt;font-family:Arial;mso-fareast-font-family:">> $HOME/viewstate_report.head
echo "arial'>Hi all,<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head

echo "<p class=MsoNormal style='margin-left:21.0pt;mso-para-margin-left:2.0gd;">> $HOME/viewstate_report.head
echo "layout-grid-mode:char'><b style='mso-bidi-font-weight:normal'><span lang=EN-US">> $HOME/viewstate_report.head
echo "Below is the view statistical information! <o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "$USER is sending this mail. <o:p></o:p></span></b></p>">> $HOME/viewstate_report.head

echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Total of VIEWs on gdnt228:">> $HOME/viewstate_report.head
echo "<span style='color:red'>"$VIEW_NUM1"</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Total of gdnt228 SIZE: <span">> $HOME/viewstate_report.head
echo "style='color:red'>"227 GB"</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Used gdnt228 SIZE: <span">> $HOME/viewstate_report.head
echo "style='color:red'>"$TOTAL_SIZE_G1" GB</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Disk usage:">> $HOME/viewstate_report.head
echo "<span style='color:red'>"$USAGE1"</span></span></b></p>">> $HOME/viewstate_report.head

echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Total of VIEWs on gdnt118:">> $HOME/viewstate_report.head
echo "<span style='color:red'>"$VIEW_NUM2"</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Total of gdnt228 SIZE: <span">> $HOME/viewstate_report.head
echo "style='color:red'>"160 GB"</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Used gdnt228 SIZE: <span">> $HOME/viewstate_report.head
echo "style='color:red'>"$TOTAL_SIZE_G2" GB</span></span></b></p>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal><b><span lang=EN-US style='font-size:16.0pt'>Disk usage:">> $HOME/viewstate_report.head
echo "<span style='color:red'>"$USAGE2"</span></span></b></p>">> $HOME/viewstate_report.head

echo "<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US">> $HOME/viewstate_report.head
echo "style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></p>">> $HOME/viewstate_report.head
echo "<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=953">> $HOME/viewstate_report.head
echo "style='width:714.8pt;margin-left:-1.15pt;border-collapse:collapse;mso-padding-alt:">> $HOME/viewstate_report.head
echo "0cm 5.4pt 0cm 5.4pt'>">> $HOME/viewstate_report.head
echo "<tr style='mso-yfti-irow:0;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<td width=300 nowrap style='width:489.0pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.head
echo "mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan'><b><span">> $HOME/viewstate_report.head
echo "lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>View  Name<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "</td>">> $HOME/viewstate_report.head
echo "<td width=78 nowrap style='width:58.8pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.head
echo "border-left:none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:">> $HOME/viewstate_report.head
echo "solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:">> $HOME/viewstate_report.head
echo "0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan'><b><span">> $HOME/viewstate_report.head
echo "lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>Owner<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "</td>">> $HOME/viewstate_report.head
echo "<td width=139 nowrap style='width:104.0pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.head
echo "border-left:none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:">> $HOME/viewstate_report.head
echo "solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:">> $HOME/viewstate_report.head
echo "0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan'><b><span">> $HOME/viewstate_report.head
echo "lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>Last  Use<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "</td>">> $HOME/viewstate_report.head
echo "<td width=84 nowrap style='width:63.0pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.head
echo "border-left:none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:">> $HOME/viewstate_report.head
echo "solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:">> $HOME/viewstate_report.head
echo "0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan'><b><span">> $HOME/viewstate_report.head
echo "lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>Size  (mb)<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "</td>">> $HOME/viewstate_report.head
echo "<td width=84 nowrap style='width:63.0pt;border:solid windowtext 1.0pt;">> $HOME/viewstate_report.head
echo "border-left:none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:">> $HOME/viewstate_report.head
echo "solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;padding:">> $HOME/viewstate_report.head
echo "0cm 5.4pt 0cm 5.4pt;height:14.25pt'>">> $HOME/viewstate_report.head
echo "<p class=MsoNormal align=center style='text-align:center;mso-pagination:widow-orphan'><b><span">> $HOME/viewstate_report.head
echo "lang=EN-US style='font-size:12.0pt;font-family:Arial;mso-font-kerning:0pt'>Server<o:p></o:p></span></b></p>">> $HOME/viewstate_report.head
echo "</td>">> $HOME/viewstate_report.head
echo "</tr>">> $HOME/viewstate_report.head


############### Generate the Tail of mail content ####################################################################

echo "</table>">> $HOME/viewstate_report.tail
echo "">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US">> $HOME/viewstate_report.tail
echo "style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></p>">> $HOME/viewstate_report.tail
echo "">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal style='margin-top:3.1pt;margin-right:0cm;margin-bottom:3.1pt;">> $HOME/viewstate_report.tail
echo "margin-left:0cm;mso-para-margin-top:.2gd;mso-para-margin-right:0cm;mso-para-margin-bottom:">> $HOME/viewstate_report.tail
echo ".2gd;mso-para-margin-left:0cm;layout-grid-mode:char'><st1:PersonName><b">> $HOME/viewstate_report.tail
echo " style='mso-bidi-font-weight:normal'><i style='mso-bidi-font-style:normal'><span">> $HOME/viewstate_report.tail
echo " lang=EN-US style='font-family:Arial;color:blue;mso-no-proof:yes'></span></i></b></st1:PersonName><b">> $HOME/viewstate_report.tail
echo "style='mso-bidi-font-weight:normal'><i style='mso-bidi-font-style:normal'><span">> $HOME/viewstate_report.tail
echo "lang=EN-US style='font-family:Arial;color:blue;mso-no-proof:yes'><o:p></o:p></span></i></b></p>">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal style='margin-top:3.1pt;margin-right:0cm;margin-bottom:3.1pt;">> $HOME/viewstate_report.tail
echo "margin-left:0cm;mso-para-margin-top:.2gd;mso-para-margin-right:0cm;mso-para-margin-bottom:">> $HOME/viewstate_report.tail
echo ".2gd;mso-para-margin-left:0cm;layout-grid-mode:char'><b style='mso-bidi-font-weight:">> $HOME/viewstate_report.tail
echo "normal'><i style='mso-bidi-font-style:normal'><span lang=EN-US">> $HOME/viewstate_report.tail
echo "style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-no-proof:yes'>GDNT">> $HOME/viewstate_report.tail
echo "IT/SDE<o:p></o:p></span></i></b></p>">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal style='margin-top:3.1pt;margin-right:0cm;margin-bottom:3.1pt;">> $HOME/viewstate_report.tail
echo "margin-left:0cm;mso-para-margin-top:.2gd;mso-para-margin-right:0cm;mso-para-margin-bottom:">> $HOME/viewstate_report.tail
echo ".2gd;mso-para-margin-left:0cm;layout-grid-mode:char'><b style='mso-bidi-font-weight:">> $HOME/viewstate_report.tail
echo "normal'><i style='mso-bidi-font-style:normal'><span lang=EN-US">> $HOME/viewstate_report.tail
echo "style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-no-proof:yes'>ESN: 554">> $HOME/viewstate_report.tail
echo "4357 (working hour)<o:p></o:p></span></i></b></p>">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal style='margin-top:3.1pt;margin-right:0cm;margin-bottom:3.1pt;">> $HOME/viewstate_report.tail
echo echo "margin-left:0cm;mso-para-margin-top:.2gd;mso-para-margin-right:0cm;mso-para-margin-bottom:">> $HOME/viewstate_report.tail
echo ".2gd;mso-para-margin-left:0cm;layout-grid-mode:char'><b style='mso-bidi-font-weight:">> $HOME/viewstate_report.tail
echo "normal'><i style='mso-bidi-font-style:normal'><span lang=EN-US">> $HOME/viewstate_report.tail
echo "style='mso-bidi-font-size:10.5pt;font-family:Arial;mso-no-proof:yes'>     554">> $HOME/viewstate_report.tail
echo "8068 (7x24h)<o:p></o:p></span></i></b></p>">> $HOME/viewstate_report.tail
echo "<p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p>">> $HOME/viewstate_report.tail
echo "</div>">> $HOME/viewstate_report.tail
echo "</body></html>">> $HOME/viewstate_report.tail

cat  $HOME/viewstate_report.head  $HOME/viewstate_report.content  $HOME/viewstate_report.tail>> $HOME/viewstate_report

############### Send Mail to Administrator ##############################################################################

echo "Collect finished, begin to send mail!"

(
echo "From:<ClearCaseAdmin@gdnt.com.cn>"
echo "To:<$MAILLIST>"
#echo "Cc:<""$CC_LIST"">"
echo "Subject: MG Views Statistic"
echo "MIME-Version: 1.0"
echo "X-Mailer: Internet Mail Service (5.5.2653.19)"
echo "Content-Type: multipart/mixed;"
echo '        boundary="--PAA08673.1018277622_000/abc.yourcompany.com"'
echo ""
echo "This is a MIME-encapsulated message"
echo ""
echo "----PAA08673.1018277622_000/abc.yourcompany.com"
echo "Content-Type: multipart/alternative;"
echo '        boundary="--PAA08673.1018277622_001/abc.yourcompany.com"'
echo ""
echo "----PAA08673.1018277622_001/abc.yourcompany.com"
echo "Content-Type: text/html;"
echo "  charset="gb2312""
echo ""
cat < $HOME/viewstate_report
)  | mail "$MAILLIST"


######## delete temporary file #################################################
rm  $HOME/viewstate_list 2>/dev/null
rm  $HOME/check_viewstate* 2>/dev/null
rm  $HOME/viewstate_report* 2>/dev/null
rm  $HOME/viewstate_tmp_sort 2>/dev/null
