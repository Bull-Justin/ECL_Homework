// DS 1
studentRec := RECORD
    INTEGER studentID;
    STRING name;
    STRING zipCode;
    INTEGER age;
    STRING major;
    BOOLEAN isGraduated;
END;
studentDS := DATASET([{100, 'Zoro', 30330, 26, 'History', TRUE}, {409, 'Dan', 40001, 26, 'Nursing', FALSE},
                        {300, 'Sarah', 30000, 25, 'Art', FALSE}, {800, 'Sandy', 30339, 20, 'Math', TRUE},
                        {202, 'Alan', 40001, 33, 'Math', TRUE},  {604, 'Danny', 40001, 18, 'N/A', FALSE},
                        {305, 'Liz', 30330, 22, 'Chem', TRUE},   {400, 'Matt', 30005, 22, 'nursing', TRUE}],
studentRec);

// DS 2
majorRec := RECORD
    STRING majorID;
    STRING majorName;
    INTEGER numOfYears;
    STRING department;
END;
majorDS := DATASET([{'M101', 'Dentist', 5, 'medical'},  {'M102', 'Nursing', 4, 'Medical'},  
                    {'M201', 'Surgeon', 12, 'Medical'},
                    {'S101', 'Math', 4, 'Science'},     {'S333', 'Computer', 4, 'Science'}, 
                    {'A101', 'Art', 3, 'Art'},          {'A102', 'Digital Art', 3, 'Art'}],
majorRec);

// DS 3
addressRec := RECORD
    STRING city;
    STRING2 state;
    STRING5 zipCode;
END;

addrDS := DATASET([ {'Atlanta', 'GA', '30330'},{'atlanta', 'GA', '30331'},   {'Newyork', 'NY', '40001'},
                    {'Los A', 'CA', '50001'},  {'Dallas', 'Texas', '30000'}, {'Boston', 'MA', '60067'},
                    {'Tampa', 'FL', '30044'},  {'smyrna', 'GA', '30330'}],
addressRec);

/*
 * 4 - Display all students that have a major defined in majorDS
 * 5 - Display all students that DON'T have a major defined in majorDS
 * 6 - Display all graduated students and show if they have a city available
 * 7 - Display all students with all fields in studentDS with the major department, their state, and their city – allStudentsRec is the result layout
*/

// Problem 4 - major defined in majorDS, assuming you had the 'nursing' and 'Nursing' different, didn't check for other case to leave them separate
yesMajor := JOIN(studentDS, majorDS, 
                LEFT.major = RIGHT.majorName,
                TRANSFORM(studentRec,
                            SELF := LEFT;
                            SELF := [];)
                            ); // Inner grabs the ones that match

OUTPUT(yesMajor, NAMED('StudentWMajor'));

// Problem 5, No major defined in majorDS
noMajor := JOIN(studentDS, majorDS,
                LEFT.major = RIGHT.majorName, 
                TRANSFORM(studentRec,
                            SELF := LEFT;
                            SELF := []),
                            LEFT ONLY); // Left only will grab all the left that don't match

OUTPUT(noMajor, NAMED('noMajor'));

// Problem 6 - Only graduates, and show if they have a city, show all grads even if they don't have a city

studentCityRec := RECORD
    STRING name;
    BOOLEAN cityAvailable;
END;

cityDict := DICTIONARY(addrDS, {zipCode => addrDS});

gradStudentWCity := JOIN(studentDS(isGraduated), addrDS,
                            LEFT.zipCode = RIGHT.zipCode,
                            TRANSFORM( studentCityRec,
                            SELF.cityAvailable  := IF(LEFT.zipCode IN cityDict, TRUE, FALSE),
                            SELF                := LEFT,
                            SELF                := []
                            ), LEFT OUTER); // Left outer will take all of the left, no matter if they have a match or not

OUTPUT(DEDUP(gradStudentWCity, name), NAMED('allGrads'));

// Problem 7 - Display all students with all fields in studentDS with the major department, their state, and their city – allStudentsRec is the result layout
allStudentsRec := RECORD
    INTEGER     studentID;
    STRING      name;
    STRING      zipCode;
    INTEGER     age;
    STRING      major;
    BOOLEAN     isGraduated;
    STRING      city;
    STRING2     state;
    STRING      department;
END;

allStudentJoin := JOIN( studentDS, majorDS,
                        LEFT.major = RIGHT.majorName,
                        TRANSFORM(allStudentsRec, 
                            SELF.city       := cityDict[LEFT.zipCode].city ,
                            SELF.state      := cityDict[LEFT.zipCode].state,
                            SELF.department := RIGHT.department,
                            SELF            := LEFT,
                            SELF            := RIGHT,
                            SELF            := []
                        ), LEFT OUTER);

OUTPUT(allStudentJoin, NAMED('allStuJoin'));


