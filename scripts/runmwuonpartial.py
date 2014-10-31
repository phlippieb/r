functions = ["ackley", "elliptic", "rastrigin", "rosenbrock", "schwefel1_2", "alpine", "eggholder", "griewank", "levy", "michalewicz", "quadric", "quartic", "salomon", "schwefel2_22","schwefel2_26", "spherical", "step", "zakharov"]
algorithms = "gbest", "lbest", "vn", "spso", "gbestgc", "lbestgc", "vngc", "bb", "bba"
iterations = 500

for a1 in range(1, len(algorithms)):
	for a2 in range(a1+1, len(algorithms)):
		for f in range(0, len(functions)):
			#print "sup %s%s" %(algorithms[a1], algorithms[a2])
			print "cat mwu-partial/%s.%s.%s.partial.txt mwu-partial/%s.%s.%s.partial.txt  >  mwu/%s.%s.%s.%s.txt" %(algorithms[a1], functions[f], iterations, algorithms[a2], functions[f], iterations, algorithms[a1], algorithms[a2], functions[f], iterations)
