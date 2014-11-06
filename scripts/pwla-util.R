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
	source("rscripts/pwla-util.R");
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



# Same as the non-withiterations version, but with added functionality for generating sl1 data for different subsets of data.
# The iterations list is used to get different DRoC values using the subset functions.

generate.MWU.all.withiterations <- function() {

	functions <- c(
					"ackley",
					"alpine",
					"eggholder",
					"elliptic",
					#"goldsteinprice",
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
					#"sixhump",
					"spherical",
					"step",
					"zakharov"
				);

	algorithms <- c(
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

	iterations <- c(
					500, 
					1000, 
					5000, 
					10000
				);

	a1 <- 1;	
	count <- 1;

	for (f in 1:length(functions))
		for (a1 in 1:(length(algorithms)-1))
			for (a2 in (a1+1):length(algorithms))
				for (i in iterations)
					if (! file.exists(paste("mwu/", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".", i, ".txt", sep="")))
					count <- count + 1;

	print(paste("Total runs required: ", count));

	a1 <- 1;
	count <- 1;

	for (i in iterations) {
		for (f in 1:length(functions)) {
			for (a1 in 1:(length(algorithms)-1)) {
				for (a2 in (a1+1):length(algorithms)) {
					if (! file.exists(paste("mwu/", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".", i, ".txt", sep=""))) {
						print(paste(count, " doing ", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".", i, ".txt", sep=""));
						count <- count + 1;
						alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".25.div", sep=''), quote="\"");
						alg2.data <- read.table (paste("rdata/", algorithms[a2], ".25.", functions[f], ".25.div", sep=''), quote="\"");
						generate.MWU.withiterations(alg1.data, algorithms[a1], alg2.data, algorithms[a2], functions[f], i);
					}
				}
			}
		}
	}
}

generate.MWU.withiterations <- function(alg1.data, alg1.name, alg2.data, alg2.name, fun.name, iteration) {
	result.df <- data.frame ( sl1=rep(NA, 60), lab=rep("", 60), stringsAsFactors=FALSE);
	for(sample in 1:30) {
		result.df[sample,] <- c(pwla.slope1(pwla.subset(alg1.data[,sample], iteration)), alg1.name);
	}
	for(sample in 1:30) {
		result.df[sample+30,] <- c(pwla.slope1(pwla.subset(alg2.data[,sample], iteration)), alg2.name);
	}
	(result.df);
	write.table(	result.df,
					paste("mwu/", paste(alg1.name, alg2.name, fun.name, iteration, "txt", sep="."), sep=""),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" ");
}


