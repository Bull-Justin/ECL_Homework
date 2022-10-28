IMPORT STD;

// 1
STRING str1 := 'Today is sunny with chance of rain.';
STRING str2 := 'This class is awesome :)';
STRING str3 := 'Can I take a break tomorrow?';

// 2
INTEGER isEqual := STD.Str.CompareIgnoreCase(str1,'Today is sunny With');
OUTPUT(isEqual, NAMED('isEqual'));

// 3 - Does str2 include 'abcjklol', not case sens, display as isIncluded
BOOLEAN isIncluded := STD.Str.Contains(str2, 'abcjklol', TRUE);
OUTPUT(isIncluded, NAMED('isIncluded'));

// 4 - Change str2 to upper case and count the words in it using space. display as wordCount
INTEGER wordCount := STD.Str.CountWords(STD.Str.ToUpperCase(str2),' ');
OUTPUT(wordCount, NAMED('wordCount'));

// 5 - does str3 contain one 'Taking', display result as isTaking
OUTPUT(STD.Str.Find(str3,'Taking', 1), NAMED('isTaking'));

// 6 - Using str3 and replace letter '1' with '@', name it replaceMe
STRING replaceMe := STD.Str.FindReplace(str3, '1', '@');

// 7 - Display 'Life is nice :)', 3 times in one line, display result as threeFun
OUTPUT(STD.Str.Repeat('Life is nice :)', 3), NAMED('threeFun'));

// 8 - Split str3 by letter 'a', display result as aSplit
OUTPUT(STD.Str.SplitWords(str3, 'a'),NAMED('aSplit'));

// 9 - Display str3 content backward
OUTPUT(STD.Str.Reverse(str3), NAMED('backward'));

// 10 - If str3 bigger than 'Did you take a break?', PRINT 'Bigger' else 'Smaller' else 'Why not!', as checkFacts
OUTPUT(MAP( STD.Str.CompareIgnoreCase(str3, 'Did you take a break?') = 1  => 'Bigger',
            STD.Str.CompareIgnoreCase(str3, 'Did you take a break?') = -1 => 'Smaller',
            'Why not!'), NAMED('checkFacts'));
