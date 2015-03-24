for FILE1 in $(ls *.txt)
do
	cat $FILE1 >$FILE1.div.rdata
done
