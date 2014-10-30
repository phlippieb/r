for FILE1 in $(ls *.txt)
do
	./print-first-30.sh $FILE1 >$FILE1.fit.rdata
	./print-last-30.sh  $FILE1 >$FILE1.div.rdata
	# remove fitness: (we're not using it)
	rm $FILE1.fit.rdata
done
