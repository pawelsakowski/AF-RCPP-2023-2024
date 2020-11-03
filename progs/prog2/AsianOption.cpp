#include<iostream>
#include<cmath>
#include"getOneGaussianByBoxMueller.h"
#include"AsianOption.h"


//definition of constructor
AsianOption::AsianOption(
	int nInt_,
	double strike_,
	double spot_,
	double vol_,
	double r_,
	double expiry_){
		nInt = nInt_;
		strike = strike_;
		spot = spot_;
		vol = vol_;
		r = r_;
		expiry = expiry_;
		generatePath();
}

//method definition
void AsianOption::generatePath(){
	double thisDrift = (r * expiry - 0.5 * vol * vol * expiry) / double(nInt);
	double cumShocks = 0;
	thisPath.clear();

	for(int i = 0; i < nInt; i++){
		cumShocks += (thisDrift + vol * sqrt(expiry / double(nInt)) * getOneGaussianByBoxMueller());
		thisPath.push_back(spot * exp(cumShocks));
	}
}

//method definition
double AsianOption::getArithmeticMean(){

	double runningSum = 0.0;

	for(int i = 0; i < nInt; i++){
		runningSum += thisPath[i];
	}

	return runningSum/double(nInt);
}


//method definition
double AsianOption::getGeometricMean(){

	double runningSum = 0.0;

	for(int i = 0; i < nInt ; i++){
		runningSum += log(thisPath[i]);
	}

	return exp(runningSum/double(nInt));
}

//method definition
void AsianOption::printPath(){

	for(int i = 0;  i < nInt; i++){

		std::cout << thisPath[i] << "\n";

	}

}

//method definition
double AsianOption::getArithmeticAsianCallPrice(int nReps){

	double rollingSum = 0.0;
	double thisMean = 0.0;

	for(int i = 0; i < nReps; i++){
		generatePath();
		thisMean=getArithmeticMean();
		rollingSum += (thisMean > strike) ? (thisMean-strike) : 0;
	}

	return exp(-r*expiry)*rollingSum/double(nReps);

}

//method definition
double AsianOption::getArithmeticAsianPutPrice(int nReps){

	double rollingSum = 0.0;
	double thisMean = 0.0;

	for(int i = 0; i < nReps; i++){
		generatePath();
		thisMean=getArithmeticMean();
		rollingSum += (thisMean < strike) ? (strike - thisMean) : 0;
	}

	return exp(-r*expiry)*rollingSum/double(nReps);

}

//method definition
double AsianOption::getGeometricAsianCallPrice(int nReps){

	double rollingSum = 0.0;
	double thisMean = 0.0;

	for(int i = 0; i < nReps; i++){
		generatePath();
		thisMean=getGeometricMean();
		rollingSum += (thisMean > strike)? (thisMean-strike) : 0;
	}

	return exp(-r*expiry)*rollingSum/double(nReps);

}

//method definition
double AsianOption::getGeometricAsianPutPrice(int nReps){

	double rollingSum = 0.0;
	double thisMean = 0.0;

	for(int i = 0; i < nReps; i++){
		generatePath();
		thisMean=getGeometricMean();
		rollingSum += (thisMean < strike)? (strike - thisMean) : 0;
	}

	return exp(-r*expiry)*rollingSum/double(nReps);

}

//overloaded operator ();
double AsianOption::operator()(char char1, char char2, int nReps){
	if ((char1 == 'A') & (char2 =='C'))      return getArithmeticAsianCallPrice(nReps);
	else if ((char1 == 'A') & (char2 =='P')) return getArithmeticAsianPutPrice(nReps);
	else if ((char1 == 'G') & (char2 =='C')) return getGeometricAsianCallPrice(nReps);
	else if ((char1 == 'G') & (char2 =='P')) return getGeometricAsianPutPrice(nReps);
	else return -99;
}
