plot.diversity <- function (data) {
	data <- rowMeans(read.table(data));

	pdf(width=3, height=3);

	par(family="serif");
	par(mar=c(5,4,2,1));

	plot(data,
		type='l',
		axes=FALSE,
		xaxt='n', yaxt='n',
		xlab="Iterations",
		ylab="Diversity",
		lwd=1);

	box();

	axis(side=1,
		at=c(1,100,200),
		labels=c("1", "1000", "2000"),
		lwd=1);

	axis(side=2,
		at=c(round(min(data),1), round(max(data),2)),
		las=0,
		lwd=1);

	dev.off();
}

plot.diversity.pwla <- function (data) {
	# calculate the pwla
	data <- rowMeans(read.table(data));
	plines <- pwla(data);

	# draw diversity info
	pdf(width=5, height=3);

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
		labels=c("1", "1000", "2000"),
		lwd=1);

	axis(side=2,
		at=c(round(min(data)), round(max(data))),
		las=0,
		lwd=1);

	# draw the pwla
	lines(plines,
		lty=1,
		xaxt='n', yaxt='n',
		xlab="", ylab="",
		lwd=1);
	# finalise pdf
	dev.off();
}	

plot.diversity.for.two <- function (data1, data1name, data2, data2name) {
	data1 <- rowMeans(read.table(data1));
	data2 <- rowMeans(read.table(data2));
	datamin <- min(min(data1), min(data2));
	datamax <- max(max(data1), max(data2));

	pdf(width=5, height=3);

	par(family="serif");
	par(mar=c(5,4,2,1));

	plot(data1,
		ylim=c(datamin, datamax),
		type='l',
		axes=FALSE,
		xaxt='n', yaxt='n',
		xlab="Iterations",
		ylab="Diversity",
		lwd=1);

	lines(data2,
		lty=2,
		xaxt='n', yaxt='n',
		xlab="",
		ylab="",
		lwd=1);

	box();

	axis(side=1,
		at=c(1,100,200),
		labels=c("1", "1000", "2000"),
		lwd=1);

	axis(side=2,
		at=c(round(datamin,1), round(datamax,2)),
		las=0,
		lwd=1);

	legend('topright', 
			legend=c(data1name, data2name),
			lty=c(1,2),
			bty='n',
			#cex=.75
			);

	dev.off();
}

