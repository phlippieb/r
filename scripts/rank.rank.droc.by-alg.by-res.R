# name explained:
# rankOf(rankOf(alg pairs) for each resolution)

# quick note:
# http://stackoverflow.com/questions/3968281/git-pushing-amended-commits
# (om met onvolledige commits te werk)
rank.comparisons.byres <- function() {
	resolutions <- 1:10

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

	#result.m <- matrix(
	#	nrow=length(algorithmpairs),
	#	ncol=length(resolutions)
	#);

	# final results will be stored in this:
	allResults <- c();
	allResults.rowNames <- c();

	# for each resolution:
	for (r in 1:length(resolutions)) {
		print(paste("RES = ", resolutions[r], sep=""));
		thisRow <- c();

		# for each algorithm pair:
		for (aa in 2:length(algorithmpairs)) {

			print(paste("AA = ", algorithmpairs[aa], sep=""));

			# for each function:
			for (f in 1:length(functions)) {

				print(paste("F = ", functions[f], sep=""));

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
					rankresult = unlist(rank.file(filename))[1];

					print(paste("RESULT = ", rankresult, sep=""));

					# append to results for this resolution
					thisRow <- c(thisRow, rankresult);

					print("THISROW = "); print (thisRow);
				} else {
					# if file is not found, stop executing with an error message
					stop(paste("\rFILE NOT FOUND:  ", filename, "\n", sep=""));
				}
			}
		}

		# after all mwu ranks are added to results for this row,
		# add the row to the final results for all rows

		allResults <- rbind(allResults, thisRow);
		allResults.rowNames <- c(allResults.rowNames, r);
	}

	print(allResults);

	# name rows in allResults to reflect the resolutions used
	rownames(allResults) <- allResults.rowNames;

	# name cols in allResults to reflect the algorithms and functions used
	allResults.colNames <- c();
	for (aa in 2:length(algorithmpairs)) {
		for (f in 1:length(functions)) {
			allResults.colNames <- c(allResults.colNames, paste(algorithmpairs[aa], functions[f], sep="."));
		}
	}
	colnames(allResults) <- allResults.colNames;

	return (allResults);

	# TODO: rank the results!

}
