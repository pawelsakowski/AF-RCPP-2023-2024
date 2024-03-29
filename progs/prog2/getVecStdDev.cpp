#include<cmath>
#include<vector>
#include"getVecMean.h"
#include"getVecStdDev.h"

// general function for standard deviation of a vector
double getVecStdDev(std::vector<double> thisVec){
  
  double runningSum = 0.0;
  int thisSize = thisVec.size();
  double thisMean = getVecMean(thisVec);
  
  for ( int i = 0; i < thisSize; i++ ){
    runningSum += pow((thisVec[i]- thisMean ), 2);
  }
  
  return sqrt(runningSum/(thisSize - 1));
}
