# plot the diversity measures over time and pwla for the same data,
# but taking different numbers of iterations as the scope of the experiment
#
# param data:		the diversity data to base measures on
# param iterations:	a c(ollection) of iterations to consider as lengths of the experiment
plot.diversity.pwla.foriterations <- function(data, iterations) {
	
	i <- order(-iterations);

	pwlas <- c();
	# calculate pwla per each iteration cut-off:
	for (j in c(1:i)) {
		p <- pwla.subset(data, iterations[j]);
		pwlas <- c(pwlas, p);
	}


	# draw each result:
	pdf(width=10, height=10);
	par(family="serif");
	par(mar=c(5,4,2,1));

	plot(data,
		type='l',
		lty=2,
		axes=FALSE,
		xaxt='n', yaxt='n',
		xlab="Iterations",
		ylab="Diversity",
		lwd=1);

	box();

	axis(side=1,
		at=c(1,100,200),
		#labels=c("1", "1000", "2000"),
		lwd=1);

	axis(side=2,
		at=c(round(min(data)), round(max(data))),
		las=0,
		lwd=1);
	# draw each pwla
	for (j in c(1:i)) {
		# first, create an x-y structure with data to plot:
		data.forThisPwla.x <- unlist(unname(pwlas[(j*2)-1]));
		data.forThisPwla.y <- unlist(unname(pwlas[(j*2)]));
		data.forThisPwla <- list("x"=data.forThisPwla.x, "y"=data.forThisPwla.y);
		lines(data.forThisPwla,
			lty=1,
			xaxt='n', yaxt='n',
			xlab="", ylab="",
			lwd=1);
	}

	# finalise pdf
	dev.off();

	# also print out (for now) all sl1 values:
	allSlopes <- c();
	for (j in c(1:i)) {
		data.forThisPwla.x <- unlist(unname(pwlas[(j*2)-1]));
		data.forThisPwla.y <- unlist(unname(pwlas[(j*2)]));
		data.forThisPwla <- data.frame("x"=data.forThisPwla.x, "y"=data.forThisPwla.y);
		sl1 <- pwla.slope1(data.forThisPwla);
		print(paste("Slope1 up to iteration ",  iterations[j],  ": ", sl1));
		allSlopes <- c(allSlopes, sl1);
	}

	return (allSlopes);
}