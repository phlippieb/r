source("scripts/pwla-util.R");

#
#
# This file is used for calculating correlations between DRoC measures
# across different function dimensions.
#
# For each calculation, only results from simulations with different 
# dimensions are considered.
#
# Two functions are provided - one to work with full data sets (all samples),
# and another to work with average data sets.


#
#
# calculates a pearson correlation coefficient
# -- for each sample of --
# a given (single) algorithm, population size, and function,
# and each function dimensionality given.
#
# param alg:	the simulation algorithm
# param pop:	the simulation population size
# param fun:	the simulation function
# param dims:	a collection of all simulation dimensions
#
# returns: the pearson correlation coefficient for all requested samples points
sl1 <- c();
dm1 <- c();
rr.persample <- function(alg, pop, fun, dims, debug=FALSE) {
	# calculate all sl1 values
	sl1 <- c();
	dm1 <- c();
	if(debug) { print(paste("calculating slopes for",alg,pop,fun,sep=" "));}
	for (dim in dims) {
		sl1 <- c(sl1, measures.sl1.persample(alg, pop, fun, dim, debug))
		for(s in 1:getNumberOfSamples(alg,pop,fun,dim)) {
			dm1 <- c(dm1, dim);
		}
	}

	# calculate r for all sl1 values
	# 	x and y are the data to use
	# 	use is the missing data handling scheme:
	# 		all.obs:				treat missing values as an error
	# 		complete.obs:			listwise deletion
	# 		pairwise.complete.obs:	pairwise deletion
	#	method is the type of correlation. valid types:
	#		pearson
	#		spearman
	#		kendall
	if(debug) {	print(paste("calculating coefficient")); }
	r <- cor(sl1, dm1, use="all.obs", method="pearson");

	return (r);
}

getNumberOfSamples <- function(alg, pop, fun, dim) {
	datafile <- paste("rdata/", alg, ".", pop, ".", fun, ".", dim, sep='');
	div <- read.table(paste(datafile, ".div", sep=''), quote="\"");
	return (length(div[1,]));
}