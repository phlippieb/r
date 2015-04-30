# Same as generate.mann.whitney.u.all (pwla-util.R),
# but with added functionality for generating sl1 data at different data resolutions.
	# I.e.: r=1 means taking every data point into consideration,
	# r=2 means taking only every second point into consideration,
	# etc.
# The resolutions list is used to define the resolutions to use.
# The parameterised version of pwla from pwla.R. is used to impose resolutions.

# USAGE:
# 1. run all simulations with resolution = 1 and process data to use in R
# 2. use pwla.partial.xxxx to create droc data for each simulation (incl resolutions)
# 3. use partial-data-to-pairs to create a file for each pair of functions, to be used in next step
# 4. use ? from ranks.R to calculate MWU results on pairs

droc.all.resolutions <- function()  {
	
	# Check if a directory called drocdata already exists.
	# If not, create it
	if(!file.exists("drocdata"))
		dir.create("drocdata");
	
	library(doParallel);
	numCores <- as.numeric(readline("How many cores to use? "));
	registerDoParallel(cores=numCores);

	# initialize total runs needed
	totalRuns = 0;
	
	# Define the functions that we want to use
	# 1: the variable-dimension functions
	functions1 <- c(
		"ackley",
		"alpine",
		"eggholder",
		"elliptic",
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
		"spherical",
		"step",
		"zakharov"
	);
	d1 <- 25; # the dimensions of the functions (currently fixed at 25)

	# 2: the functions with dimensions inherently fixed at 2
	functions2 <- c("goldsteinprice", "sixhump");
	d2 <- 2; # [un]comment to toggle

	# The algorithms included in the study:
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

	# The resolutions to compare
	# This is used as an alternative to re-running each simulation at several different resolutions (i.e. how many of the data points to take into account).
	# Instead, a resolution of 1 is used to produce data, of which data is selected at lower resolutions by using the parameterised version of pwla(d, resolution).
	resolutions <- 100:150;

	# We still need to limit  this, so.... we could actually merge this file with -iterations? Not sure what to call it.
	iterations <- c(
		2000
	);
	

	totalRuns = totalRuns + droc.all.resolutions.getTotalRuns(algorithms, functions1, iterations, resolutions);
	totalRuns = totalRuns + droc.all.resolutions.getTotalRuns(algorithms, functions2, iterations, resolutions);

	droc.all.resolutions.run(algorithms, functions1, d1, iterations, resolutions, totalRuns);
	droc.all.resolutions.run(algorithms, functions2, d2, iterations, resolutions, totalRuns);

	cat ("\n");
}

# Count how many runs are required to calculate all DRoC values
droc.all.resolutions.getTotalRuns <- function (algorithms, functions, iterations, resolutions) {
	count <- 0;
	for (f in 1:length(functions))
		for (a in 1:(length(algorithms)))
			for (r in 1:length(resolutions))
				for (i in 1:length(iterations))
					#if (!file.exists(paste(	"drocdata/", # Don't re-do anything
					#		algorithms[a], ".", 
					#		functions[f], ".", 
					#		resolutions[r], "r.", 
					#		iterations[i], "i",
					#		".droc.txt", sep="")))
						count <- count + 1;

	totalRuns <- count;
	return (totalRuns);
}

droc.all.resolutions.run <- function(algorithms, functions, d, iterations, resolutions, totalRuns) {

	# MAIN LOOP:
	# Start looping through every simulation/resolutions
	a <- 1;
	count <- 1;
	for (r in 1:length(resolutions)) {
		for (i in 1:length(iterations)) {
			for (f in 1:length(functions)) {
				for (a in 1:(length(algorithms))) {
					#if (!file.exists(paste("drocdata/", algorithms[a], ".", functions[f], ".", resolutions[r], "r.", iterations[i], "i", ".droc.txt", sep=""))) { # Don't re-do anything
						cat(paste("\r[", count, "/", totalRuns, "] ", algorithms[a], ".", functions[f], ".", resolutions[r], "r.", iterations[i], "i.droc.txt", sep="")); # progress text
						count <- count + 1; # progress tracking
						alg.data <- read.table (paste("rdata/", algorithms[a], ".25.", functions[f], ".", d, ".div", sep=''), quote="\""); # get data
						droc.resolutions(alg.data, algorithms[a], functions[f], resolutions[r], iterations[i]); # process data and write results
					#}
				}
			}
		}
	}
}



# Calculates the DRoC for the specified simulation (specification includes resolution)
# and writes results to a file.
droc.resolutions <- function (alg1.data, alg1.name, fun.name, resolution, iterations) {
	result.multicore <- foreach (i = 1:30) %dopar% {
		# progress (convince myself that the script is still alive)
			cat(" ");
		c(pwla.slope1(pwla.subset(alg1.data[,i], iterations, resolution)), alg1.name)
	}
	#cat("\n");
	result.multicore <- matrix(unname(unlist(result.multicore)), ncol=2, byrow=TRUE);
	write.table(
					result.multicore,
					paste(
						"drocdata/", 
						paste(
							alg1.name, ".",
							fun.name,  ".",
							resolution, "r.",
							iterations,  "i.",
							"droc.txt",
							sep=""
						), 
						sep=""
					),
					row.names=FALSE,
					col.names=FALSE,
					quote=FALSE,
					sep=" "
				);
}
