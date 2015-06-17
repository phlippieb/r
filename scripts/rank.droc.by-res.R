rank.all.resolutions <- function() {

   resolutions.feed.tmp <- 1:10;
   resolutions.feed <- c();
   for (r in resolutions.feed.tmp) {
      resolutions.feed <- c(resolutions.feed, as.character(r));
   }

   allToAll <- FALSE;

   if (! allToAll) {
      resolutions <- c();
      # Note: no idea why it needs to be 2:, but it does
      for (i in 2:length(resolutions.feed)-1) {
         resolutions <- c(
            resolutions,
            paste(
               resolutions.feed[i], "r.",
               resolutions.feed[i+1], "r.",
               sep=""
            )
         );
      }
   } else {
      # new idea:
      # we're getting mwu=1 for every comparison so far, which sucks
      # what happens if we don't just compare r=n to r=n+1, but rather r=n to r=m for every n != m?
      # NOTE: requires change to droc-pairs python script
      # ANOTHER NOTE: R's nested loop capabilities suck, so this is a bit hacky
      # result: still mostly 1's
      resolutions <- c();
      for (i in 1:(length(resolutions.feed)-1)) {
         for (j in 2:(length(resolutions.feed))) {
            if (j > i) {
               resolutions <- c(
                  resolutions,
                  paste(
                     resolutions.feed[i], "r.",
                     resolutions.feed[j], "r.",
                     sep=""
                  )
               );
            }
         }
      }
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

   result.m <- matrix(
      nrow=length(functions.algorithms),
      ncol=length(resolutions)
   );


   for (fa in 1:length(functions.algorithms)) {
      cat(paste("\rDoing row ", fa, " (", functions.algorithms[fa], ")          ", sep=""));
      row <- c();
      for (i in 1:(length(resolutions))) {
         filename = paste(
            "./drocpairs/res/",
            functions.algorithms[fa], ".",
            resolutions[i],
            "2000i.txt", # can replace with inner loop for iterations later if needed
            sep=""
         );
         if (file.exists(filename)) {
            rankresult = unlist(rank.file(filename))[1];
            row <- c(
               row,
               rankresult
            );
         } else {
            cat (paste ("\rFILE NOT FOUND: ", filename, "\n", sep=""));
         }
      }
      result.m[fa,] <- row;
   }
   cat ("\n");

   rownames(result.m) <- functions.algorithms;
   colnames(result.m) <- resolutions;

   cat ("writing results to mwu-results/mwu-results.txt\n");
   write.csv(
      result.m,
      file="mwu-results/mwu-results.txt",
      quote=FALSE
   );
   #return (result.m);
}
