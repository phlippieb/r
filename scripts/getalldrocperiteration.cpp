#include <iostream>
#include <vector>
using namespace std;

int main() {

	vector<string> functions;
	functions.push_back("ackley");
	functions.push_back("alpine");
	functions.push_back("eggholder");
	functions.push_back("elliptic");
	functions.push_back("goldsteinprice");
	functions.push_back("griewank");
	functions.push_back("levy");
	functions.push_back("michalewicz");
	functions.push_back("quadric");
	functions.push_back("quartic");
	functions.push_back("rastrigin");
	functions.push_back("rosenbrock");
	functions.push_back("salomon");
	functions.push_back("schwefel1_2");
	functions.push_back("schwefel2_22");
	functions.push_back("schwefel2_26");
	functions.push_back("sixhump");
	functions.push_back("spherical");
	functions.push_back("step");
	functions.push_back("zakharov");

	vector<string> algorithms;
	algorithms.push_back("bb");
	algorithms.push_back("bba");
	algorithms.push_back("gbest");
	algorithms.push_back("gbestgc");
	algorithms.push_back("lbest");
	algorithms.push_back("lbestgc");
	algorithms.push_back("spso");
	algorithms.push_back("vn");
	algorithms.push_back("vngc");

	vector<string> iterations;
	iterations.push_back("100");
	iterations.push_back("250");
	iterations.push_back("500");
	iterations.push_back("750");
	iterations.push_back("1000");
	iterations.push_back("1500");
	iterations.push_back("2000");
	iterations.push_back("3000");
	iterations.push_back("5000");
	iterations.push_back("10000");


	for (vector<string>::iterator fi = functions.begin(); fi != functions.end(); ++fi) {
		for (vector<string>::iterator ai = algorithms.begin(); ai != algorithms.end(); ++ai) {
			
		}
	}


	for (vector<string>::iterator fi = functions.begin(); fi != functions.end(); ++fi) {
		for (vector<string>::iterator ai = algorithms.begin(); ai != algorithms.end(); ++ai) {
			for (int si = 1; si <= 30; ++si) {
				cout << "print(\"Doing " << *fi << " / " << *ai << " / " << si << "\");" << endl;
				cout << "thisPWLA <- pwla(" << *ai << "." << *fi << "[, " << si << "]);" << endl;
				cout << "ALLSLOPE1S[\"" << *fi << "\", \"" << *ai << "\", \"" << si << "\"] <- pwla.slope1(thisPWLA);" << endl;
				cout << "ALLSLOPE2S[\"" << *fi << "\", \"" << *ai << "\", \"" << si << "\"] <- pwla.slope2(thisPWLA);" << endl;
			}
		}
	}
}