#include<cmath>
#include<vector>
#include"getVecMean.h"

// general function for mean value of a vector
double getVecMean(std::vector<double> thisVec){

	double runningSum = 0.0;
	int thisSize = thisVec.size();

	for(int i = 0; i < thisSize; i++){
		runningSum += thisVec[i];
	}

	return runningSum/double(thisSize);
}

