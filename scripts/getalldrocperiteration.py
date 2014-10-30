functions = []
functions.append("ackley")
functions.append("alpine")
functions.append("eggholder")
functions.append("elliptic")
functions.append("goldsteinprice")
functions.append("griewank")
functions.append("levy")
functions.append("michalewicz")
functions.append("quadric")
functions.append("quartic")
functions.append("rastrigin")
functions.append("rosenbrock")
functions.append("salomon")
functions.append("schwefel1_2")
functions.append("schwefel2_22")
functions.append("schwefel2_26")
functions.append("sixhump")
functions.append("spherical")
functions.append("step")
functions.append("zakharov")

algorithms = []
algorithms.append("bb")
algorithms.append("bba")
algorithms.append("gbest")
algorithms.append("gbestgc")
algorithms.append("lbest")
algorithms.append("lbestgc")
algorithms.append("spso")
algorithms.append("vn")
algorithms.append("vngc")

iterations = []
iterations.append("100")
iterations.append("250")
iterations.append("500")
iterations.append("750")
iterations.append("1000")
iterations.append("1500")
iterations.append("2000")
iterations.append("3000")
iterations.append("5000")
iterations.append("10000")

print "iterations = c();"
for i in iterations
	print "iterations <- c(iterations, \"" + i + "\");"


for f in functions
	for a in algorithms
		print "currentmeasures <- c();"
		print "currentdata <- read.asNumericMatrix(\"rdata/" + a + ".25." + f + ".25.div\");"
		print "currentlist <- droc.foriterations.unaveraged.par(currentdata, iterations);"