generate.partial.MWU.withiterations.all <- function() {
	
	# Check if a directory called mwu-partial already exists.
	# If not, create it
	if(!file.exists("mwu-partial"))
		dir.create("mwu-partial");
	

	# Define the functions that we want to use
	# NB: for now, I'm too lazy to create a separate way deal with fixed-dimension functions, so it has to be manually swapped out
	functions <- c(
					"ackley",
					"alpine",
					"eggholder",
					"elliptic",
					#"goldsteinprice",
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
					#"sixhump",
					"spherical",
					"step",
					"zakharov"
				);

	# Functions that have their dimensions fixed at 2
	# (This overrides the previous definition; commenting it out reverts to previous definition)
	#functions <- c("goldsteinprice", "sixhump");

	# The algorithms included in the study...
	algorithms <- c(
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

	# The iterations included in the study.
	# This is used as an alternative to re-running each simulation with several different values as the stopping condition i.t.o how many iterations to run.
	# Instead, the simulations are run for the maximum number of iterations needed as a stopping condition, and subsets of the data (up to different numbers of iterations) are used to calculated the DRoC on.
	iterations <- c(
					500, 
					1000, 
					5000, 
					10000
				);

	# In case parallel processing resources are needed (currently they're not)
	library(doParallel);
	registerDoParallel();

	# Count how many runs are required to calculate all DRoC values
	a1 <- 1;
	count <- 0;
	for (i in 1:length(iterations))
		for (f in 1:length(functions))
			for (a1 in 1:(length(algorithms)))
				if (!file.exists(paste(	"mwu-partial/", # Don't re-do anything
										algorithms[a1], 
										".",
										functions[f], 
										".",
										iterations[i],
										".partial.txt",
										sep="")))
					count <- count + 1;

	totalRuns <- count;
	print(paste("Total runs required: ", totalRuns));


	# MAIN LOOP:
	# Start looping through every simulation/iteration
	a1 <- 1;
	count <- 1;

	#ptime <- system.time({
		for (i in 1:length(iterations)) {
			for (f in 1:length(functions)) {
				for (a1 in 1:(length(algorithms))) {
				#foreach (a1 = 1:(length(algorithms))) %dopar% {
					if (!file.exists(paste("mwu-partial/", 					 algorithms[a1], ".", functions[f], ".", iterations[i], ".partial.txt", sep=""))) { # Don't re-do anything
						cat(paste("[", count, "/", totalRuns, "]  Doing ", algorithms[a1], ".", functions[f], ".", iterations[i], ".partial.txt", sep=""));

						count <- count + 1;
						alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".25.div", sep=''), quote="\""); # Read the data
						#alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".2.div", sep=''), quote="\""); # For functions with fixed 2 dimensions
						#generate.partial.MWU.withiterations.sequential(alg1.data, algorithms[a1], functions[f], iterations[i]); # Call this function to actually process the data
						generate.partial.MWU.withiterations.parallel(alg1.data, algorithms[a1], functions[f], iterations[i]);
						# Note: currently, the parallel version doesn't produce the correct output.
						# Fixing it might speed up processing considerably
					}
				}
			}
		}
	#})
	
	#print(ptime);
}


# Generates ``partial MWU data''
# What this actually means is that the function calculated the DRoC on the data given, and writes it to a file in a format that can be used by the MWU scripts.
# (A MWU comparison needs a pair of these resultant files concatenated together)
generate.partial.MWU.withiterations.sequential <- function (alg1.data, alg1.name, fun.name, iterations) {
	result.df <- data.frame ( sl1=rep(NA, 30), lab=rep("", 30), stringsAsFactors=FALSE);
	#ptime <- system.time({
		start.time <- proc.time();
		foreach (i = 1:30) %do% {
			cat(".");
			result.df[i,] <- c(pwla.slope2(pwla.subset(alg1.data[,i], iterations)), alg1.name)
		}
		elapsed.time <- proc.time() - start.time;
		elapsed.time <- elapsed.time[3];
		elapsed.time <- unname(elapsed.time);
		print(paste(" Done. Elapsed: ", round(elapsed.time, 0), ". ", sep=""));
	#});
	#print(ptime);
	#print(result.df);
	write.table(	result.df,
					paste(
						"mwu-partial/", 
						paste(
							alg1.name, 
							fun.name, 
							iterations,
							"partial",
							"txt", 
							sep="."
						), 
						sep=""
					),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" "
				);
}


# This function should do the same as its sequential version, but in parallel
# Currently, the output is wrong.
generate.partial.MWU.withiterations.parallel <- function (alg1.data, alg1.name, fun.name, iterations) {
	result.df <- data.frame ( sl1=rep(NA, 30), lab=rep("", 30), stringsAsFactors=FALSE);
	#ptime <- system.time({
		start.time <- proc.time();
		xx <- foreach (i = 1:30) %dopar% {
			cat(".");
			( c(pwla.slope2(pwla.subset(alg1.data[,i], iterations)), alg1.name) );
		}
		for (i in 1:30) {
			result.df[i,] <- xx[[i]];
		}
		elapsed.time <- proc.time() - start.time;
		elapsed.time <- elapsed.time[3];
		elapsed.time <- unname(elapsed.time);
		print(paste(" Done. Elapsed: ", round(elapsed.time, 0), "s", sep=""));
	#});
	#print(ptime);
	#print(result.df);
	write.table(	result.df,
					paste(
						"mwu-partial/", 
						paste(
							alg1.name, 
							fun.name, 
							iterations,
							"partial",
							"txt", 
							sep="."
						), 
						sep=""
					),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" "
				);
}
