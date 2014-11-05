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
algorithms = "gbest", "lbest", "vn", "spso", "gbestgc", "lbestgc", "vngc", "bb", "bba"
iterations = [500, 1000, 5000, 10000]

for a1 in range(1, len(algorithms)):
	for a2 in range(a1+1, len(algorithms)):
		for f in range(0, len(functions)):
			for i in range(0, len(iterations)):
				print "echo %s // %s // %s // %s" %(algorithms[a1], algorithms[a2], functions[f], iterations[i])
				print "cat mwu-partial/%s.%s.%s.partial.txt mwu-partial/%s.%s.%s.partial.txt  >  mwu/%s.%s.%s.%s.txt" %(algorithms[a1], 
																														functions[f], 
																														iterations[i], 
																														algorithms[a2], 
																														functions[f], 
																														iterations[i], 
																														algorithms[a1], 
																														algorithms[a2], 
																														functions[f], 
																														iterations[i])
