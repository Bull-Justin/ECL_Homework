IMPORT $.getCars;

luckyNumber(STRING name, INTEGER numOne, INTEGER numTwo) := FUNCTION
  RETURN OUTPUT('Hello ' + name + ' welcome to this function, ' + numOne + ' is your lucky number');
END;
luckyNumber('Justin', 1, 2);


GetMaxPrice(DATASET(getCars.Cars_Rec) DS, STRING name) := FUNCTION
  RETURN OUTPUT('My name is ' + name + ' and max price is: ' + MAX(DS, price));
END;

GetMaxPrice(getCars.Cars_DS, 'Justin');