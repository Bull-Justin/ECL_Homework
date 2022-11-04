IMPORT $.getAirlines;
IMPORT $.getFlights;
IMPORT $.getServiceTypes;
IMPORT STD;


/*
1: An example of data enrichment would be calculated departure of arrival minutes after
midnight:
    depart_minutes_after_midnight := ((UNSIGNED1.DepartTimePassenger[1..2] * 60 +
                                    (UNSIGNED1.DepartTimePassenger[3..4])
Implement the above conversion to your result and review the result
Add 3 enrichment fields to GSEC file
*/

getFlights.Output_GSECRec Flight_TF(getFlights.GSECRec L) := TRANSFORM
    /* To Transform     YYYYMMDD
    INTEGER2            MinutesAfterMidnight;                   // Enrichment 1
    BOOLEAN             RunsOnChristmas;                        // Will check to see if 1225 is within the effective/discontinue date range, then will check the day of the week for that year
    INTEGER1            TotalDaysActive;                        // Total number of days it is active, done by seeing how many weeks it is, then multipling that by the number of days it is active in a week
    INTEGER2            TotalFlightTime;                        // Total time between departure and arrival in Minutes 
    */
    SELF.MinutesAfterMidnight   := ((UNSIGNED1)(L.DepartTimePassenger[1..2]) * 60 
                                    + ((UNSIGNED1)(L.DepartTimePassenger[3..4])));
    SELF.Weekend                := IF((BOOLEAN)L.IsOpSat OR (BOOLEAN)L.IsOpSun, TRUE, FALSE);   
    SELF.TotalDaysActive        := IF(L.EffectiveDate = L.DiscontinueDate, 1, STD.Date.DaysBetween(STD.Date.FromStringToDate(L.EffectiveDate, '%Y%m%d'), STD.Date.FromStringToDate(L.DiscontinueDate, '%Y%m%d')));
    SELF.EconomySeatsOnly       := IF( (L.BusinessClassSeats + L.FirstClassSeats + L.PremiumEconomySeats) = 0 , TRUE , FALSE );
    SELF := L;
    SELF := [];
END;

EnrichedDS := PROJECT(getFlights.gsecData, Flight_TF(LEFT));

OUTPUT(SAMPLE(EnrichedDS, 5, 100), NAMED('EnrichedDS'));

/*
2. Data append: Using getAirLines, append Airline_Name and airline Country to the GSEC file
 Sort result by FlightNumber and DepartStationCode
 Count your results and count the original GSEC data
 Are the total counts the same? Why?

Airline ICAO = Flights Department Station Code
*/

