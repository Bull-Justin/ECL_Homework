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

// Create dataset: file is a csv format
CarsDS_Raw := DATASET('~raw::usa_cars.csv',         // File name
                    Cars_Rec,       // Record definition
                    CSV(HEADING(1))); //  File type with indicator that row one is the header

// Covert to thor file, speeds up execustion time
OUTPUT(CarsDS_Raw,,'~us::cars::raw::thor', OVERWRITE, EXPIRE(180));