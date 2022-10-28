
EXPORT getStoreSale := MODULE

    EXPORT StoreSaleRec := RECORD

        INTEGER RowID;
        STRING  OrderID;
        STRING  OrderDate;
        STRING  ShipDate;
        STRING  ShipMode;
        STRING  CustomerID;
        STRING  CustomerName;
        STRING  Segment;
        STRING  City;
        STRING  State;
        STRING  Country;
        STRING5 PostalCode;
        STRING  Market;
        STRING  Region;
        STRING  ProductID;
        STRING  Category;
        STRING  SubCategory;
        STRING  ProductName;
        REAL    Sales;
        INTEGER Quantity;
        REAL    Discount;
        REAL    Profit;
        DECIMAL5_2 ShippingCost;
        STRING  OrderPriority;

    END;


    EXPORT SalesDS := DATASET('~raw::superstore::thor', StoreSaleRec, CSV(HEADING(1)));

END;