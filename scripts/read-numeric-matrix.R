# this method reads a data file that was produced by running the datascript "process-data" (from this repo) into a format that can be used by the mwu-methods: a numeric matrix
read.asNumericMatrix <- function(file, ...) {
	# 1: determine the number of columns in the file
	#	read the file in using the old way
	tmp.data <- read.table(file, ...);
	#	get the size of a row (if the first one doesn't exist, then the file is empty anyway)
	data.colsize <- length(tmp.data[1,]);
	# 2: read the file using scan, which returns the data unstructured
	data <- scan(file, ...);
	# 3: structure the read data into a matrix
	#	use the previously determined colsize
	#	byrow=TRUE because that's how scan read it in
	data.m <- matrix(data, ncol=data.colsize, byrow=TRUE);
	# and that's it.
	return (data.m)
}