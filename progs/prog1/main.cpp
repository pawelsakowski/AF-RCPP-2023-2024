#include <iostream>
#include "runSimpleMonteCarlo1.h"

using namespace std;

// main function
int main(){

	double Expiry;
	double Strike;
	double Spot;
	double Vol;
	double r;
	unsigned long NumberOfPaths;

	cout << "\nEnter expiry\n";
	cin >> Expiry;

	cout << "\nEnter strike\n";
	cin >> Strike;

	cout << "\nEnter spot\n";
	cin >> Spot;

	cout << "\nEnter volatility\n";
	cin >> Vol;

	cout << "\nEnter risk-free rate\n";
	cin >> r;

	cout << "\nNumber of paths\n";
	cin >> NumberOfPaths;

	double result = runSimpleMonteCarlo1(Expiry,
                                      Strike,
                                      Spot,
                                      Vol,
                                      r,
                                      NumberOfPaths);

	cout << "The price of European call is " << result << "\n";

	return 0;
}


