#ifndef SIMVECTORS
#define SIMVECTORS

// you need to include vector, using namespace, at the top of your main.
// include this file inside your main function

//#include <vector>	
//using namespace std;

/*
	the idea:

	include this file where you need to generate code for multiple simulations
	loop through vectors using iterators; use below loops as needed:

	for (vector<string>::iterator a = algorithms.begin(); a < algorithms.end(); a++)
	for (vector<int>::iterator p = populations.begin(); p < populations.end(); p++)
	for (vector<string>::iterator f = functions.begin(); f < functions.end(); f++)
	for (vector<int>::iterator d = dimensions.begin(); d < dimensions.end(); d++)

	to change experiment scope, change values that are added to vectors under "control" parts below,
	then re-compile and re-run generative programs.

*/

vector <string>	algorithms;
vector <int>	populations;
vector <string>	functions;
vector <int>	dimensions;



// control algorithm names here

algorithms.push_back("lbest");
algorithms.push_back("gbest");
algorithms.push_back("spso");
//algorithms.push_back("cpso");
algorithms.push_back("gcpso");
algorithms.push_back("bb");
algorithms.push_back("bbe");



// control population sizes here

//populations.push_back(5);
populations.push_back(25);
//populations.push_back(100);



// control function names here

functions.push_back("ackley");
functions.push_back("rastrigin");
functions.push_back("rosenbrock");
functions.push_back("schwefel1_2");
functions.push_back("elliptic");
functions.push_back("alpine");
functions.push_back("beale");
functions.push_back("eggholder");
functions.push_back("goldsteinprice");
functions.push_back("griewank");
functions.push_back("levy");
functions.push_back("michalewicz");
functions.push_back("quadric");
functions.push_back("quartic");
functions.push_back("salomon");
functions.push_back("schwefel2_22");
functions.push_back("schwefel2_26");
functions.push_back("sixhump");
functions.push_back("spherical");
functions.push_back("step");
functions.push_back("weierstrass");
functions.push_back("zakharov");


// control function dimensions here

//dimensions.push_back(5);
dimensions.push_back(25);
//dimensions.push_back(50);

#endif