Output_Two_GSEC := RECORD 
    STRING              AirlineName;                            // To be appended from getAirlines Join
    STRING              Country;                                // To be appended from getAirlines Join
    STRING3             Carrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    INTEGER2            FlightNumber;                           // flight number
    STRING1             CodeShareFlag;                          // service type indicator is used to classify carriers according to the type of air service they provide
    STRING3             CodeShareCarrier;                       // alternate flight designator or ticket selling airline
    STRING1             ServiceType;                            // classify carriers according to the type of air service they provide
    STRING8             EffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             DiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    UNSIGNED1           IsOpMon;                                // indicates whether the flight has service on Monday
    UNSIGNED1           IsOpTue;                                // indicates whether the flight has service on Tuesday
    UNSIGNED1           IsOpWed;                                // indicates whether the flight has service on Wednesday
    UNSIGNED1           IsOpThu;                                // indicates whether the flight has service on Thursday
    UNSIGNED1           IsOpFri;                                // indicates whether the flight has service on Friday
    UNSIGNED1           IsOpSat;                                // indicates whether the flight has service on Saturday
    UNSIGNED1           IsOpSun;                                // indicates whether the flight has service on Sunday
    STRING3             DepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             DepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             DepartStateProvCode;                    // Innovata State Code
    STRING3             DepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            DepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING10            DepartTimeAircraft;                     // agreed SLOT departure time; HHMMSS
    STRING5             DepartUTCVariance;                      // UTC Variant for the departure airport; [+-]HHMM
    STRING2             DepartTerminal;                         // departure terminal
    STRING3             ArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             ArriveCountryCode;                      // standard IATA Country code for the point of arrival
    STRING2             ArriveStateProvCode;                    // Innovata State Code
    STRING3             ArriveCityCode;                         // arrival city code contains the city code for the point of trip origin
    STRING10            ArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING10            ArriveTimeAircraft;                     // agreed SLOT arrival time; HHMMSS
    STRING5             ArriveUTCVariance;                      // UTC Variant for the arrival airport; [+-]HHMM
    STRING2             ArriveTerminal;                         // arrival terminal
    STRING3             EquipmentSubCode;                       // sub aircraft type on the first leg of the flight
    STRING3             EquipmentGroupCode;                     // group aircraft type on the first leg of the flight
    VARSTRING4          CabinCategoryClasses;                   // most commonly used service classes
    VARSTRING40         BookingClasses;                         // full list of Service Class descriptions
    INTEGER1            ArriveDayIndicator;                     // signifies which day the flight will arrive with respect to the origin depart day; <blank> = same day, -1 = day before, 1 = day after, 2 = two days after
    INTEGER1            NumberOfIntermediateStops;              // set to zero (i.e. nonstop) if the flight does not land between the point of origin and final destination
    VARSTRING50         IntermediateStopStationCodes;           // IATA airport codes where stops occur, separated by “!”
    BOOLEAN             IsEquipmentChange;                      // signifies whether there has been an aircraft change at a stopover point for the flight leg
    VARSTRING60         EquipmentCodesAcrossSector;             // sub-aircraft type on each leg of the flight
    VARSTRING80         MealCodes;                              // contains up to two meal codes per class of service
    INTEGER2            FlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    INTEGER2            FlightDistance;                         // shortest distance (in miles) between the origin and destination points
    INTEGER2            FlightDistanceThroughIndividualLegs;
    INTEGER2            LayoverTime;                            // minutes
    INTEGER2            IVI;
    INTEGER2            FirstLegNumber;
    VARSTRING50         InFlightServiceCodes;
    BOOLEAN             IsCodeShare;                            // true if flight is operated by another carrier
    BOOLEAN             IsWetLease;                             // true if wet lease (owned by one carrier and operated by another)
    VARSTRING155        CodeShareInfo;                          // information regarding operating and marketing carriers
    INTEGER             FirstClassSeats;
    INTEGER             BusinessClassSeats;
    INTEGER             PremiumEconomySeats;
    INTEGER             EconomyClassSeats;
    INTEGER             TotalSeats;
    UNSIGNED            SectorizedId;                           // unique record ID


END;

appendDS := JOIN(getFlights.gsecData, getAirlines.AirlinesDS,
                 STD.Str.ToUpperCase(LEFT.DepartStationCode) =  STD.Str.ToUpperCase(RIGHT.ICAO),
                 TRANSFORM(Output_Two_GSEC, 
                 SELF.AirlineName   := RIGHT.Airline_Name,
                 SELF.Country       := RIGHT.Country,
                 SELF := LEFT,
                 SELF := []));

sortedAppend := SORT(appendDS, FlightNumber, DepartStationCode);

OUTPUT(sortedAppend, NAMED('FlightsWithAirlines'));
OUTPUT(COUNT(sortedAppend), NAMED('CountOfJoin'));
OUTPUT(COUNT(getFlights.gsecData), NAMED('CountOfgsecData'));


// There were ultimately some values within the two databases that did not match between the ICAO value and the DepartStationCode Value,
// Leading to some flights that were not joined.

/*
3. Append serviceTypeDS from getServiceTypes to your step 2 result
 Does everything look ok to you?
 Sort result by FlightNumber and DepartStationCode and print the result
*/

