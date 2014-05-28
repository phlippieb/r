#	
#	Use these to calculate PWLA and metrics
#	
#	
#	

	# calculates a 2-piecewise linear approximation on data points.
	# param d: 	data to calculate pwla for. Works with:
	#			- a given [,i] dimension of a table read in, eg:
	#				data <- read.table("filename", quote="\"")
	#				p 	 <- pwla(data[,1])
	#			- the result of rowmeans calculated on a read table, eg:
	#				data <- read.table("filename", quote="\"")
	#				p 	<- pwla(rowMeans(data))
	# returns: 	a dataframe containing "x" & "y" points belonging to the pwla,
	#			cleaned so that x starts at 0
	pwla <- function (d) {
		b <- bsr2(1:length(d), d, length(d));
		bdf <- data.frame(x=b$fit$model[,2], y=predict(b$fit));
		bdf1 <- bdf[!(bdf$x<0),]
		return (bdf1);
	}

	# calculates a 2-pwla (like above), but on a subset of iterations of d.
	# param d:	data to calculate pwla for; same as above.
	# param i:	the bounding iteration number to go up to.
	#			the calculation will be done on all data from iteration 1 to i inclusive.
	# returns:	same as above.
	pwla.subset <- function(d, i) {
		pwla(d[1:i]);
	}

	# calculates the first slope given a pwla dataframe.
	# param df:	a dataframe object containing "x" and "y" values from a pwla calculation,
	#			as returned by pwla(...), for example.
	# returns:	the slope of the left linear approximation
	pwla.slope1 <- function (df) {
		return(pwla.slopeAt(df, 1));
	}

	# calculates the second slope given a pwla dataframe
	# param df:	a dataframe object containing "x" and "y" values from a pwla calculation,
	#			as returned by pwla(...), for example.
	# returns:	the slope of the right linear approximation
	pwla.slope2 <- function (df) {
		return(pwla.slopeAt(df, length(df$y)-2));
	}

	# calculates the breakpoint between the 2 lines of a pwla.
	# param df: a dataframe object containing "x" and "y" values from a pwla calculation,
	#			as returned by pwla(...), for example.
	# returns:	a list object containing an "x" and "y" value, signifying the coordinates
	#			of the breakpoint.
	pwla.breakpt <- function (df) {
		for (i in 1:length(df$x)) {
			if ( round(pwla.slopeAt(df, i), 10) != round(pwla.slopeAt(df, i+1), 10) ) {
				return (list("x"=df$x[i+1], "y"=df$y[i+1]));
			}
		}
		return (list("x"=(-1), "y"=(-1)));
	}

#
#	These functions are helpers for calculating the above stuff. Feel free to ignore.
#
#
#

	# calculates the slope at a given time step
	# used by pwla.slope1, .slope2 and .breakpt
	# param df: a dataframe object containing "x" and "y" values from a pwla calculation,
	#			as returned by pwla(...), for example.
	# param i:	the time step at which to return the slope
	# returns:	the slope between the i'th and the (i+1)'th time step
	pwla.slopeAt <- function (df, i) {
		return ((df$y[i+1]-df$y[i])/(df$x[i+1]-df$x[i]));
	}

	# Broken stick regression.
	# note:
	#	same as above (bsr), except range of candidate values is automatically entire range of x
	#	instead of passing b, then, the passed res (resolution) determines how many candidate values to consider.
	bsr2 <- function(x,y,res) {
		b <- seq(min(x), max(x), length=res)
		if(length(b)==1) {
			 x1 <- ifelse(x<=b,0,x-b)
			 temp <- lm(y~x+x1)
			 ss <- sum(resid(temp)^2)
			 rslt <- list(fit=temp,ss=ss,b=b)
			 class(rslt) <- "bsr"
			 return(rslt)
		}
		temp <- list()
		for(v in b) {
			 x1 <- ifelse(x<=v,0,x-v)
			 fff <- lm(y~x+x1)
			 temp[[paste(v)]] <- sum(resid(fff)^2)
		}
		ss <- unname(unlist(temp))
		v <- b[which.min(ss)]
		x1 <- ifelse(x<=v,0,x-v)
		rslt <- list(fit=lm(y~x+x1),ss=unname(unlist(temp)),
			      b=b,ss.min=min(ss),b.min=v)
		class(rslt) <- "bsr"
		rslt
	}

