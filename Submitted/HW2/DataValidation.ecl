// Problem 1: Cars Record Structure
Cars_Rec := RECORD
      INTEGER  carID;
      INTEGER  price;
      STRING   brand;
      STRING   model;
      INTEGER  year;
      STRING   title_status;
      REAL     mileage;
      STRING   color;
      INTEGER  vin;
      INTEGER  lotNum;
      STRING   state;
      STRING   country;
      STRING   condition;
END;

// Path for Car Dataset
path := '~us::cars::raw::thor';

// Problem 2: Create cars dataset
Cars_DS := DATASET(path,
                  Cars_Rec,
                  FLAT);

// Problem 3: Output first 200 Rows
OUTPUT(CHOOSEN(Cars_DS, 200), NAMED('Cars_DS_choosen'));

// Problem 4: Starting from 150, output the next 50
OUTPUT(CHOOSEN(Cars_DS,50,150), NAMED('fifty_after150'));

// Problem 5: Output all 2008 Cars
OUTPUT(CHOOSEN(Cars_DS, 2008), NAMED('allCars'));

// Problem 6: Sort the result of the 2008 cars ascendingly by "Brand", Output
OUTPUT(SORT(Cars_DS, brand), NAMED('sortAscBrand'));

// Problem 7: Display all cars between 10000 and 15000, made after 2008
OUTPUT(Cars_DS(year > 2008 AND price BETWEEN 10000 AND 15000));

// Problem 8: Are there any non-usa cars?
non_USA := Cars_DS(country != 'usa');
OUTPUT(non_USA, NAMED('invalid_country'));

// Problem 9: Are all the prices valid?
invalid_Price := Cars_DS(price <= 0);
OUTPUT(invalid_Price, NAMED('invalid_Prices'));

// Problem 10: 2 or more validation checks.
invalid_Lot := Cars_DS(lotNum <= 0);
OUTPUT(invalid_lot, NAMED('bad_Lots'));

invalid_Mileage := Cars_DS(mileage < 0);
OUTPUT(invalid_Mileage, NAMED('negative_Mileage'));