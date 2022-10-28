IMPORT $.getCars;

/* 1
Create a summary table that includes the following. Display result as brand_Cost_Avg
 Brand
 AvgCost: Average cost per brand
*/

brand_Cost_Avg := TABLE(getCars.Cars_DS,
                        {
                        brand,
                        AvgCost := ROUND(AVE(GROUP, price), 2);
                        },
                        brand);

OUTPUT(brand_Cost_Avg, NAMED('BrandSummary'));
/* 2
Create a report with following fields. Display result as brand_Model_Avg
 Brand
 Model
 AvgCost: Average cost per brand and model
*/

brand_Model_Avg := TABLE(
                    getCars.Cars_DS,
                    {
                        brand;
                        model;
                        AvgCost := ROUND(AVE(GROUP, price), 2);
                    },
                    brand, model);

OUTPUT(brand_Model_Avg, NAMED('avgByBrandModel'));
/* 3
Show how many cars per each brand is available in each year. Display result as
brand_Year_Sum
 Brand
 Year
 Total
*/

brand_Year_Sum := TABLE(getCars.Cars_DS ,
                        {
                            brand;
                            year;
                            total := COUNT(GROUP);
                        },
                         brand, year);
OUTPUT(brand_Year_Sum ,NAMED('countByBrandYear'));
/* 4
print a sample list of brand_Year_Sum starting with record 5, and get every other row.
Display result as getSample
*/

getSample := SAMPLE(getCars.Cars_DS, 2, 5);
OUTPUT(getSample, NAMED('getSample'));

/* 5
If there is any data in getSample, distribute it by year. Display result distCars
*/

distCars := IF (EXISTS(getSample), DISTRIBUTE(getCars.Cars_DS, HASH32(year)));
OUTPUT(distCars, NAMED('distByYear'));
