# This is Prof Engelbrecht's rank function.
# I'm not using it because it uses a file as an input,
# and I made a version that takes data from R instead,
# which is much nicer imo.

#rank <- function(source) {
#   x <- scan(source, what=list(perf=0,alg=""))
#   data <- c(x$perf)
#   data 
#   group <- factor(x$alg)
#   group
#   rankList <- rankF(data,group,0.05,FALSE)
#   return (rankList)
#}

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
 

