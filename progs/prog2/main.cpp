#include<iostream>
#include<vector>
#include<ctime>
#include<cstdlib>
#include"AsianOption.h"
#include"getVecMean.h"
#include"getVecStdDev.h"

using std::vector;
using std::cout;
using std::cin;

int main(){
  
  // set the seed
  srand( time(NULL) );
  
  //create a new instance of class
  AsianOption myAsian(126, 100, 95, 0.2, 0.06, 0.5);
  
  // Iterate over all the elements.
  // myAsian.printPath();
  
  //get arithmetic means
  cout << "arithmetic mean = " << myAsian.getArithmeticMean() <<"\n";
  cout << "geometric  mean = " << myAsian.getGeometricMean()  <<"\n";
  
  //get last price of underlying
  cout << "Last price of underlying = " << myAsian.thisPath.back() << "\n";
  
  //run Monte Carlo to obtain theoretical price of Asian options
  cout << "Price of arithmetic Asian Call = " << myAsian.getArithmeticAsianCallPrice(10000) << "\n";
  cout << "Price of arithmetic Asian Put = "  << myAsian.getArithmeticAsianPutPrice(10000)  << "\n";
  cout << "Price of geometric Asian Call = "  << myAsian.getGeometricAsianCallPrice(10000)  << "\n";
  cout << "Price of geometric Asian Put = "   << myAsian.getGeometricAsianPutPrice(10000)   << "\n";
  
  //call Monte Carlo via overloaded () operator
  cout << "calling functions via operator() \n";
  cout << "Price of arithmetic Asian Call = " <<  myAsian('A', 'C', 10000) << "\n";
  cout << "Price of arithmetic Asian Put = "  <<  myAsian('A', 'P', 10000) << "\n";
  cout << "Price of geometric Asian Call = "  <<  myAsian('G', 'C', 10000) << "\n";
  cout << "Price of geometric Asian Put = "   <<  myAsian('G', 'P', 10000) << "\n";
  
  //check whether the Data Generating Process runs correctly
  //(is the expected price and volatility of underlying close to option parameters?)
  vector<double> myVec2;
  for(int i = 0; i < 1000; i++){
    myAsian.generatePath();
    myVec2.push_back(myAsian.thisPath.back());
  }
  
  cout << "mean of last underlying prices is "   << getVecMean(myVec2)   << "\n";
  cout << "stddev of last underlying prices is " << getVecStdDev(myVec2) << "\n";
  
  //cout << "\nPress Enter to continue...";
  //cin.get();
  return 0;
}
