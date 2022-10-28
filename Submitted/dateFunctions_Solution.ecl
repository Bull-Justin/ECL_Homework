IMPORT $.getStoreSale;
IMPORT STD;

getStoreSale.SalesDS;

//NotProfitable: If there are more than 5 days from order data and shipping date and profit is less than $200
//What is the total of NotProfitable?
NoProfit := getStoreSale.SalesDS(STD.Date.DaysBetween(STD.Date.FromStringToDate(getStoreSale.salesDS.OrderDate, '%m/%d/%Y'), 
                                                        STD.Date.FromStringToDate(getStoreSale.salesDS.ShipDate, '%m/%d/%Y')) > 5 
                                                        AND Profit < 200);
OUTPUT(NoProfit, NAMED('NoProfit'));
OUTPUT(COUNT(NoProfit), NAMED('Total_NoProfit'));

lowProfitRec := RECORD
    STRING OrderID;
    STD.Date.date_t OrderDate;
    STD.Date.date_t ShipDate;
    REAL Profit;
END;

ProfitDS := PROJECT(getStoreSale.salesDS, TRANSFORM(lowProfitRec,
                           SELF.OrderID := LEFT.OrderId,
                           SELF.OrderDate := STD.Date.FromStringToDate(LEFT.OrderDate, '%m/%d/%Y'),
                           SELF.ShipDate := STD.Date.FromStringToDate(LEFT.ShipDate, '%m/%d/%Y'),
                           SELF.Profit := LEFT.Profit)
                       );

//LowProfit: If order was placed between Dec15, and Dec 31 and was shipped before Jan15 next year and profit is over $250
LowProfit := ProfitDS((STD.Date.Month(OrderDate) = 12
                                       AND STD.Date.Day(OrderDate) BETWEEN 15 AND 31)
                                       AND ((STD.Date.Month(ShipDate) = 1 AND STD.Date.Day(ShipDate) < 15)
                                             OR (STD.Date.Month(ShipDate) = 12
                                                  AND (STD.Date.Year(ShipDate) = STD.Date.Year(OrderDate)
                                                       OR STD.Date.Year(ShipDate) - STD.Date.Year(OrderDate) = 1)
                                                  AND STD.Date.Day(ShipDate) >= STD.Date.Day(OrderDate)))
  																		 AND Profit > 250);

OUTPUT(LowProfit, NAMED('LowProfit'));
OUTPUT(COUNT(LowProfit), NAMED('LowProfitCount'));

//LeapYear: Capture all leap years by orderdates. Result should look like: 2016, 2020,... 
GetLeapYears := ProfitDS(STD.Date.IsDateLeapYear((OrderDate)));
dedupLeaps   := DEDUP(GetLeapYears, STD.Date.Year((INTEGER)OrderDate));
LeapYears    := SET(dedupLeaps, (STRING)OrderDate[1..4]);

OUTPUT(LeapYears, NAMED('LeapYears'));