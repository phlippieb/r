# the rank.R functions require files to be in a 2-col format, where the second col is the name of the algorithm.
# when we're not comparing algorithms, though, but rather same simulations with different resolutions, we need the second col to be the name of the resolution used.
# this script replaces the text in the second col of each simulation with the name of the resolution.

# usage note:
# pipe through bash to get perfectly renamed output;
# it still works otherwise, but needs renaming

import os

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
	"zakharov"
]

#functions = [
#	"goldsteinprice",
#	"sixhump"
#]
			
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
	"2000"
]

resolutions_i = range(1,51)
resolutions = []
for r in resolutions_i:
    resolutions.append(str(r))

currentrun = 1
totalruns = len(algorithms) * len(functions) * len(iterations) * (len(resolutions)-1)

print "export CLEARSPACE=\"                                \""

for a in range (0, len(algorithms)):
	for f in range(0, len(functions)):
		for r in range(0, len(resolutions)):
			for i in range(0, len(iterations)):
				ifilename = "drocdata/" + algorithms[a] + "." + functions[f] + "." + resolutions[r] + "r." + iterations[i] + "i.droc.txt"
				ofilename = "drocdata/" + algorithms[a] + "." + functions[f] + "." + resolutions[r] + "r." + iterations[i] + "i.droc.txt.mod"
				with open(ifilename) as infile:
					with open(ofilename, "wt") as outfile:
						for line in infile:
							print "echo -ne \"\r[%s/%s] %s $CLEARSPACE\"" %(currentrun, totalruns, ifilename)
							parts = line.split(' ')
							outfile.write(parts[0] + ' ' + algorithms[a] + "\n")
				currentrun += 1
				os.rename(ofilename, ifilename)
				infile.close()
				outfile.close()

print "echo"
#print "rename -f 's/\.mod$//' drocdata/*.mod"
