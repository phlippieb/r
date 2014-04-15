#include <iostream>
#include <vector>
using namespace std;


void act(string alg, int pop, string fun, int dim);

int main()
{
	#include "simVectors.cpp"

	// create dataframe to hold table

	cout 	<< "source(\"rscripts/pwla-util.R\");" << endl
			<< "slope1stats <- data.frame ( num=rep(NA, 5), txt=rep(\"\", 5), stringsAsFactors=FALSE);"
			<< endl << endl;


	int algorithmNumber = 1;
	for (vector<string>::iterator a = algorithms.begin(); a < algorithms.end(); a++) {
		cout << "thisAlg <- c();" << endl;
		for (vector<int>::iterator p = populations.begin(); p < populations.end(); p++) {
			for (vector<string>::iterator f = functions.begin(); f < functions.end(); f++) {
				for (vector<int>::iterator d = dimensions.begin(); d < dimensions.end(); d++) {
					act(*a, *p, *f, *d);
				}	
			}
		}
		cout << "slope1stats[" << algorithmNumber << "] <- thisAlg;" << endl << endl;
		algorithmNumber++;
	}
	return 0;
}

void act(string alg, int pop, string fun, int dim) {
	cout 	<< "sl1 <- measures.sl1.stats.persim (\"" 
			<< alg << "\", \"" 
			<< pop << "\", \"" 
			<< fun << "\", \"" 
			<< dim << "\");" << endl
			<< "result <- paste(sl1$mean, \"plusminus\", sl1$sd, sep=" ");" << endl
			<< "thisAlg <- c(thisAlg, result);" << endl;
}