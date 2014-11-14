
# basic Mann-Whitney U calculation on two groups of data.
# MWU is a comparison of 2 sets of data to determine whether the sets are statistically significantly different from one another.
#
# param set1:	the 1st set in the comparison
#
# param set2:	the 2nd set in the comparison
#
# return:		a number summarising the result:
#				-1 or 1: 	one set is significantly larger than the other
#				0:			the sets are not significantly different
mwu.pair <-  function(set1, set2) {
	# get data in right format to use Prof E's rankF function:
	alldata <- c(set1, set2);
	allnames <- c();
	for (i in 1:length(set1)) {
		allnames <- c(allnames, "set1");
	}
	for (i in 1:length(set2)) {
		allnames <- c(allnames, "set2");
	}
	data <- c(alldata);
	data 
	group <- factor(allnames);
	group
	rankList <- rankF(data,group,0.05,FALSE);
	return (rankList);

}


# calculates MWU comparisons on all consecutive pairs of the data.
# eg, if data contains {set1, set2, set3}, then this will effectively do mwu.pair(set1,set2) and mwu.pair(set2,set3).
#
# param data:	all datasets to compare.
#				expected in unnamed, unlisted matrices with each set comprising a row.
#
# return:		a (c)ollection of one mwu result for each consecutive pair.
mwu.consecutivePairs <- function(data) {
	data.rownames <- rownames(data);
	allranks.rownames <- c();
	allranks <- c();
	for (i in 2:(length(data[,1]))) {
		allranks <- c(	allranks, 
						mwu.pair(unlist(data[i-1,]), unlist(data[i,]))$set1	
					);
		allranks.rownames <- c(	allranks.rownames,
								paste(	data.rownames[i-1],
										"-",
										data.rownames[i],
										sep=""
								)
							);
	}
	allranks <- matrix(allranks, ncol=1);
	rownames(allranks) <- allranks.rownames;
	return (allranks);
}


# calculates MWU comparisons on pairs of sets from the data only at the given x-values.
# eg:	if data contains {set1, set2, set3, set4} and at contains (1,2,4),
#		then pairwise comparisons between {set1,set2} and {set2,set4} will be done.
#
# param data:	all datasets to select pairs from.
#				format: unnamed, unlisted dataframes with each set comprising a column.
#
# return:		a (c)ollection of one mwu result for each consecutive pair.
mwu.consecutivePairs.at <- function(data, at) {
   # select only the rows given in 'at':
   data.selection <- data[at,];
   # unlist and unname the entire selection, turning it into a big array of data:
   data.selection <- unlist(unname(data.selection));
   # re-organize all data into a matrix:
   #  number of rows is the number of entries in 'at' - makes sense, as that is the exact number of rows selected
   #  number of columns is the length of one row of the original data
	data.selection <- matrix(data.selection, nrow=(length(at)), ncol=(length(data[(at[1]),])));
   # the name of each row is obtained from 'at':
	rownames(data.selection) <- at;
	#return (data.selection);
	return (mwu.consecutivePairs(data.selection));
}

# same as mwu.consecutivePairs.at(...), but also prints the results.
print.mwu.consecutivePairs.at <- function(data, at) {

}

# same as mwu.consecutivePairs.at(...), but also save the results to the specified filename.
#
# param	filename:	the name of the file to save results to.
save.mwu.consecutivePairs.at <- function(data, at, filename) {

}

rankAll <- function() {

   # Function is identical to the one on the sl2 branch, with only iterations added.

   # For now, let's change this manually between each execution.
   iterations.feed <-   c(
                           "500",
                           "1000",
                           "2000",
                           "5000",
                           "10000"
                        );

   iterations <- c();
   # Note: no idea why it needs to be 2:, but it does
   for (i in 2:length(iterations.feed)-1) {
      iterations <- c(
                        iterations,
                        paste(
                           iterations.feed[i],
                           iterations.feed[i+1],
                           sep="."
                        )
                  );
   }

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

   functions.algorithms <- c();
   for (f in functions) {
      for (a in algorithms) {
         functions.algorithms <- c( 
                                    functions.algorithms,
                                    paste(a, f, sep=".")
                                 );
      }
   }

   result.m <-   matrix(
                     nrow=length(functions.algorithms),
                     ncol=length(iterations)
                  );

   
   for (fa in 1:length(functions.algorithms)) {
      print(paste("Doing row ", fa, " (", functions.algorithms[fa], ")", sep=""));
      row <- c();
      for (i in 1:length(iterations)) {
         rankresult <-  rank(paste(
                           "./mwu/",
                           functions.algorithms[fa],
                           ".",
                           iterations[i],
                           ".txt",
                           sep=""
                        ));
         row <-   c(  
                     row,
                     unlist(unname(rankresult[2]))
                  );
      }
      result.m[fa,] <- row;

   }

   rownames(result.m) <- functions.algorithms;
   colnames(result.m) <- iterations;
   
   write.csv( 
                  result.m,
                  file="mwu-results/mwu-results.txt",
                  #row.names=TRUE,
                  #col.names=TRUE,
                  quote=FALSE
                  #sep=","
   );
   return (result.m);
}

rank <- function(source) {
   x <- scan(source, what=list(perf=0,alg=""))
   data <- c(x$perf)
   data
   group <- factor(x$alg)
   group
   rankList <- rankF(data,group,0.05,FALSE)
   return (rankList)
}

rankF <- function(data, group, alpha=0.05, max=TRUE) {
   #initializes the ranks to 0
   algorithms <- unique(group)
   rankList <- list()
   for (algorithm in algorithms) {
      rankList[(algorithm)] <- 0
   }

   #calculate the vector of medians for all the algorithms' measures
   medians <- tapply(data, group, median)

   #perform a Kruskal-Wallis test to assess if there are differences among all the results
   dataframe <- data.frame(group, data)
   kruskal <- kruskal.test(data ~ group, data=dataframe)
   if (!is.na(kruskal$p.value) && kruskal$p.value < alpha) {
      #post-hoc test: perform a pairwise Mann-Whitney-Wilcoxon rank sum test
      #with Hol correction to assess individual differences
      wilcoxon <- pairwise.wilcox.test(data, group, p.adj="holm", exact=FALSE)

      for (algorithm1 in rownames(wilcoxon$p.value)) {
         for (algorithm2 in colnames(wilcoxon$p.value)) {
            if (!is.na(wilcoxon$p.value[algorithm1,algorithm2]) &&
                wilcoxon$p.value[algorithm1,algorithm2] < alpha) {
               #there is a significant difference between algorithm1 and algorithm2
               #we need to identify which one is the best and which one the worst
               #we'll use the median for that purpose, since it is coherent with the
               #use of the MWW method, which also uses medians
               if (medians[algorithm1] > medians[algorithm2]) {
                  best <- algorithm1
                  worst <- algorithm2
               }
               else {
                  best <- algorithm2
                  worst <- algorithm1
               }

               #if max==FALSE, swap best and worst
               if (!max) {
                  tmp <- best
                  best <- worst
                  worst <- tmp
               }

               #update ranks
               rankList[[best]] <- rankList[[best]] + 1
               rankList[[worst]] <- rankList[[worst]] -1
            }
         }
      }
   }
   return (rankList)
}