Output_Three_GSEC := RECORD 
    // Could also use $.getFlights.gsecRec                      // Another way to get an entire record set definition
    STRING1             Code,                                   // Following four values are for problem 3
    STRING              Application,                            
    STRING              Operation_type,
    STRING              Desc,                                   
    STRING              AirlineName;                            // To be appended from getAirlines Join
    STRING              Country;                                // To be appended from getAirlines Join
    STRING3             Carrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    INTEGER2            FlightNumber;                           // flight number
    STRING1             CodeShareFlag;                          // service type indicator is used to classify carriers according to the type of air service they provide
    STRING3             CodeShareCarrier;                       // alternate flight designator or ticket selling airline
    STRING1             ServiceType;                            // classify carriers according to the type of air service they provide
    STRING8             EffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             DiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    UNSIGNED1           IsOpMon;                                // indicates whether the flight has service on Monday
    UNSIGNED1           IsOpTue;                                // indicates whether the flight has service on Tuesday
    UNSIGNED1           IsOpWed;                                // indicates whether the flight has service on Wednesday
    UNSIGNED1           IsOpThu;                                // indicates whether the flight has service on Thursday
    UNSIGNED1           IsOpFri;                                // indicates whether the flight has service on Friday
    UNSIGNED1           IsOpSat;                                // indicates whether the flight has service on Saturday
    UNSIGNED1           IsOpSun;                                // indicates whether the flight has service on Sunday
    STRING3             DepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             DepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             DepartStateProvCode;                    // Innovata State Code
    STRING3             DepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            DepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING10            DepartTimeAircraft;                     // agreed SLOT departure time; HHMMSS
    STRING5             DepartUTCVariance;                      // UTC Variant for the departure airport; [+-]HHMM
    STRING2             DepartTerminal;                         // departure terminal
    STRING3             ArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             ArriveCountryCode;                      // standard IATA Country code for the point of arrival
    STRING2             ArriveStateProvCode;                    // Innovata State Code
    STRING3             ArriveCityCode;                         // arrival city code contains the city code for the point of trip origin
    STRING10            ArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING10            ArriveTimeAircraft;                     // agreed SLOT arrival time; HHMMSS
    STRING5             ArriveUTCVariance;                      // UTC Variant for the arrival airport; [+-]HHMM
    STRING2             ArriveTerminal;                         // arrival terminal
    STRING3             EquipmentSubCode;                       // sub aircraft type on the first leg of the flight
    STRING3             EquipmentGroupCode;                     // group aircraft type on the first leg of the flight
    VARSTRING4          CabinCategoryClasses;                   // most commonly used service classes
    VARSTRING40         BookingClasses;                         // full list of Service Class descriptions
    INTEGER1            ArriveDayIndicator;                     // signifies which day the flight will arrive with respect to the origin depart day; <blank> = same day, -1 = day before, 1 = day after, 2 = two days after
    INTEGER1            NumberOfIntermediateStops;              // set to zero (i.e. nonstop) if the flight does not land between the point of origin and final destination
    VARSTRING50         IntermediateStopStationCodes;           // IATA airport codes where stops occur, separated by “!”
    BOOLEAN             IsEquipmentChange;                      // signifies whether there has been an aircraft change at a stopover point for the flight leg
    VARSTRING60         EquipmentCodesAcrossSector;             // sub-aircraft type on each leg of the flight
    VARSTRING80         MealCodes;                              // contains up to two meal codes per class of service
    INTEGER2            FlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    INTEGER2            FlightDistance;                         // shortest distance (in miles) between the origin and destination points
    INTEGER2            FlightDistanceThroughIndividualLegs;
    INTEGER2            LayoverTime;                            // minutes
    INTEGER2            IVI;
    INTEGER2            FirstLegNumber;
    VARSTRING50         InFlightServiceCodes;
    BOOLEAN             IsCodeShare;                            // true if flight is operated by another carrier
    BOOLEAN             IsWetLease;                             // true if wet lease (owned by one carrier and operated by another)
    VARSTRING155        CodeShareInfo;                          // information regarding operating and marketing carriers
    INTEGER             FirstClassSeats;
    INTEGER             BusinessClassSeats;
    INTEGER             PremiumEconomySeats;
    INTEGER             EconomyClassSeats;
    INTEGER             TotalSeats;
    UNSIGNED            SectorizedId;                           // unique record ID
END;

problem_three_DS := JOIN(appendDS, getServiceTypes.serviceTypesDS,
                         LEFT.ServiceType = RIGHT.Code,
                         TRANSFORM(Output_Three_GSEC,                               
                            SELF := LEFT;
                            SELF := RIGHT;
                            SELF := []; // Not Necessary
                         ), 
                         INNER); // Would give error Exceeded skew limit: if SMART wasn't used, gave a skew limit of 0.5 and estimated 0.9

OUTPUT(SORT(problem_three_DS, FlightNumber, DepartStationCode), NAMED('sortedProbThree'));

// Everything looks alright, there is a duplicate field now for Code and ServiceType but other than that everything seemed to look 