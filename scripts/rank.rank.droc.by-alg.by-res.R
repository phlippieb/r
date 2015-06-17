# name explained:
# rankOf(rankOf(alg pairs) for each resolution)

# quick note:
# http://stackoverflow.com/questions/3968281/git-pushing-amended-commits
# (om met onvolledige commits te werk)
rank.comparisons.byres <- function() {

	resolutions <- 1:2

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
					rankresult = unlist(rank.file(filename))[1];
					
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

		allResults <- rbind(allResults, thisRow);
		allResults.rowNames <- c(allResults.rowNames, r);
	}

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

	return (allResults)

	# rank the ranks!

	#finalResults <- c();
#
#	#for (r in 1:(length(resolutions)-1)) {
#	#	print("trying to rank two rows...")
#	#	print("these are the two rows:")
#	#	print(allResults[r])
#	#	print(allResults[r+1])
#	#	x <- rank(c(allResults[r], allResults[r+1]), c(r, r+1));
#	#	print("done! getting results...")
#	#	x <- unlist(unname(x[1]));
#	#	print("done! pasting results together...")
#	#	finalResults <- c(finalResults, x);
#	#}
#
#	#print("all done! returning results.")
	#return (finalResults);

}
