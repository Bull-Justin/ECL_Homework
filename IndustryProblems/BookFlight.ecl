IMPORT $.getFlights;
IMPORT STD;

/*
Primary Goal: 
Austin -> Layover -> Bloomington -> Chicago, 
AUS -> Layover -> BMI -> ORD
Stay on the same airline for the first two flights
Sometime in March 2020: 202003XX %Y%m%d

Layover Time should be 1 <= X <= 2 hour, 60 <= x <= 120 in context of the Dataset

First Flight: 
Austin -> Bloomington, IL (AUS -> BMI)
One Layover Flight, with the same Airline
Layovertime: 1<=x<=2 hours

Second Flight:
Bloomington, IL -> O'Hare International (BMI -> ORD)
Airline does not have to be the same

Only show the record matching the minimum sum total flight time + layover. 
*/


// Get all the flights where March 2020 is within the Effective and Discontinue Date Range
MarchFlights := getFlights.gsecData(DiscontinueDate >= '20200301' AND EffectiveDate <= '20200331');
// OUTPUT(MarchFlights, NAMED('MarchFlights'));

MarchAustinFlights := MarchFlights(STD.STR.ToUpperCase(DepartStationCode) = 'AUS');
OUTPUT(MarchAustinFlights, NAMED('MarchAustinFlights'));

MarchWithLayoverTime := MarchFlights(LayoverTime BETWEEN 60 AND 120);
// OUTPUT(MarchWithLayoverTime, NAMED('MarchConstraintOne'));

MarchConstraintOneStop := MarchWithLayoverTime(NumberOfIntermediateStops = 1);
// OUTPUT(MarchConstraintOneStop, NAMED('MarchWithLayover'));
// 14362
// OUTPUT(COUNT(MarchConstraintOneStop), NAMED('CountOfMarchWithLayover')); 


// // Trying to understand what the data is
// ConstrainedAustinFlights := MarchConstraintOneStop(STD.Str.CompareIgnoreCase(DepartStationCode, 'AUS') = 0);
// // These are all the flights, through March 2020, With the appropriate layovertime, and only one intermediate stop
// OUTPUT(ConstrainedAustinFlights, NAMED('ConstrainedAustinFlights'));

OutputRec := RECORD
    UNSIGNED2           AustinFlightNumber;
    UNSIGNED2           BMIFlightNumber;
    STRING3             DepartCarrier;
    STRING3             DepartShareCarrier;
    STRING3             ArriveCarrier;
    STRING3             ArriveShareCarrier;
    STRING3             InitialDepartStationCode;
    STRING3             AUSArriveStationCode;
    STRING3             BMIDepartStationCode;
    STRING3             FinalArriveStationCode;
    UNSIGNED2           FlightOneArriveTime;
    UNSIGNED2           FlightTwoDepartTime;
    INTEGER4            FlightDifference;
    INTEGER2            FlightOneDuration;
    INTEGER2            FlightTwoDuration;
    UNSIGNED1           IsOpMon;                                // indicates whether the flight has service on Monday
    UNSIGNED1           IsOpTue;                                // indicates whether the flight has service on Tuesday
    UNSIGNED1           IsOpWed;                                // indicates whether the flight has service on Wednesday
    UNSIGNED1           IsOpThu;                                // indicates whether the flight has service on Thursday
    UNSIGNED1           IsOpFri;                                // indicates whether the flight has service on Friday
    UNSIGNED1           IsOpSat;                                // indicates whether the flight has service on Saturday
    UNSIGNED1           IsOpSun;                                // indicates whether the flight has service on Sunday
    UNSIGNED            ArriveSectorizedID;
    UNSIGNED            DepartSectorizedID; 
END;

