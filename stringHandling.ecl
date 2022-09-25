IMPORT $.getCars;
IMPORT STD;

stringRec := RECORD
    INTEGER ID;
    STRING carInfo;
    STRING pricePercentage;
    STRING funColors;
    STRING newState;
    STRING newCondition;
    STRING newTitleStatus;
END;

stringRec stringTS(getCars.Cars_Rec L, INTEGER C) := TRANSFORM
    SELF.ID                  := C;
    SELF.carInfo             := L.brand + '_' + L.model;
    SELF.pricePercentage     := (STRING)(L.price / getCars.avePrice) + '%';
    SELF.funColors           := STD.Str.FindReplace(STD.Str.FindReplace(STD.Str.ToUpperCase(L.color), 'A', '@'), 'E', '8');
    SELF.newState            := STD.Str.Reverse(STD.Str.ToTitleCase(L.state));
    SELF.newCondition        := MAP(STD.Str.Contains(L.condition, 'hours', TRUE)    => 'Less Than a Day',
                                STD.Str.Contains(L.condition, 'days', TRUE)         => 'Days after Days',
                                'Unknown Condition');
    SELF.newTitleStatus      := STD.Str.ToUpperCase(STD.Str.FindReplace(L.title_status, ' ', ' *** '));
    SELF                := L;
    SELF                := [];
END;

stringDS := PROJECT(getCars.Cars_DS, stringTS(LEFT, COUNTER));

OUTPUT(CHOOSEN(stringDS, 150, 100), NAMED('funCars'));

BOOLEAN checkUnknown(DATASET(stringRec) DS) := FUNCTION
    RETURN COUNT(DS(newCondition = 'Unknown Condition')) > 0;
END;

checkUnknown(stringDS);

OUTPUT(COUNT(stringDS(funColors = 'OR@NG8')), NAMED('OrangeColor'));