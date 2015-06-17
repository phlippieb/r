rankAll <- function() {
  functions <- c( "ackley", "alpine", "elliptic", "eggholder",
                  "goldsteinprice", "griewank", "levy", "michalewicz",
                  "quadric", "quartic", "rastrigin", "rosenbrock",
                  "salomon", "schwefel1_2", "schwefel2_22", "schwefel2_26",
                  "sixhump", "spherical", "step", "zakharov");

  functions <- c( "goldsteinprice", "sixhump");

  algorithms <- c("gbest", "lbest", "vn", "spso", "gcstar", "gcring", "gcvn", "bb", "bbe");

  iterations <- c("2000");

  resolutions <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10");

  a1 <- 1;
  count <- 1;
  algcount <- 1;

  result.df <- data.frame ( a1=rep("", length(functions)),
                            a2=rep("", length(functions)),
                            a3=rep("", length(functions)),
                            a4=rep("", length(functions)),
                            a5=rep("", length(functions)),
                            a6=rep("", length(functions)),
                            a7=rep("", length(functions)),
                            a8=rep("", length(functions)),
                            a9=rep("", length(functions)),
                            a10=rep("", length(functions)),
                            a11=rep("", length(functions)),
                            a12=rep("", length(functions)),
                            a13=rep("", length(functions)),
                            a14=rep("", length(functions)),
                            a15=rep("", length(functions)),
                            a16=rep("", length(functions)),
                            a17=rep("", length(functions)),
                            a18=rep("", length(functions)),
                            a19=rep("", length(functions)),
                            a20=rep("", length(functions)),
                            a21=rep("", length(functions)),
                            a22=rep("", length(functions)),
                            a23=rep("", length(functions)),
                            a24=rep("", length(functions)),
                            a25=rep("", length(functions)),
                            a26=rep("", length(functions)),
                            a27=rep("", length(functions)),
                            a28=rep("", length(functions)),
                            a29=rep("", length(functions)),
                            a30=rep("", length(functions)),
                            a31=rep("", length(functions)),
                            a32=rep("", length(functions)),
                            a33=rep("", length(functions)),
                            a34=rep("", length(functions)),
                            a35=rep("", length(functions)),
                            a36=rep("", length(functions)),

                            stringsAsFactors=FALSE);
  result.function <- c();
  for (f in 1:length(functions)) {
    result.function <- c();
    rownames(result.df)[f] <- functions[f];
    algcount <- 1;
    for (a1 in 1:(length(algorithms)-1)) {
      for (a2 in (a1+1):length(algorithms)) {
        print(paste(count, " doing ", algorithms[a1], ".", algorithms[a2], ".", functions[f], ".txt", sep=""));
        count <- count + 1;
        rankList <- rank.file(paste("./mwu/",
                    algorithms[a1],
                    ".",
                    algorithms[a2],
                    ".",
                    functions[f],
                    ".txt",
                    sep=""
        ));

        colnames(result.df)[algcount] <- paste(algorithms[a1], algorithms[a2], sep=".");
        algcount <- algcount +1;
        result.function <- c(result.function, unlist(unname(rankList[2])))
      }
    }
    result.df[f,] <- result.function;
  }
  write.table(  result.df,
                "mwu-results.txt",
                row.names=TRUE,
                col.names=TRUE,
                quote=FALSE,
                sep=" "
  );
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
