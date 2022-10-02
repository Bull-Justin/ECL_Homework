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

BOOLEAN NotProfitable(order_date, ship_date, profit) := FUNCTION
    Result := IF(profit < 200 AND (ship_date - order_date ) > 5, TRUE, FALSE);
    RETURN Result;
END;


OUTPUT('temp', NAMED('temp'));