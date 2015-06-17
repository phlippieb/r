rank <- function(data, classes) {
  # where 
  #   data is all 60 elements, and
  #   classes is a c(x,y) with the name of each class
  print("DATA:")
  print(data)
  classes <- c(rep(classes[1], 30), rep(classes[2], 30))
  group <- factor(classes)
  ranklist <- rankF(data, group, 0.05, FALSE)
  return (ranklist)
}

rank.file <- function(source) {
   x <- scan(source, what=list(perf=0,alg=""), quiet='TRUE')
   data <- c(x$perf)
   data 
   group <- factor(x$alg)
   group
   rankList <- rankF(data,group,0.05,FALSE)
   return (rankList)
}

rank.files <- function(source1, source2) {
  x1 <- scan(source1, what=list(perf=0,class=""), quiet='TRUE')
  x2 <- scan(source2, what=list(perf=0,class=""), quiet='TRUE')
  data <- c(x1$perf, x2$perf)
  classes <- c(x1$class, x2$class)
  group <- factor(classes)
  ranklist <- rankF(data, group, 0.05, FALSE)
  return (ranklist)

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
 

