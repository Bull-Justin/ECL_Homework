// Problem 1
person_Rec := RECORD
  UNSIGNED  personID;
  STRING15  firstName;
  STRING25  lastName;
  BOOLEAN   isEmployed;
  UNSIGNED  avgHouseIncome; 
  INTEGER   empGroupNum;
END;

//Inline dataset
empDS := DATASET([     {1102,'Fred','Smith', FALSE, 1000, 900},
                       {1102,'Fact','Smith', TRUE, 200000, 100},
                       {1012,'Joe','Blow', TRUE, 11250, 200},
                       {1085,'Blue','Moon', TRUE, 185000, 500},
                       {1055,'Silver','Jo', FALSE, 5000, 900},
                       {1265,'Darling','Jo', TRUE, 5000, 100},
                       {1265,'Blue','Silver', TRUE, 75000, 200},
                       {1333,'Jane','Smith', FALSE, 50000, 900},
                       {1023,'Alex','Donny',TRUE, 102000, 200},
                       {1024,'Nancy','Alp', TRUE, 201100, 700},
                       {1025,'Sunny', 'Alp', FALSE, 20055, 300},
                       {1025,'Jack', 'Smith', TRUE, 34455, 300},
                       {1025,'River', 'Blue', FALSE, 45667, 700},
                       {1025,'Math', 'Fun', TRUE, 21000, 200}, 
                       {1025,'Zack', 'Foo', FALSE, 87200, 600}, 
                       {1025,'Sarah', 'Cream', TRUE, 56000, 400},
                       {1025,'Mary', 'Foo', FALSE, 45500, 700},
                       {1025,'Dan', 'Jo', FALSE, 23500, 600},
                       {1025,'Nancy', 'Sunlight', TRUE, 90000, 800},
                       {1025,'Don', 'Sunlight', TRUE, 105000, 800},
                       {1333,'Funny','Joke', FALSE, 31450, 103}]
                        ,person_Rec);

// Problem 2 - Create a set of values
SET OF INTEGER lowerIncome := [10000, 12000, 13000, 8000, 8500];

// Problem 3 - Create a set of values
SET OF INTEGER higherIncome := [90000, 80000, 75000];

// Problem 4
INTEGER upperBand := 100000;

//Problem 5
INTEGER lowerBand := 10000;

// Problem 6 - Print all avgHouseIncome that falls between lB and uB, call the attribute midRangeIncome 
midRangeIncome := empDS(avgHouseIncome BETWEEN lowerBand AND upperBand);
OUTPUT(midRangeIncome, NAMED('midRangeIncome'));

// Problem 7 - All employees not in lowerIncome : Should be all(?)
empNotInLower := empDS(avgHouseIncome NOT IN lowerIncome);
empNotInLower;
// Problem 8 - All employees in higherIncome : Should be 2(?)
empInHigher := empDS(avgHouseIncome IN higherIncome);
empInHigher;
// Problem 9 - Last name 'Jo' : Should be 3
COUNT(empDS(lastName = 'Jo'));

// Problem 10 - total avg income of all employeed people, 2 decimal points
OUTPUT(ROUND(AVE(empDS(isEmployed = TRUE), avgHouseIncome) , 2), NAMED('AvgEmpIncome'));

// Problem 11 - Max and Min value in empGroupNum: Print format:
//              'Max Group Number is: XX' , and 'Min Group Num is: XX'
INTEGER max_GroupNum := MAX(empDS, empGroupNum);
INTEGER min_GroupNum := MIN(empDS, empGroupNum);
STRING format_string := 'Max Group Number is: ' + max_GroupNum + ', and Min Group Num is: ' + min_GroupNum;
OUTPUT(format_string, NAMED('minMaxGroupNum'));
