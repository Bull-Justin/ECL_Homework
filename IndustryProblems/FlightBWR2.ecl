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
    SELF.MinutesAfterMidnight := ((UNSIGNED1)(L.DepartTimePassenger[1..2]) * 60 
                                    + ((UNSIGNED1)(L.DepartTimePassenger[3..4])));
    SELF.Weekend := IF((BOOLEAN)L.IsOpSat OR (BOOLEAN)L.IsOpSun, TRUE, FALSE);
    SELF.TotalDaysActive := STD.Date.DaysBetween(STD.Date.FromStringToDate(L.EffectiveDate, '%Y%m%d'), STD.Date.FromStringToDate(L.DiscontinueDate, '%Y%m%d')) 
                            * (L.IsOpMon + L.IsOpThu + L.IsOpTue + L.IsOpFri + L.IsOpWed + L.IsOpSat + L.IsOpSun);
    SELF.EconomySeatsOnly := IF( (L.BusinessClassSeats + L.FirstClassSeats + L.PremiumEconomySeats) = 0 , TRUE , FALSE );
    SELF := L;
    SELF := [];
END;

EnrichedDS := PROJECT(getFlights.gsecData, Flight_TF(LEFT));

OUTPUT(SAMPLE(EnrichedDS, 5, 5), NAMED('EnrichedDS'));

/*
2. Data append: Using getAirLines, append Airline_Name and airline Country to the GSEC file
 Sort result by FlightNumber and DepartStationCode
 Count your results and count the original GSEC data
 Are the total counts the same? Why?

Going to be done via Joins, Transformations, and Projections
*/


/*
3. Append serviceTypeDS from getServiceTypes to your step 2 result
 Does everything look ok to you?
 Sort result by FlightNumber and DepartStationCode and print the result

Going to be done via Joins, Transformations, and Projections
*/
