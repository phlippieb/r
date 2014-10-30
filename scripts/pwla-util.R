# calculates, for each sample of a given simulation, the following:
# 	- slope1
# 	- slope2
# 	- breakpoint x
# 	- breakpoint y
# 	- fitness
# param alg: the algorithm
# param pop: the  population size
# param fun: the problem function
# param dim: the number of dimensions
# returns: 	a list containing vectors with each of the above.
# 			list component names:
#				- slope1
#				- slope2
#				- breakpoint.x
#				- breakpoint.y
#				- fitness
measures.persim.persample <- function (algorithm, population, problem, dimensions) {
	sl1 <- c();
	sl2 <- c();
	brx <- c();
	bry <- c();
	allfit <- c();

	datafile <- paste("rdata/", algorithm, ".", population, ".", problem, ".", dimensions, sep='');
	div <- read.table (paste(datafile, ".div", sep=''), quote="\"");
	fit <- read.table (paste(datafile, ".fit", sep=''), quote="\"");

	allfit <- c(allfit,fit[length(fit[,1]), ]);

	for ( i in 1:( length(div[1,]) ) ) {
		ll <- length(div[,i]);
		bb <- pwla( div[,i] );
		sl1 <- c(sl1, pwla.slope1(bb));
		sl2 <- c(sl2, pwla.slope2(bb));
		brx <- c(brx, pwla.breakpt(bb)[1]);
		bry <- c(bry, pwla.breakpt(bb)[2]);
	}

	returnList <- list("slope1"=sl1, "slope2"=sl2, "breakpoints.x"=brx, "breakpoints.y"=bry, "fitness"=allfit);
	return (returnList);
}

# util function to calculate the mean and deviation of the
# left slope of a given simulation.
measures.sl1.stats.persim <- function (algorithm, population, problem, dimensions) {
	sl1 <- c();
	datafile <- paste("rdata/", algorithm, ".", population, ".", problem, ".", dimensions, sep='');
	div <- read.table (paste(datafile, ".div", sep=''), quote="\"");
	for ( i in 1:( length(div[1,]) ) ) {
		bb <- pwla( div[,i] );
		sl1 <- c(sl1, pwla.slope1(bb));
	}
	returnList <- list("mean"=mean(sl1), "sd"=var(sl1));
	return (returnList);
}

#
#	This one is used to generate text data for Prof Engelbrecht's Mann-Whitney-U scripts.
#	The requirement is that one file is generated for each pair of algorithms for a specific function.
#	(At this point, only one population size and dimensionality are being taken into account)
#	Each file must contain two tab-separated columns; the first contains the left-slope values and
#	the second contains the algorithm labels.
#
#
#
generate.Mann.Whitney.U.all <- function() {

	#functions <- c("ackley", "elliptic", "rastrigin", 
	#				"rosenbrock", "schwefel1_2", "alpine", 
	#				 "eggholder", 
	#				"goldsteinprice", "griewank", "levy", 
	#				"michalewicz", "quadric", "quartic",
	#				"salomon", "schwefel2_22","schwefel2_26",
	#				"sixhump", "spherical", "step", "zakharov");
	functions <- c("schwefel1_2");

	algorithms <- c("gbest", "lbest", "vn", "spso", "gcstar", "gcring", "gcvn", "bb", "bbe");

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms)-1)) {
			for (a2 in (a1+1):length(algorithms)) {
				count <- count + 1;
			}
		}
	}

	print(paste("Total runs required: ", count));

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms)-1)) {
			for (a2 in (a1+1):length(algorithms)) {
				print(paste(count, " doing ", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".txt", sep=""));
				count <- count + 1;
				alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".25.div", sep=''), quote="\"");
				alg2.data <- read.table (paste("rdata/", algorithms[a2], ".25.", functions[f], ".25.div", sep=''), quote="\"");
				generate.Mann.Whitney.U(alg1.data, algorithms[a1], alg2.data, algorithms[a2], functions[f]);
			}
		}
	}
}

generate.Mann.Whitney.U <- function(alg1.data, alg1.name, alg2.data, alg2.name, fun.name) {
	#source("rscripts/pwla-util.R");
	result.df <- data.frame ( sl1=rep(NA, 60), lab=rep("", 60), stringsAsFactors=FALSE);
	for(i in 1:30) {
		result.df[i,] <- c(pwla.slope1(pwla(alg1.data[,i])), alg1.name);
	}
	for(i in 1:30) {
		result.df[i+30,] <- c(pwla.slope1(pwla(alg2.data[,i])), alg2.name);
	}
	(result.df);
	write.table(	result.df,
					paste("mwu/", paste(alg1.name, alg2.name, fun.name, "txt", sep="."), sep=""),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" ");
}