AppropriateConnectingFlights := JOIN(MarchAustinFlights, MarchFlights(ArriveStationCode = 'BMI'), 
    ((LEFT.Carrier = RIGHT.Carrier) OR   // Carriers must match
    (LEFT.CodeShareCarrier = RIGHT.CodeShareCarrier)) AND // Checking the SharedCarriers
    LEFT.ArriveStationCode = RIGHT.DepartStationCode  AND  // Checking Matching Stations
    (   LEFT.IsOpMon = RIGHT.IsOpMon  OR
        LEFT.IsOpTue = RIGHT.IsOpTue  OR
        LEFT.IsOpWed = RIGHT.IsOpWed  OR
        LEFT.IsOpThu = RIGHT.IsOpThu  OR
        LEFT.IsOpFri = RIGHT.IsOpFri  OR
        LEFT.IsOpSat = RIGHT.IsOpSat  OR
        LEFT.IsOpSun = RIGHT.IsOpSun    ) AND // Checking if they run on at least one of the same days
    LEFT.ArriveTimeAircraft < RIGHT.DepartTimeAircraft // Making sure that the Flight From Austin Arrives before the Departure of the BMI Flight
    ,TRANSFORM(OutputRec, 
            SELF.AustinFlightNumber         := LEFT.FlightNumber;
            SELF.BMIFlightNumber            := RIGHT.FlightNumber;
            SELF.DepartCarrier              := LEFT.Carrier;
            SELF.DepartShareCarrier         := LEFT.CodeShareCarrier;
            SELF.ArriveCarrier              := RIGHT.Carrier;
            SELF.ArriveShareCarrier         := RIGHT.CodeShareCarrier;
            SELF.InitialDepartStationCode   := LEFT.DepartStationCode;
            SELF.FlightOneArriveTime        := (UNSIGNED)LEFT.ArriveTimeAircraft[1..2]*60+(UNSIGNED)LEFT.ArriveTimeAircraft[3..4];
            SELF.FlightTwoDepartTime        := (UNSIGNED)RIGHT.DepartTimeAircraft[1..2]*60+(UNSIGNED)RIGHT.DepartTimeAircraft[3..4];
            SELF.FlightDifference           := ((UNSIGNED)RIGHT.DepartTimeAircraft[1..2]*60+(UNSIGNED)RIGHT.DepartTimeAircraft[3..4]) - ((UNSIGNED)LEFT.ArriveTimeAircraft[1..2]*60+(UNSIGNED)LEFT.ArriveTimeAircraft[3..4]);
            SELF.FinalArriveStationCode     := RIGHT.ArriveStationCode;
            SELF.AUSArriveStationCode       := LEFT.ArriveStationCode;
            SELF.BMIDepartStationCode       := RIGHT.DepartStationCode;
            SELF.FlightOneDuration          := LEFT.FlightDurationLessLayover+LEFT.LayoverTime;
            SELF.FlightTwoDuration          := RIGHT.FlightDurationLessLayover+LEFT.LayoverTime;
            SELF.ArriveSectorizedID         := RIGHT.SectorizedId;    
            SELF.DepartSectorizedID         := LEFT.SectorizedID;
            SELF := LEFT; 
            SELF := RIGHT;
            SELF := [];
));

FinalRec := RECORD
    BOOLEAN YES;
END;

OUTPUT(AppropriateConnectingFlights, NAMED('MarchAustin_MarchBMI'));
ConnectingFlightsTimeConstraint := AppropriateConnectingFlights(FlightDifference BETWEEN 60 AND 120);           // 216 Total
OUTPUT(CHOOSEN(ConnectingFlightsTimeConstraint, 216), NAMED('DedupedFlights'));      

BMItoORD := MarchFlights(DepartStationCode = 'BMI' AND ArriveStationCode = 'ORD' AND DepartTimeAircraft <= '100000.000');

AUS_BMI_ORD := JOIN(ConnectingFlightsTimeConstraint , BMItoORD, 
    LEFT.BMIDepartStationCode = RIGHT.DepartStationCode, // Check to make sure that the days match up alright and that should be it
    TRANSFORM(FinalRec,
        SELF := [];
    ),INNER,LOCAL);

OUTPUT(AUS_BMI_ORD, NAMED('AllPossibleFlights'));
//Find the Minimum Flight Times and Output the Dataset
