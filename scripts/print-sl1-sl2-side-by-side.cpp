#include <iostream>
#include <vector>
using namespace std;

int main() {
	vector<string> algorithms;
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

	algorithms.push_back("bb");
	algorithms.push_back("bba");
	algorithms.push_back("gbest");
	algorithms.push_back("gbestgc");
	algorithms.push_back("lbest");
	algorithms.push_back("lbestgc");
	algorithms.push_back("spso");
	algorithms.push_back("vn");
	algorithms.push_back("vngc");


	for (vector<string>::iterator fi = functions.begin(); fi != functions.end(); ++fi) {
		cout << "print(\"\");print(\"" << *fi << "\");" << endl;
		for (vector<string>::iterator ai = algorithms.begin(); ai != algorithms.end(); ++ai) {
				cout << "cat(\"" << *ai << ": \");" << endl;
				cout << "cat(mean(ALLSLOPE1S[\"" << *fi << "\", \"" << *ai << "\",]));" << endl;
				cout << "cat(\"   \");" << endl; 
				cout << "cat(mean(ALLSLOPE2S[\"" << *fi << "\", \"" << *ai << "\",]));" << endl;
				cout << "print(\"\");" << endl;
		}
	}
}