# uses pwla.R::pwla.subset(d, i), ::pwla.slope1(df), and ::pwla.slope2(df)
# plots the slope1 and slope2 values (y-axis) calculated on the data up to different values from iterations (x-axis)
#
# param data:		the diversity data; not averaged
# param iterations:	a c()llection of iterations to consider as the cut-off points for each calculation
#					tip: can be generated with, for example, seq(from=1, to=1001, at=10)
plot.droc.foriterations <- function(data, iterations) {
	# first, average the data:
	data <- rowMeans(data);

	# calculate sl1 and sl2 for each cut-off iteration:
	sl1s <- c();
	sl2s <- c();
	for (i in iterations) {
		p <- pwla.subset(data, i);
		sl1s <- c(sl1s, pwla.slope1(p));
		sl2s <- c(sl2s, pwla.slope2(p));
	}

	# plot all sl1 and sl2 values against cut-off iterations
	#	find xlim and ylim:
	plot.xmin <- min(iterations);
	plot.xmax <- max(iterations);
	plot.ymin <- min(sl1s, sl2s);
	plot.ymax <- max(sl1s, sl2s);
	#	plot sl1 lines:
	plot.points <- matrix(c(iterations, sl1s), ncol=2);
	colnames(plot.points) <- c("x", "y");
	plot(	plot.points,
			xlim=c(plot.xmin, plot.xmax),
			ylim=c(plot.ymin, plot.ymax),
			type='l',
			lty=1
			)
	#	plot sl2 lines:
	plot.points <- matrix(c(iterations, sl2s), ncol=2);
	colnames(plot.points) <- c("x", "y");
	lines(	plot.points,
			xlim=c(plot.xmin, plot.xmax),
			ylim=c(plot.ymin, plot.ymax),
			lty=2)
}


# uses pwla.R::pwla.subset(d, i), ::pwla.slope1(df), and ::pwla.slope2(df)
# finds the slope1 and slope2 values calculated on the data up to different values from iterations
#
# param data:		the diversity data; not averaged
# param iterations:	a c()llection of iterations to consider as the cut-off points for each calculation
#					tip: can be generated with, for example, seq(from=1, to=1001, at=10)
droc.foriterations <- function(data, iterations) {
# first, average the data:
	data <- rowMeans(data);

	# calculate sl1 and sl2 for each cut-off iteration:
	sl1s <- c();
	sl2s <- c();
	for (i in iterations) {
		p <- pwla.subset(data, i);
		sl1s <- c(sl1s, pwla.slope1(p));
		sl2s <- c(sl2s, pwla.slope2(p));
	}

	sl1s <- matrix(sl1s, ncol=1);
	rownames(sl1s) <- iterations;
	sl2s <- matrix(sl2s, ncol=1);
	rownames(sl2s) <- iterations;

	result <- list("sl1s"=sl1s, "sl2s"=sl2s);
	return (result);
}


# uses pwla.R::pwla.subset(d, i), ::pwla.slope1(df), and ::pwla.slope2(df)
# finds the slope1 and slope2 values calculated on the data up to different values from iterations
#
# param data:		the diversity data; not averaged
# param iterations:	a c()llection of iterations to consider as the cut-off points for each calculation
#					tip: can be generated with, for example, seq(from=1, to=1001, at=10)
droc.foriterations.unaveraged <- function(data, iterations, samples=30) {
	# calculate sl1 and sl2 for each cut-off iteration:
	sl1s <- c();
	sl2s <- c();
	for (i in iterations) {
		print(paste("iteration: ", i));
		for (s in 1:samples) {
		print(paste("  sample: ", s));	
			p <- pwla.subset(data[,s], i);
			sl1s <- c(sl1s, pwla.slope1(p));
			sl2s <- c(sl2s, pwla.slope2(p));
		}
	}

	sl1s <- matrix(sl1s, ncol=samples);
	rownames(sl1s) <- iterations;
	sl2s <- matrix(sl2s, ncol=samples);
	rownames(sl2s) <- iterations;
	
	result <- list("sl1s"=sl1s, "sl2s"=sl2s);
	return (result);
}