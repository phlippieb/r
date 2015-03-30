# set up some arrays for simulations

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


populations = [
	25
]

functions = [
	"ackley",
#	"elliptic", 
#	"rastrigin", 
#	"rosenbrock", 
#	"schwefel1_2", 
#	"alpine", 
#	"eggholder", 
#	"griewank", 
#	"levy", 
#	"michalewicz", 
#	"quadric", 
#	"quartic", 
#	"salomon", 
#	"schwefel2_22",
#	"schwefel2_26", 
#	"spherical", 
#	"step", 
#	"zakharov", 
#	"goldsteinprice", 
#	"sixhump"
]

dimensions = [
25
]

# don't think we need this
#iterations = [2000]

samples = 30

for a in range(0, len(algorithms)):
	for p in range(0, len(populations)):
		for f in range(0, len(functions)):
			for d in range(0, len(dimensions)):

				# diversity data:
				divfilename = "rdata/" + algorithms[a] + "." + str(populations[p]) + "." + functions[f] + "." + str(dimensions[d]) + ".div"
				f = open(divfilename)
				f_byrow = []
				for line in f:
					f_byrow.append(line.split())
				f_bycol = zip(*f_byrow)
				for sample in range(0, len(f_bycol)):
					for iteration in range (0, len(f_byrow)):
						print "db.simulations.insert({"
						print "   algorithm: \"%s\"," 	%(algorithms[a])
						print "   population: \"%s\"," 	%(populations[p])
						print "   function: \"%s\"," 	%(functions[f])
						print "   dimension: \"%s\"," 	%(dimensions[d])
						print "   sample: \"%s\"," 		%(sample)
						print "   iteration: \"%s\"," 	%(iteration)
						print "   diversity: \"%s\"" 	%(f_bycol[sample][iteration])
				print "})"
				f.close()

				# fitness data:
				fitfilename = "rdata/" + algorithms[a] + "." + str(populations[p]) + "." + functions[f] + "." + str(dimensions[d]) + ".fit"
				f = open(fitfilename)
				f_byrow = []
				for line in f:
					f_byrow.append(line.split())
				f_bycol = zip(*f_byrow)
				for sample in range(0, len(f_bycol)):
					for iteration in range (0, len(f_byrow)):
						print "db.simulations.insert({"
						print "   algorithm: \"%s\"," 	%(algorithms[a])
						print "   population: \"%s\"," 	%(populations[p])
						print "   function: \"%s\"," 	%(functions[f])
						print "   dimension: \"%s\"," 	%(dimensions[d])
						print "   sample: \"%s\"," 		%(sample)
						print "   iteration: \"%s\"," 	%(iteration)
						print "   fitness: \"%s\"" 	%(f_bycol[sample][iteration])
				print "})"
				print ""
				f.close()
