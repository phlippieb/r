# NOTE:
# Not sure what this does with missing functions (at this point, the 2 fixed-dimension ones are Goldstein-Price and Six-Hump Camel Back)

functions = [	"ackley",
				"elliptic", 
				"rastrigin", 
				"rosenbrock", 
				"schwefel1_2", 
				"alpine", 
				"eggholder", 
				"griewank", 
				"levy", 
				"michalewicz", 
				"quadric", 
				"quartic", 
				"salomon", 
				"schwefel2_22",
				"schwefel2_26", 
				"spherical", 
				"step", 
				"zakharov", 
				"goldsteinprice", 
				"sixhump"
			]
algorithms = [
				"bb",
				"bba",
				"gbest",
				"gbestgc",
				"lbest",
				"lbestgc",
				"spso",
				"vn",
				"vngc"
			]
#iterations = [500, 1000, 2000, 5000, 10000]
iterations = [100,200]


for a in range(0, len(algorithms)):
	for f in range(0, len(functions)):
		for i in range(0, len(iterations)-1):
			print "echo %s // %s // %s // %s" %(algorithms[a], functions[f], iterations[i], iterations[i+1])
			print "cat mwu-partial/%s.%s.%s.partial.txt mwu-partial/%s.%s.%s.partial.txt  >  mwu/%s.%s.%s.%s.txt" %(algorithms[a], 
																													functions[f], 
																													iterations[i], 
																													algorithms[a], 
																													functions[f], 
																													iterations[i+1], 
																													algorithms[a], 
																													functions[f], 
																													iterations[i],
																													iterations[i+1])
