EXPORT getCars := MODULE
    EXPORT Cars_Rec := RECORD
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

    EXPORT Cars_DS := DATASET(path, Cars_Rec, FLAT);
END;