plot.avgAndSd <- function (means, sd, epsilon=0.2, ...) {
  x <- 1:length(means);
  y <- means;
  plot(x, y, ylim=c(-1,1), ...);
  segments(x, y-sd, x, y+sd);
  segments(x-epsilon,y-sd,x+epsilon,y-sd);
  segments(x-epsilon,y+sd,x+epsilon,y+sd);
}

plot.avgAndSd.byRow <- function (data, epsilon=0.2, ...) {
  means <- rowMeans(data);
  sds <- apply(data, 1, sd);
  plot.avgAndSd(means, sd, epsilon, ...);
}

plot.avgAndSd.byRow.final <- function (data, cc, epsilon=0.2, ...) {
  par.mar.old <- par("mar");
  par(mar=c(9,4.1,4.1,2.1));
  plot.avgAndSd.byRow(data, epsilon,
                      xlab="functions",
                      ylab="",
                      axes=F,
                      ...);
  box();
  par(mgp=c(7,1,0))
  axis(side=1,
       at=c(1:20),
       labels=allFunctions,
       las=3);
  axis(side=2,
       las=1)
  mtext(cc,
        side=2,
        line=3);
  par(mar=par.mar.old)
}

plot.avgAndSd.byCol <- function (data, epsilon=0.2, ...) {
  means <- colMeans(data);
  sds <- apply(data, 2, sd);
  plot.avgAndSd(means, sd, epsilon, ...);
}