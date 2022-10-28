IMPORT STD;


studentRec := RECORD
  INTEGER studentID;
	STRING  name;
	STRING  zipCode;
  INTEGER age;
  STRING  major;
  BOOLEAN isGraduated;
END;

studentDS := DATASET([{100, 'Zoro',  30330, 26, 'History', TRUE}, {409, 'Dan', 40001, 26, 'Nursing', FALSE},
                     {300, 'Sarah', 30000, 25, 'Art', FALSE}, {800, 'Sandy', 30339, 20, 'Math', TRUE},
                     {202, 'Alan', 40001, 33, 'Math', TRUE}, {604, 'Danny', 40001, 18, 'N/A', FALSE},
                     {305, 'Liz',  30330, 22, 'Chem', TRUE}, {400, 'Matt', 30005, 22, 'nursing', TRUE}],
                    studentRec);

majorRec := RECORD
  STRING  majorID;
	STRING  majorName;
	INTEGER numOfYears;
  STRING  department;
END;

majorDS := DATASET([{'M101', 'Dentist', 5, 'medical'}, {'M102', 'Nursing', 4, 'Medical'}, {'M201', 'Surgeon', 12, 'Medical'},
                   {'S101', 'Math', 4, 'Science'}, {'S333', 'Computer', 4, 'Science'}, {'A101', 'Art', 3, 'Art'},
                   {'A102', 'Digital Art', 3, 'Art'}],
                   majorRec);
  
addressRec := RECORD
  STRING city;
  STRING2 state;
  STRING5 zipCode;
END;

addrDS := DATASET([{'Atlanta', 'GA', '30330'}, {'atlanta', 'GA', '30331'}, {'Newyork', 'NY', '40001'},
                   {'Los A', 'CA', '50001'}, {'Dallas', 'Texas', '30000'}, {'Boston', 'MA', '60067'},
                   {'Tampa', 'FL', '30044'}, {'smyrna', 'GA', '30330'}],
                  addressRec);

OUTPUT(studentDS, NAMED('studentDS'));
OUTPUT(majorDS, NAMED('majorDS'));
OUTPUT(addrDS, NAMED('addrDS'));

//Display all students that have a major defined in majorDS
getMajorRec := RECORD
  STRING name;
  STRING major;
	STRING yearsTotal;
  STRING department;
END;

getMajor := JOIN(studentDS, majorDS,
                 STD.Str.ToUpperCase(LEFT.major) = STD.Str.ToUpperCase(RIGHT.majorName),
                 TRANSFORM(getMajorRec,
                           SELF.yearsTotal := (STRING)RIGHT.numOfYears;
                           SELF := LEFT;
                           SELF := RIGHT));
OUTPUT(getMajor, NAMED('getMajor'));

//Test it
OUTPUT(COUNT(studentDS(major = 'nursing')) = COUNT(getMajor(major = 'nursing')), NAMED('Test_getMajor'));


//Display all students that DON'T have a major defined in majorDS
MajorNotDefined := JOIN(studentDS, majorDS,
                 STD.Str.ToUpperCase(LEFT.major) = STD.Str.ToUpperCase(RIGHT.majorName),
                 TRANSFORM(getMajorRec,
                           SELF.yearsTotal := (STRING)RIGHT.numOfYears;
                           SELF := LEFT;
                           SELF := RIGHT),
                       LEFT ONLY);
OUTPUT(MajorNotDefined, NAMED('MajorNotDefined'));

//Test it
OUTPUT(majorDS(majorName = 'history'), NAMED('Test_MajorNotDefined'));


//Display all graduated students and show if they have a city available
graduated := studentDS(isGraduated);
OUTPUT(graduated, NAMED('graduated'));

livingRec := RECORD
  STRING studentName;
  STRING city;
	STRING state;
  STRING zip;
END;

getCity := JOIN(graduated, addrDS,
                LEFT.zipCode = RIGHT.zipcode,
                TRANSFORM(livingRec,
                          SELF.studentName := LEFT.name,
                          SELF.zip := LEFT.zipCode;
                          SELF := RIGHT),
                LEFT OUTER);

OUTPUT(getCity, NAMED('getCity'));

//display all students with all fields in studentDS with the major department and thier state, and city
allStudentRec := RECORD
 // INTEGER studentID;
//	STRING  name;
  STRING city;
  STRING2 state;
  STRING5 zipCode;
  STRING  department;
END;

getdepartment := JOIN(studentDS, majorDS,
			                 STD.Str.ToUpperCase(LEFT.major) = STD.Str.ToUpperCase(RIGHT.majorName),
			                 TRANSFORM(allStudentRec,
                                 SELF := LEFT;
                                 SELF := RIGHT;
                                SELF := []),
                      LEFT OUTER);

OUTPUT(getdepartment, NAMED('getdepartment'));

getAll := JOIN(getdepartment, addrDS,
               LEFT.zipCode = RIGHT.zipCode,
               TRANSFORM(allStudentRec,
                                 SELF := RIGHT;
                                 SELF := LEFT),
                LEFT OUTER);

getAll;
//OUTPUT(DEDUP(getAll, studentid, name, zipCode), NAMED('getAll'));