# util function to calculate the mean and deviation of the
# left slope of a given simulation.
measures.sl2.stats.persim <- function (algorithm, population, problem, dimensions) {
	sl2 <- c();
	datafile <- paste("rdata/", algorithm, ".", population, ".", problem, ".", dimensions, sep='');
	div <- read.table (paste(datafile, ".div", sep=''), quote="\"");
	for ( i in 1:( length(div[1,]) ) ) {
		bb <- pwla( div[,i] );
		sl2 <- c(sl2, pwla.slope2(bb));
	}
	returnList <- list("mean"=mean(sl2), "sd"=var(sl2));
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
generate.Mann.Whitney.U.all.2 <- function() {

	print("NB:");
	print("a directory called ``mwu'' must exist here for this function to work!");
	Sys.sleep(3);

	functions <- c("ackley", "elliptic", "rastrigin", 
					"rosenbrock", "schwefel1_2", "alpine", 
					 "eggholder", 
					"goldsteinprice", "griewank", "levy", 
					"michalewicz", "quadric", "quartic",
					"salomon", "schwefel2_22","schwefel2_26",
					#"sixhump", 
					"spherical", "step", "zakharov");

	algorithms <- c("gbest", "lbest", "vn", "spso", "gbestgc", "lbestgc", "vngc", "bb", "bba");

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms)-1)) {
			for (a2 in (a1+1):length(algorithms)) {
				count <- count + 1;
			}
		}
	}

	totalRuns <- count;
	print(paste("Total runs required: ", totalRuns));

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms)-1)) {
			for (a2 in (a1+1):length(algorithms)) {
				print(paste("[", count, "/", totalRuns, "]  Doing ", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".txt", sep=""));
				count <- count + 1;
				alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".25.div", sep=''), quote="\"");
				alg2.data <- read.table (paste("rdata/", algorithms[a2], ".25.", functions[f], ".25.div", sep=''), quote="\"");
				generate.Mann.Whitney.U.2(alg1.data, algorithms[a1], alg2.data, algorithms[a2], functions[f]);
			}
		}
	}
}

generate.Mann.Whitney.U.2 <- function(alg1.data, alg1.name, alg2.data, alg2.name, fun.name) {
	result.df <- data.frame ( sl1=rep(NA, 60), lab=rep("", 60), stringsAsFactors=FALSE);
	for(i in 1:30) {
		result.df[i,] <- c(pwla.slope2(pwla(alg1.data[,i])), alg1.name);
	}
	for(i in 1:30) {
		result.df[i+30,] <- c(pwla.slope2(pwla(alg2.data[,i])), alg2.name);
	}
	(result.df);
	write.table(	result.df,
					paste("mwu/", paste(alg1.name, alg2.name, fun.name, "txt", sep="."), sep=""),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" ");
}

generate.partial.MWU.all.2 <- function() {
	print("NB:");
	print("a directory called ``mwu-partial'' must exist here for this function to work!");
	Sys.sleep(3);

	functions <- c("ackley", "elliptic", "rastrigin", "rosenbrock", "schwefel1_2", "alpine", "eggholder", "griewank", "levy", "michalewicz", "quadric", "quartic", "salomon", "schwefel2_22","schwefel2_26", "spherical", "step", "zakharov");

	algorithms <- c("gbest", "lbest", "vn", "spso", "gbestgc", "lbestgc", "vngc", "bb", "bba");

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms))) {
			count <- count + 1;
		}
	}

	totalRuns <- count;
	print(paste("Total runs required: ", totalRuns));

	a1 <- 1;
	count <- 1;

	for (f in 1:length(functions)) {
		for (a1 in 1:(length(algorithms))) {
			print(paste("[", count, "/", totalRuns, "]  Doing ", algorithms[a1], ".", functions[f], ".partial.txt", sep=""));
			count <- count + 1;
			alg1.data <- read.table (paste("rdata/", algorithms[a1], ".25.", functions[f], ".25.div", sep=''), quote="\"");
			generate.partial.MWU.2(alg1.data, algorithms[a1], functions[f]);
		}
	}
}

generate.partial.MWU.2 <- function (alg1.data, alg1.name, fun.name) {
	result.df <- data.frame ( sl1=rep(NA, 30), lab=rep("", 30), stringsAsFactors=FALSE);
	for (i in 1:30) {
		result.df[i,] <- c(pwla.slope2(pwla(alg1.data[,i])), alg1.name)
	}
	(result.df);
	write.table(	result.df,
					paste(
						"mwu-partial/", 
						paste(
							alg1.name, 
							fun.name, 
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