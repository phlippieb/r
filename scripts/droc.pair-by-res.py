# USAGE: from r (NOT r/scripts); pipe through bash. i.e:
# python scripts/droc.pair-by-alg.py | bash

# The rank.R functions require files in a format as follows:
#   all data-values to be compared should be in the 1st column
#   for each data-value, the class (algorithms, resolutions, etc) should be in the 2nd column

# This script renames the 2nd column to reflect the algorithm and
# then pairs files containing data from each pair to be compared.

# currently doesn't support different populations or dimensions.

# ###############
#
# Part 1: define scope (which simulations to process)
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

resolutions_i = range(1,11) #EXCLUSIVE!
resolutions = []
for r in resolutions_i:
    resolutions.append(str(r))

# ####
#
# Part 2: rename columns

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
							outfile.write(parts[0] + ' ' + resolutions[r] + "r\n")
				currentrun += 1
				os.rename(ofilename, ifilename)
				infile.close()
				outfile.close()

print "echo"

# ####
#
# Part 3: pair data

# create the drocpairs directory if necessary
drocpairs = os.path.dirname("drocpairs/res/x.txt")
if not os.path.exists(drocpairs):
	os.makedirs(drocpairs)

currentrun = 1
totalruns = len(algorithms) * len(functions) * len(iterations) * (len(resolutions))
for a in range (0, len(algorithms)):
	for f in range(0, len(functions)):
		for r in range(0, len(resolutions)-1):
			for i in range(0, len(iterations)):
				print "echo -ne \"\r[%s/%s] %s %s %s %s %s                \"" %(currentrun, totalruns, algorithms[a], functions[f], resolutions[r], resolutions[r+1], iterations[i])
				currentrun += 1
				print "cat drocdata/%s.%s.%sr.%si.droc.txt drocdata/%s.%s.%sr.%si.droc.txt > drocpairs/res/%s.%s.%sr.%sr.%si.txt" %(
					algorithms[a], functions[f], resolutions[r], iterations[i],
					algorithms[a], functions[f], resolutions[r+1], iterations[i],
					algorithms[a], functions[f], resolutions[r], resolutions[r+1], iterations[i]
				)

print "echo"
