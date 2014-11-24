#
#
# This file contains scripts for checking the sl1 and sl2 values obtained from simulations for correlations.
#
# At the tme of creation, all sl1 and sl2 values are in directories called sl1-partial and sl2-partial respectively.
#
#

# define the inputs:

allAlgorithms <-	c(
						"bb",
						"bba",
						"gbest",
						"gbestgc",
						"lbest",
						"lbestgc",
						"spso",
						"vn",
						"vngc"
					);

allFunctions <- 	c(
						"ackley",
						"alpine",
						"eggholder",
						"elliptic",
						"goldsteinprice",
						"griewank",
						"levy",
						"michalewicz",
						"quadric",
						"quartic",
						"rastrigin",
						"rosenbrock",
						"salomon",
						"schwefel1_2",
						"schwefel2_22",
						"schwefel2_26",
						"sixhump",
						"spherical",
						"step",
						"zakharov"
					);

allIterations <-	c(
						#500, 
						#1000,
						#5000, 
						#10000,
						2000
					);

allSimulations <- c();
for (a in allAlgorithms) {
	for (f in allFunctions) {
		for (i in allIterations) {
			thisSimulation <- paste(
									a, ".",
									f, ".",
									i,
									sep=""
								);
			allSimulations <- c(
									allSimulations,
									thisSimulation
								);
		}
	}
}

# derive the filenames of all inputs:
# (if file name structure changes, only change this)

allSl1FileNames <- list();
allSl2FileNames <- list();
for (s in allSimulations) {
	#sl1:
	thisFileName <- paste( "sl1-partial/", s, ".partial.txt", sep="" );
	allSl1FileNames[[s]] <- thisFileName;

	#sl2:
	thisFileName <- paste( "sl2-partial/", s, ".partial.txt", sep="" );
	allSl2FileNames[[s]] <- thisFileName;
}


# this function gets the data from a given filename
# (in case file structure changes, in which case I'll only need to change this)
correlate.getData <- function(filename) {
	data <- read.table(filename);
	return (data[,1])
}

#
# calculates correlation coefficients between sl1 and sl2 for all simulations
# takes method to use: either pearson, spearman or kendall
# returns results as (..?)

allCorrelations <- function(method) {
	results <- list();
	for (s in allSimulations) {
		sl1Data <- correlate.getData(allSl1FileNames[[s]]);
		sl2Data <- correlate.getData(allSl2FileNames[[s]]);
		result <- cor(sl1Data, sl2Data, method, use="all")
		results[[s]] <- result;
	}

	return (results);
}

#
# converts the data resulting from a call to allCorrelations() to a matrix
# data: the result of an allCorrelations call
# NB: the function only works on one iteration cap at a time. Edit the allIterations value before calling allCorrelations.
convertToMatrix <- function(data) {
	result <- matrix(data, nrows=length(allFunctions), byrow=TRUE);
	rownames(result) <- allFunctions;
	colnames(result) <- allAlgorithms;
	return (result);
}