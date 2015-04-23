# Usage note:
# This script produces bash commands that will stitch pairs of droc-data files together.
# A one-liner for this is something like:
#   python <this.py> | bash

# This script can be used to create paired-up files, each containing the droc-data of two simulations, where the two simulations are identically defined in terms of algorithm, population, function, dimensions, and iterations, but differ in their resolution.
# This requires files to be in a two-column format, where the first column is the droc value of a specific simulation (with multiple rows for multiple samples), and the second column contains the name of the resolution used.

# should we compare every resolution to every other (rn/rm; n!=m), or just to every adjacent resolution (rn/rn+1)?
# (all to all is /pretty/ intense yo)
allToall = False

functions = [	
	"ackley",
	"elliptic", 
	"rastrigin", 
	"rosenbrock", 
	"schwefel1_2", 
	"alpine", 
	"eggholder", 
	"goldsteinprice",
	"griewank", 
	"levy", 
	"michalewicz", 
	"quadric", 
	"quartic", 
	"salomon", 
	"schwefel2_22",
	"schwefel2_26", 
	"sixhump",
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

iterations = [
	2000
]

resolutions = [
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
	11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
	51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
	61, 62, 63, 64, 65, 66, 67, 68, 69, 70
]

if not allToall:
	currentrun = 1
	totalruns = len(algorithms) * len(functions) * len(iterations) * (len(resolutions)-1)
	for a in range (0, len(algorithms)):
		for f in range(0, len(functions)):
			for r in range(0, len(resolutions)-1):
				for i in range(0, len(iterations)):
					print "echo -ne \r[%s/%s] %s %s %s %s %s                " %(currentrun, totalruns, algorithms[a], functions[f], resolutions[r], resolutions[r]+1, iterations[i])
					currentrun += 1
					print "cat drocdata/%s.%s.%sr.%si.droc.txt drocdata/%s.%s.%sr.%si.droc.txt > drocpairs/res/%s.%s.%sr.%sr.%si.txt" %(
						algorithms[a], functions[f], resolutions[r], iterations[i], 
						algorithms[a], functions[f], resolutions[r]+1, iterations[i], 
						algorithms[a], functions[f], resolutions[r], resolutions[r]+1, iterations[i]
					)
else:
	currentrun = 1
	import math
	totalruns = len(algorithms) * len(functions) * len(iterations) * math.factorial(len(resolutions))
	for a in range (0, len(algorithms)):
		for f in range(0, len(functions)):
			for r in range(0, len(resolutions)-2):
				for r2 in range(r+1, len(resolutions)-1):
					for i in range(0, len(iterations)):
						print "echo -ne \r[%s/%s] %s %s %s %s %s                " %(currentrun, totalruns, algorithms[a], functions[f], resolutions[r], resolutions[r2], iterations[i])
						currentrun += 1
						print "cat drocdata/%s.%s.%sr.%si.droc.txt drocdata/%s.%s.%sr.%si.droc.txt > drocpairs/res/%s.%s.%sr.%sr.%si.txt" %(
							algorithms[a], functions[f], resolutions[r], iterations[i], 
							algorithms[a], functions[f], resolutions[r2], iterations[i], 
							algorithms[a], functions[f], resolutions[r], resolutions[r2], iterations[i]
						)
print "echo"

