IMPORT $.getEmp;
// getEmp record = getEmp
// getEmp dS = empDS
EmpOutRec := RECORD
    UNSIGNED personID;
    STRING fullName;
    BOOLEAN manager;
    STRING5 empBand;
    BOOLEAN isPromoting;
END;

EmpOutRec empTS(getEmp.empLayout L) := TRANSFORM
    SELF.fullName   := L.firstName + ' ' + L.lastName;
    SELF.manager    := IF(L.empGroupNum IN [600, 700, 800], TRUE, FALSE);
    SELF.empBand    := IF(L.empGroupNum IN [500, 600, 700 ,800] AND L.avgHouseIncome >= 80000, 'Upper', 'Lower');
    SELF            := L;
    SELF            := [];
END;

newEmpDS := PROJECT(getEmp.empDS,
                    empTS(LEFT));

OUTPUT(newEmpDS, NAMED('TransformedDS'));