IMPORT $.getCars;

// all records with the minimum price
allMinPrices := getCars.Cars_DS(price = MIN(getCars.Cars_DS,price));
OUTPUT(allMinPrices, NAMED('allMinCars'));

// find the ave price
DECIMAL avePrice := ROUND(AVE(getCars.Cars_DS, price), 2);
OUTPUT(avePrice, NAMED('aveCarPrice'));

// display all cars over the ave price
OUTPUT( getCars.Cars_DS(price > avePrice) , NAMED('overAverage'));