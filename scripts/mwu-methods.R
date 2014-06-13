
# basic Mann-Whitney U calculation on two groups of data.
# MWU is a comparison of 2 sets of data to determine whether the sets are statistically significantly different from one another.
#
# param set1:	the 1st set in the comparison
#
# param set2:	the 2nd set in the comparison
#
# return:		a number summarising the result:
#				-1 or 1: 	one set is significantly larger than the other
#				0:			the sets are not significantly different
mwu.pair <-  function(set1, set2) {
	# get data in right format to use Prof E's rankF function:
	alldata <- c(set1, set2);
	allnames <- c();
	for (i in 1:length(set1)) {
		allnames <- c(allnames, "set1");
	}
	for (i in 1:length(set2)) {
		allnames <- c(allnames, "set2");
	}
	data <- c(alldata)
	data 
	group <- factor(allnames)
	group
	rankList <- rankF(data,group,0.05,FALSE)
	return (rankList)

}


# calculates MWU comparisons on all consecutive pairs of the data.
# eg, if data contains {set1, set2, set3}, then this will effectively do mwu.pair(set1,set2) and mwu.pair(set2,set3).
#
# param data:	all datasets to compare.
#				expected in unnamed, unlisted matrices with each set comprising a row.
#
# return:		a (c)ollection of one mwu result for each consecutive pair.
mwu.consecutivePairs <- function(data) {
	allranks <- c();
	# store this just to be safe, for now
	data.rownames <- rownames(data);
	for (i in 2:(length(data[,1]))) {
		allranks <- c(	allranks, 
						mwu.pair(	unlist(data[i-1,]), 
									unlist(data[i,])
								)	
					);
	}
	return (allranks);
}


# calculates MWU comparisons on pairs of sets from the data only at the given x-values.
# eg:	if data contains {set1, set2, set3, set4} and at contains (1,2,4),
#		then pairwise comparisons between {set1,set2} and {set2,set4} will be done.
#
# param data:	all datasets to select pairs from.
#				format: unnamed, unlisted dataframes with each set comprising a column.
#
# return:		a (c)ollection of one mwu result for each consecutive pair.
mwu.consecutivePairs.at <- function(data, at) {
	data.selection <- c();
	data.rownames <- c();
	for (a in at) {
		data.selection <- c(data.selection, unlist(data[at,]));
		data.rownames <- c(data.rownames, a);
	}
	data.selection <- matrix(data.selection, nrow=(length(at)), ncol=(length(data[(at[1]),])));
	rownames(data.selection) <- data.rownames;
	#return (data.selection);
	return (mwu.consecutivePairs(data.selection));
}

# same as mwu.consecutivePairs.at(...), but also prints the results.
print.mwu.consecutivePairs.at <- function(data, at) {

}

# same as mwu.consecutivePairs.at(...), but also save the results to the specified filename.
#
# param	filename:	the name of the file to save results to.
save.mwu.consecutivePairs.at <- function(data, at, filename) {

}