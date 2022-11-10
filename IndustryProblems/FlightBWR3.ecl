IMPORT $;
IMPORT STD;

/*
1. Find the average distance each carrier flies out of each airport by day of week
2. How many carriers leave a station?
3. How many days each carrier operation per flight number?
4. Write 2 additional data aggreation
*/

// P1

Output_Rec := RECORD
    Distance_Mon := AVE(GROUP, $.getFlights.gsecData.FlightDistance, IsOpMon = 1);
    AverageFlightDistance := ROUND(AVE(GROUP, $.getFlights.gsecData.FlightDistance), 3);
    $.getFlights.gsecData.DepartStationCode
END;

Prob_One := TABLE($.getFlights.gsecData,
                    Output_Rec, 
                    Carrier, FlightNumber ,DepartStationCode);

OUTPUT(Prob_One, NAMED('AverageFlightDistanceByCarrierAirport'));

// P2

Prob_Two := TABLE($.getFlights.gsecData,
                    {
                        Carrier;
                        CountOfLeavingCarriers := COUNT(GROUP, ArriveStationCode != DepartStationCode);
                    },  Carrier);

OUTPUT(Prob_Two, NAMED('CountOfLeavingCarriers'));

// P3

Prob_Three := TABLE($.getFlights.gsecData,
                    {
                        Carrier;
                        FlightNumber;
                        DayCount := SUM(GROUP, STD.Date.DaysBetween(STD.Date.FromStringToDate(EffectiveDate, '%Y%m%d'), 
                                               STD.Date.FromStringToDate(DiscontinueDate, '%Y%m%d')));
                    },
                    Carrier, FlightNumber);

// OUTPUT(SAMPLE(Prob_Three, 100, 5), NAMED('SampleDays'));
OUTPUT(SAMPLE(Prob_Three, 1000, 100), NAMED('DaysPerFN'));
// OUTPUT(MAX($.getFlights.gsecData, FlightNumber), NAMED('TempMax'));

/*
Two Additional Data Agg Problems
*/

// Count of how many service type flights per Carrier

Prob_Four_One := TABLE($.getFlights.gsecData,
                    {
                        Carrier;
                        ServiceType;
                        ServiceTypeCount := COUNT(GROUP);
                    }, Carrier, ServiceType);

OUTPUT(Prob_Four_One, NAMED('ServiceTypeCount'));

// Average amount of intermediate stops per carrier

Prob_Four_Two := TABLE($.getFlights.gsecData,
                        {
                            Carrier,
                            AverageIntermediateStop := ROUND(AVE(GROUP, NumberOfIntermediateStops), 4);
                        }, Carrier);

OUTPUT(Prob_Four_Two, NAMED('AverageIntermediateStops'));