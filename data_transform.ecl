IMPORT $.getCars;

// Create Set of colors
SET OF STRING dark_colors := ['gray', 'black', 'charcoal', 'brown', 'shadow black', 'super black'];

SET OF STRING invalid_color := ['color:', 'no_color'];

// Function versions of the inline tranform items
STRING getName(DATASET(getCars.Cars_Rec) L) := FUNCTION
  new_name := L.brand + ' ' + L.model;
  RETURN new_name;
END;

BOOLEAN getExp(DATASET(getCars.Cars_Rec) L) := FUNCTION
  RETURN IF (L.price >= 10000 AND L.year <= 2012, TRUE, FALSE);
END;

STRING color_Type(DATASET(getCars.Cars_Rec) L) := FUNCTION
  new_color := MAP (        L.color IN invalid_color     => 'Invalid Entry',
                            L.color IN dark_colors      => 'Dark',
                            'Light'
                            );
  RETURN new_color;
END;

newRecSet := RECORD
    STRING name;
    STRING state;
    BOOLEAN Old_Exp;
    STRING colorType;
END;

newRecSet carTS(getCars.Cars_Rec L) := TRANSFORM
    SELF.name       := L.brand + ' ' + L.model;
    SELF.Old_Exp    := IF (L.price >= 10000 AND L.year <= 2012, TRUE, FALSE);
    SELF.colorType := MAP ( L.color IN invalid_color     => 'Invalid Entry',
                            L.color IN dark_colors      => 'Dark',
                            'Light'
                            );
    SELF            := L;
    SELF            := [];
END;

newCarDS := PROJECT(getCars.Cars_DS, 
                    carTS(LEFT));

OUTPUT(newCarDS, NAMED('TransformedCarDS'));