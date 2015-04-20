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

functions = [
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

iterations = [2000]

resolutions = [
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				8,
				9,
				10
]


for a1 in range(0, len(algorithms)):
	for a2 in range(a1+1, len(algorithms)):
		for f in range(0, len(functions)):
			for i in range(0, len(iterations)):
				for r in range(0, len(resolutions)):
					print "echo %s // %s // %s // %s // %s" %(algorithms[a1], algorithms[a2], functions[f], iterations[i], resolutions[r])
					print "cat drocdata/%s.%s.%sr.%si.droc.txt drocdata/%s.%s.%sr.%si.droc.txt  >  mwu/%s.%s.%s.%sr.%si.txt" %(algorithms[a1], 
																															functions[f],
																															resolutions[r],
																															iterations[i], 
																															algorithms[a2], 
																															functions[f], 
																															resolutions[r], 
																															iterations[i],
																															algorithms[a1], 
																															algorithms[a2], 
																															functions[f], 
																															resolutions[r],
																															iterations[i])
