class runmwuonpartial {

	public static void main (String [] args) {

		String [] functions = {"ackley", "elliptic", "rastrigin", "rosenbrock", "schwefel1_2", "alpine", "eggholder", "griewank", "levy", "michalewicz", "quadric", "quartic", "salomon", "schwefel2_22","schwefel2_26", "spherical", "step", "zakharov"};
		String [] algorithms = {"gbest", "lbest", "vn", "spso", "gbestgc", "lbestgc", "vngc", "bb", "bba"};

		for (int a1=0; a1<algorithms.length; a1++) {
			for (int a2=a1+1; a2<algorithms.length; a2++) {
				for (int f=0; f<functions.length; f++) {
					System.out.println("cat mwu-partial/" + algorithms[a1] + "." + functions[f] + ".partial.txt mwu-partial/" + algorithms[a2] + "." + functions[f] + ".partial.txt > mwu/" + algorithms[a1] + "." + algorithms[a2] + "." + functions[f] + ".txt");
				}
			}
		}

	}
}