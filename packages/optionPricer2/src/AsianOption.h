#include<vector>

class AsianOption{
public:

	//constructor
	AsianOption(
		int nInt_,
		double strike_,
		double spot_,
		double vol_,
		double r_,
		double expiry_
		);

	//destructor
	~AsianOption(){};

	//methods
	void generatePath();
	double getArithmeticMean();
	double getGeometricMean();
	void printPath();
	double getArithmeticAsianCallPrice(int nReps);
	double getArithmeticAsianPutPrice(int nReps);
    double getGeometricAsianCallPrice(int nReps);
	double getGeometricAsianPutPrice(int nReps);
	double operator()(char char1, char char2, int nReps);
	
	//members
	std::vector<double> thisPath;
	int nInt;
	double strike;
	double spot;
	double vol;
	double r;
	double expiry;

};
