IMPORT $.getCars;

// Create Set of colors
SET OF STRING dark_colors := ['gray', 'black', 'charcoal', 'brown', 'shadow black', 'super black'];

SET OF STRING invalid_color := ['color:', 'no_color'];

// Function versions of the inline tranform items
STRING getName(STRING L1, STRING L2) := FUNCTION
  new_name := L1 + ' ' + L2;
  RETURN new_name;
END;

BOOLEAN getExp(INTEGER L1, INTEGER L2) := FUNCTION
  RETURN IF (L1 >= 10000 AND L2 <= 2012, TRUE, FALSE);
END;

STRING color_Type(STRING LColor) := FUNCTION
  new_color := MAP (        LColor IN invalid_color     => 'Invalid Entry',
                            LColor IN dark_colors      => 'Dark',
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

newRecSet inline_carTS(getCars.Cars_Rec L) := TRANSFORM
    SELF.name       := L.brand + ' ' + L.model;
    SELF.Old_Exp    := IF (L.price >= 10000 AND L.year <= 2012, TRUE, FALSE);
    SELF.colorType := MAP ( L.color IN invalid_color     => 'Invalid Entry',
                            L.color IN dark_colors       => 'Dark',
                            'Light'
                            );
    SELF            := L;
    SELF            := [];
END;

standalone_carDS := PROJECT(getCars.Cars_DS, 
TRANSFORM(newRecSet,
SELF.name       := getName(LEFT.brand, LEFT.model);
SELF.Old_Exp    := getExp(LEFT.price, LEFT.year);
SELF.colorType  := color_type(LEFT.color);
SELF        := LEFT; 
SELF        := [];
));

inline_newCarDS := PROJECT(getCars.Cars_DS, 
                    inline_carTS(LEFT));

OUTPUT(inline_newCarDS, NAMED('TransformedCarDS'));
OUTPUT(standalone_carDS, NAMED('StandaloneDS'));