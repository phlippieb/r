# name explained:
# sumOf(rankOf(droc for each algpair) for each resolution)

rank.all.algs.resolutions <- function() {

   resolutions <- 1:50;

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

   print(algorithmpairs); Sys.sleep(2);

   result.m <- matrix(
      nrow=length(algorithmpairs),
      ncol=length(resolutions)
   );

   for (aa in 2:length(algorithmpairs)) {
      for (r in 1:length(resolutions)) {
         result.m [aa,r] <- 0;
         mwu.sum <- 0;
         for (f in 1:length(functions)) {
            filename = paste(
               "./drocpairs/alg/",
               algorithmpairs[aa], ".",
               functions[f], ".",
               resolutions[r], "r.",
               "2000i.txt",
               sep=""
            );
            if (file.exists(filename)) {
               rankresult = unlist(rank(filename))[1];
               mwu.sum = mwu.sum + rankresult;
            } else {
               cat(paste("\rFILE NOT FOUND:  ", filename, "\n", sep=""));
            }
         }
         result.m[aa,r] <- mwu.sum; # this can potentially be cleaned up to not use mwu.sum
      }
   }

   return (result.m);
}
