IMPORT $;
IMPORT STD;
/*
1. Find the average distance each carrier flies out of each airport by day of week
2. How many carriers leave a station?
3. How many days each carrier operation per flight number?
4. Write 2 additional data aggreation
*/

Prob_One := TABLE($.getFlights.gsecData,
                    {
                        Carrier,
                        AverageFlightDistance := ROUND(AVE(GROUP, FlightDistance),2);
                    }, Carrier);

OUTPUT(Prob_One, NAMED('AveDistanceByCarrier'));

Prob_Two := TABLE($.getFlights.gsecData,
                    {
                        CountOfLeavingCarriers := COUNT($.getFlights.gsecData(DepartStationCode != ArriveStationCode));
                    });

OUTPUT(Prob_Two, NAMED('CountOfLeavingCarriers'))