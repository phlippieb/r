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
				# print "### running for %s.%s.%s.%s" %(algorithms[a], populations[p], functions[f], dimensions[d])
				print "db.simulations.insert( {"
				print "   algorithm: \"%s\"," 	%(algorithms[a])
				print "   population: \"%s\"," 	%(populations[p])
				print "   function: \"%s\"," 	%(functions[f])
				print "   dimension: \"%s\"," 	%(dimensions[d])
				# read measurement data:
				print "   measurements: ["
				divfilename = "rdata/" + algorithms[a] + "." + str(populations[p]) + "." + functions[f] + "." + str(dimensions[d]) + ".div"
				f = open(divfilename)
				f_byrow = []
				for line in f:
					f_byrow.append(line.split())
				f_bycol = zip(*f_byrow)
				for sample in range(0, len(f_bycol)):
					print "      {" #begin sample document
					print "        sample: \"%s\"," %(sample)
					print "        data: ["
					for iteration in range (0, len(f_byrow)):
						print "         {" #begin iteration document
						print "           iteration: \"%s\"," %(iteration)
						print "           diversity: \"%s\"" %(f_bycol[sample][iteration])
						if iteration < (len(f_byrow)-1):
							print "         }," #close iteration document
						else:
							print "         }" #close last iteration document
					print "        ]"
					if sample < (len(f_bycol)-1):
						print "      }," #close sample document
					else:
						print "      }"	#close last sample document
				print "   ]"
				print "})"
                                print ""

