rank.all.resolutions <- function() {

   resolutions.feed <- c(
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
      , "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"
      , "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"
      , "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"
      , "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"
      , "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"
      , "61", "62", "63", "64", "65", "66", "67", "68", "69", "70"
   );

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

   # only two-dimension functions (for testing only; delete when it works)
   #functions <- c(
   #   "goldsteinprice",
   #   "sixhump"
   #);

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
      #print(paste("Doing row ", fa, " (", functions.algorithms[fa], ")", sep=""));
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
            rankresult = rank(filename);
            row <- c(  
               row,
               rankresult
            );
         } else {
            print (paste ("FILE NOT FOUND: ", filename, sep=""));
         }
      }
      result.m[fa,] <- row;
   }

   rownames(result.m) <- functions.algorithms;
   colnames(result.m) <- resolutions;
   
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
