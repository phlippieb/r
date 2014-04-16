source("scripts/pearson.R");
#
#
# scripts for automation of
# processing of many simulations


# first, some preliminary collections for easy use of below functions.
# note that functions can be called with any parameters;
# the below are for convenience and re-use.
algs <- c(	
			"gbest",
			"lbest",
			"vn",
			"gbestgc",
			"lbestgc",
			"vngc",
			"spso",
			"bb",
			"bba"
		  );

pops <- c(10);

funs <- c(	
			"ackley",
			"alpine",
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
			"weierstrass",
			"zakharov"
		  );

dims <- c(3, 5, 10, 25, 50);

#
#
#
# calculate and save correlation values for each simulation combination
rr.all <- function(algs, pops, funs, dims, debug=FALSE) {

	# the results will be stored in this list
	returnlist <- list("sim"=c(), "rr"=c());
	# the sub-results will be stored in these collections
	sims <- c();
	rrs  <- c();

	# for each sim combination:
	#   calculate the correlation
	#   store the name and result in returnlist
	for (alg in algs) {
		for (pop in pops) {
			for (fun in funs) {
				rr <- rr.persample(alg, pop, fun, dims, debug);
				rrs <- c(rrs, rr);
				sims <- c(sims, paste(alg,pop,fun,sep="."));
			}
		}
	}

	returnlist$sim <- sims;
	returnlist$rr  <- rrs;

	return (returnlist);
}