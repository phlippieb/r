# name explained:
# rankOf(rankOf(alg pairs) for each resolution)

# quick note:
# http://stackoverflow.com/questions/3968281/git-pushing-amended-commits
# (om met onvolledige commits te werk)
rank.comparisons.byres <- function() {

	resolutions <- 1:500

	functions <- c(
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
	)

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

	algorithmpairs <- c();
	for (i in  1:length(algorithms)-1) {
		for (j in 1:length(algorithms)) {
			if (j > i+1) {
				algorithmpairs <- c(
				algorithmpairs,
				paste(algorithms[i+1], algorithms[j], sep="."));
			}
		}
	}

	# rank results will be stored in this:
	ranks <- c();
	ranks.rowNames <- c();

	cat("getting ranks among algorithms...\n");

	# for each resolution:
	for (r in 1:length(resolutions)) {
		# print some progress text
		cat("resolution = ", r, "\n");
		thisRow <- c();
		# for each algorithm pair:
		for (aa in 2:length(algorithmpairs)) {
			# for each function:
			for (f in 1:length(functions)) {
				# get the file with the data
				# (paired up by algorithm)
				filename = paste(
					"./drocpairs/alg/",
					algorithmpairs[aa], ".",
					functions[f], ".",
					resolutions[r], "r.",
					"2000i.txt",
					sep=""
				);
				if (file.exists(filename)) {
					# calculate rank on algorithm pair for this function and resolution
					rankresult = unlist(unname(rank.file(filename)))[1];
					# append to results for this resolution
					thisRow <- c(thisRow, rankresult);
				} else {
					# if file is not found, stop executing with an error message
					stop(paste("\rFILE NOT FOUND:  ", filename, "\n", sep=""));
				}
			}
		}

		# after all mwu ranks are added to results for this row,
		# add the row to the final results for all rows

		ranks <- rbind(ranks, thisRow);
		ranks.rowNames <- c(ranks.rowNames, r);
	}

	# name rows in ranks to reflect the resolutions used
	# NOTE: we don't return this; mostly available for checking results
	#		before next section.
	rownames(ranks) <- ranks.rowNames;

	# name cols in ranks to reflect the algorithms and functions used
	ranks.colNames <- c();
	for (aa in 2:length(algorithmpairs)) {
		for (f in 1:length(functions)) {
			ranks.colNames <- c(ranks.colNames, paste(algorithmpairs[aa], functions[f], sep="."));
		}
	}
	colnames(ranks) <- ranks.colNames;

	# rank the ranks!
	cat("done. ranking the ranks...\n")

	finalranks <- c();
	finalranks.names <- c();

	for (r in 1:(length(resolutions)-1)) {
		cat("resolutions =", r, "and", r+1, "\n");
		data <- c(unname(ranks[r,]), unname(ranks[r+1,]))
		classes <- c(r, r+1);
		x <- rank(data, classes)
		x <- unlist(unname(x[1]));
		finalranks <- c(finalranks, x);
		finalranks.names <- c(finalranks.names, paste(r, "-", r+1, sep=""));
	}
	names(finalranks) <- finalranks.names;
	cat("done\n")
	return (finalranks);

}
