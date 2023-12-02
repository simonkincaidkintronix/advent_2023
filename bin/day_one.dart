import 'dart:io';

int transformTextToInt(String word) {
  var moo = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
  ];
  // print('attempting transform $word');
  var x = moo.indexWhere((element) => element == word);
  // print('transformed trying $x + 1');
  return x + 1;
  // return moo.indexWhere((element) => element == word);
}

// Technically this indexAll function was generated
// byChatGPT when i realised there's no easy way to
// continue on from an indexOf query
List<int> indexAll(String str, Pattern pattern) {
  List<int> indices = [];
  int index = str.indexOf(pattern);
  while (index != -1) {
    indices.add(index);
    if (index + 1 < str.length) {
      index = str.indexOf(pattern, index + 1);
    } else {
      break;
    }
  }
  return indices;
}

void main(List<String> arguments) {
  RegExp regExp = RegExp(r'\d');

  var number_words = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
  ];

  const String filename = 'lib/data/day_one.txt';
  final file = File(filename).readAsLinesSync();
  int total = 0;

  file.forEach((String line) {
    List<int> lineIndexesOfNumerics = [];

    number_words.forEach((String number) {
      List<int> indexes = indexAll(line, number);
      lineIndexesOfNumerics.addAll(indexes);
    });

    if (line.indexOf(regExp) != -1) {
      lineIndexesOfNumerics.add(line.indexOf(regExp));
    }

    if (line.lastIndexOf(regExp) != -1) {
      lineIndexesOfNumerics.add(line.lastIndexOf(regExp));
    }

    // line

    // lineIndexesOfNumerics.add(line.lastIndexOf(regExp));

    // Some cleaning ...

    lineIndexesOfNumerics.sort();

    // Get the first and last indexes that we have found

    var firstIndex = lineIndexesOfNumerics.first;
    var lastIndex = lineIndexesOfNumerics.last;

    // ok up to here

    if (firstIndex == lastIndex) {
      // This means that we have only one digit in the actual string
      // but we count both of them.
      // they are pointing to the same one so we need to find the value
      // lets still do a tryParse

      int? firstNumeric = int.tryParse(line[firstIndex]);
      // TODO Add word check
      if (firstNumeric == null) {
        number_words.forEach((String day) {
          if (line.startsWith(day, firstIndex)) {
            var x = transformTextToInt(day);
            total += int.tryParse([x, x].join()) ?? 0;
            // total += transformTextToInt(day);
          }
        });
      } else {
        if (line == '1v') {
          print('stop');
        }
        var temp = int.tryParse([firstNumeric, firstNumeric].join()) ?? 0;
        total += temp;
        // total += firstNumeric;
        print('*Line $line complete. Adds up to $temp');
      }
    } else {
      // we have two different indexes
      int? firstNumeric = int.tryParse(line[firstIndex]);
      int? secondNumeric = int.tryParse(line[lastIndex]);

      if (firstNumeric == null) {
        number_words.forEach((String day) {
          if (line.startsWith(day, firstIndex)) {
            firstNumeric = transformTextToInt(day);
          }
        });
      }
      if (secondNumeric == null) {
        number_words.forEach((String day) {
          if (line.startsWith(day, lastIndex)) {
            secondNumeric = transformTextToInt(day);
          }
        });
      }
      var temp = int.tryParse([firstNumeric, secondNumeric].join()) ?? 0;
      if (temp == 0) print('found 0');
      total += temp;
      print('!Line $line complete. Adds up to $temp');
    }
  }); // end main foreach

  // print('Finished, I think the total for part one is $total');
  print('Finished, I think the total for part two is $total');
}


// TODO is there a better way of checking these all out ? 

