IMPORT $.getFlights;
IMPORT STD;

// Display the first 200 rows

OUTPUT(CHOOSEN(getFlights.gsecData, 200), NAMED('firstFlights'));

// Filter down to Delta (DL) flights operating in November 2019, named filteredData
/*
STRING8             EffectiveDate;   effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
STRING8             DiscontinueDate; discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
*/

filteredData := getFlights.gsecData(STD.Str.CompareIgnoreCase(Carrier, 'DL') = 0 AND
                                    EffectiveDate <= '20191131' AND DiscontinueDate >= '20191101');

OUTPUT(filteredData, NAMED('filteredData'));

// Display Flights that their DepartStationCode are in LHR or ORD and ArriveStationCode is in JFK, ATL, or ORD. Sort the result by Carrier and FlightNumber

SET OF STRING3 dptCode := ['LHD', 'ORD'];
SET OF STRING3 arrCode := ['JFK', 'ATL', 'ORD'];

codeFlights := SORT(getFlights.gsecData(DepartStationCode in dptCode AND ArriveStationCode in arrCode), Carrier, FlightNumber);
OUTPUT(codeFlights, NAMED('codeFlights'));

// Get the min FlightNumber, save and display result as minFlightNumber

INTEGER minFlightNumber := MIN(getFlights.gsecData, FlightNumber);
OUTPUT(minFlightNumber, NAMED('minFlightNumber'));

// Filter your dataset for minFlightNumber and display results as getFlightNumbers

getFlightNumbers := getFlights.gsecData(FlightNumber = minFlightNumber);
OUTPUT(getFlightNumbers, NAMED('getFlightNumbers'));

// How may rows are in getFlightNumbers?

OUTPUT(COUNT(getFlightNumbers) ,NAMED('minFlightCount'));

// Data Validation: Write 6 data validation checks. 

// When doing data validation, it is useful to addd columns to the end of the dataset and and do projections to fill them out in order to keep track of what you have found.

// Validation 1 - Checking negative intermediatestop count

IF(EXISTS(getFlights.gsecData(numberofintermediatestops < 0)), OUTPUT('Invalid Intermediate Stop Count Exists', NAMED('negInterStopCount')), 
                                                                OUTPUT('No Invalid Intermediate Stop Counts', NAMED('nonnegInterStopCount')));

// Validation 2 - Checking carrier field for empty string

IF(EXISTS(getFlights.gsecData(carrier = '')), OUTPUT('Empty Carrier Cell Exists', NAMED('invalidCarrier')), 
                                                OUTPUT('No Empty Carrier Cells', NAMED('validCarrier')));

// Validation 3 - Checking if Discontinue Date is before Effective Date

IF(EXISTS(getFlights.gsecData(discontinueDate < effectiveDate)), OUTPUT('Discontinue Date set Before Effective Date', NAMED('invalidDateCheck')),
                                                                    OUTPUT('Valid Effective and Discontinue Dates', NAMED('validDateCheck')));

// Validation 4 - Checking at least one operation date is true

IF(NOT EXISTS(getFlights.gsecData((BOOLEAN)isopmon OR (BOOLEAN)isoptue 
                                    OR (BOOLEAN)isopwed OR (BOOLEAN)isopthu 
                                    OR (BOOLEAN)isopfri OR (BOOLEAN)isopsat OR (BOOLEAN)isopsun)), 
                                    OUTPUT('Flight has no active days', NAMED('inactiveFlight')),
                                    OUTPUT('Flight has at least one active day', NAMED('activeFlight')));

// Validation 5 - Check Seat Count

IF(EXISTS(getFlights.gsecData(TotalSeats != (FirstClassSeats + BusinessClassSeats + PremiumEconomySeats + EconomyClassSeats))),
                                OUTPUT('Invalid Seat Count', NAMED('invalidSeatCountCheck')),
                                OUTPUT('Valid Seat Count', NAMED('validSeatCountCheck')));

// Validation 6 - Check for a sectorizedID

IF(EXISTS(getFlights.gsecData(NOT ISVALID(SectorizedID))), OUTPUT('Invalid sectorizedID', NAMED('invalidIDCheck')),
                                                            OUTPUT('Valid sectorizedID', NAMED('validIDCheck')));