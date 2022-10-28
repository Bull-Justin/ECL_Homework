IMPORT $.getStoreSale;
IMPORT STD;

/*
 NotProfitable: If there are more than 5 days from order date and shipping date and profit
is less than $200
How many rows are NotProfitable?
LowProfit: If order was placed between Dec15, and Dec 31 and was shipped before Jan15
next year and profit is over $250
LeapYear: Capture all leap years by orderdates. Result should look like: 2016, 2020,..
*/
// Date format: 7/31/2012, M/D/Y
// Not Profitable
OUTPUT( COUNT(getStoreSale.SalesDS(Profit < 200 AND ((STD.Date.DaysBetween(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y'), STD.Date.FromStringToDate(shipDate, '%m/%d/%Y'))) > 5))),
     NAMED('NotProfitable') );

// LowProfit
OUTPUT  ( getStoreSale.SalesDS((Profit > 250) AND 
         (STD.Date.Month(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y')) = 12 AND STD.Date.Day(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y')) >= 15) AND
        (STD.Date.FromStringToDate(shipDate, '%m/%d/%Y') < (STD.Date.DateFromParts(year := STD.Date.Year(STD.Date.FromStringToDate(shipDate, '%m/%d/%Y'))+1, month := 1, day := 15)))),
        NAMED('LowProfit') );

// LeapYear
LeapYear := SET( DEDUP(getStoreSale.SalesDS(STD.Date.IsDateLeapYear(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y'))), STD.Date.Year(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y'))),STD.Date.Year(STD.Date.FromStringToDate(orderDate, '%m/%d/%Y'))); 
OUTPUT(LeapYear, NAMED('LeapYear'));
