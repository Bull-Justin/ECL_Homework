EXPORT getAirlines := MODULE

EXPORT  airlinesRec := RECORD   
    INTEGER Airline_ID;
    STRING	Airline_Name;
    STRING 	IATA;
    STRING	ICAO;
    STRING	Country;
    STRING  Active;

END;

EXPORT AirlinesDS := DATASET('~airlines::thor', airlinesRec, THOR);

END;