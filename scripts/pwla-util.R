source("scripts/pwla.R");

# calculates the left slope value (DRoC) for each sample
# of the given simulation setup, as defined by the parameters:
#
# param alg: the simulation algorithm
# param pop: the simulation population size
# param fun: the simulation function
# param dim: the simulation function dimensions
#
# retuns: a collection of all the DRoC values
measures.sl1.persample <- function (alg, pop, fun, dim, debug=FALSE) {
	if(debug) {	print(paste("doing",alg,pop,fun,dim, sep=" "));	}
	sl1 <- c();
	datafile <- paste("rdata/", alg, ".", pop, ".", fun, ".", dim, sep='');
	div <- read.table(paste(datafile, ".div", sep=''), quote="\"");
	for (i in 1:( length(div[1,]) )) {
		if(debug) {	print(paste("   doing sample", i, sep=" "));	}
		bb <- pwla( div[,i] );
		sl1 <- c(sl1, pwla.slope1(bb));
	}
	return (sl1);
}

measures.sl1.avg <- function (alg, pop, fun, dim) {
	allsamples <- measures.sl1.persample(alg, pop, fun, dim);
	return (mean(allsamples));
}