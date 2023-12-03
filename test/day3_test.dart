import 'dart:io';

import 'package:test/test.dart';

void main() {
  // List<String> puzzleInput = [
  //   r'467..114..',
  //   r'...*......',
  //   r'..35..633.',
  //   r'......#...',
  //   r'617*......',
  //   r'.....+.58.',
  //   r'..592.....',
  //   r'......755.',
  //   r'...$.*....',
  //   r'.664.598..',
  // ];
  const String filename = 'data/daythree.txt';
  final List<String> puzzleInput = File(filename).readAsLinesSync();

  // Turns out record syntax is quite useful (dart v3+)
  // https://dart.dev/language/records
  List<(int, int)> getAllNeighbours(row, col) {
    return [
      (row - 1, col), // topCent
      (row - 1, col + 1), // topRigh
      (row, col + 1), // midRigh
      (row + 1, col + 1), // bottomR
      (row + 1, col), // bottomM
      (row + 1, col - 1), // bottomL
      (row, col - 1), // midLeft
      (row - 1, col - 1) // topLeft
    ];
  }

  // This is a rubbish function would refactor if bothered
  List<(int, int)> getBorderLocationsForNumeric(Match match, int row) {
    // Make a list of records for the numerics
    // so if its '123' we will return three
    // records- one eachfor 1, 2, 3
    var locations = <(int, int)>[]; // A list of a record containing two ints
    var start = match.start - 1;
    var end = match.end;
    // cycle between start and end and make
    for (var current = start; current <= end; current++) {
      locations.add((row, current));
    }
    return locations;
  }

  bool isSymbol(row, col) {
    if (row >= 0 &&
        row < puzzleInput.length &&
        col >= 0 &&
        col < puzzleInput[row].length) {
      var content = puzzleInput[row][col];
      if ((int.tryParse(content) is! int) && (content != '.')) {
        // print('Symbol found [$content] at$row $col');
        return true;
      }
    }

    return false;
  }

  test('D3:P1: getAllNeighbours returns as expected', () {
    print(puzzleInput);
    int puzzleInputProcessed = 0;
    puzzleInput.asMap().forEach((int row, String col) {
      var searchAllNumerics = RegExp(r'(\d+)').allMatches(col);
      for (final Match numeric in searchAllNumerics) {
        // The assumption was that we wanted to 'get all neighbours'
        // but actually we want to get three sets of records
        var rowAbove = getBorderLocationsForNumeric(numeric, row - 1);
        var rowNow = [(row, numeric.start - 1), (row, numeric.end)];
        var rowBelow = getBorderLocationsForNumeric(numeric, row + 1);
        var joined = [...rowAbove, ...rowNow, ...rowBelow];
        for ((int, int) target in joined) {
          if (isSymbol(target.$1, target.$2)) {
            print(
                'Matched ${numeric.group(1)} at ${target.$1} and ${target.$2}');
            puzzleInputProcessed +=
                int.tryParse(numeric.group(1).toString()) ?? 0;
            break;
            // puzzleInputProcessed.add(value);
          }
        }
      }
    });
    print(puzzleInputProcessed); // correct at 537832
  });

  test('D3:P2: getAllNeighbours returns as expected', () {
    // List<String> puzzleInput = [
    //   r'467..114..',
    //   r'...*......',
    //   r'..35..633.',
    //   r'......#...',
    //   r'617*......',
    //   r'.....+.58.',
    //   r'..592.....',
    //   r'......755.',
    //   r'...$.*....',
    //   r'.664.598..',
    // ];
    List<(int, int)> gears = [];

    puzzleInput.asMap().forEach((int row, String col) {
      var gearSearch = RegExp(r'(\*)').allMatches(col);
      for (final Match gear in gearSearch) {
        // because its a single char its slightly easier
        gears.add((row, gear.start));
      }
      // convert matches into
    });

    print(gears);

    int total = 0;

    for ((int, int) location in gears) {
      List<int> numAdjacentNumerics = [];

      (int, int) gear = (location.$1, location.$2);

      var from = gear.$1 - 1;
      var to = gear.$1 + 1;

      for (var row = from; row <= to; row++) {
        // Check in the row above
        var numerics = RegExp(r'(\d+)').allMatches(puzzleInput[(row)]);

        (int, int, int) collisionDetectionArea =
            (gear.$2 - 1, gear.$2, gear.$2 + 1);

        numerics.forEach((element) {
          List<int> numericIndices = [];

          for (var i = element.start; i <= element.end - 1; i++) {
            numericIndices.add(i);
          }

          bool collision = numericIndices.any((index) =>
              index == collisionDetectionArea.$1 ||
              index == collisionDetectionArea.$2 ||
              index == collisionDetectionArea.$3);

          if (collision) {
            numAdjacentNumerics.add(int.tryParse(element.group(1) ?? '') ?? 0);
            print('found collision ${element.group(1)}');
          }
        });
      }
      if (numAdjacentNumerics.length == 2) {
        var multiple = numAdjacentNumerics[0] * numAdjacentNumerics[1];
        print(
            'Found a lovely gear with two adjacents at ${gear.$1},${gear.$2} that multiply to form $multiple');
        total += multiple;
      }

      // current

      // below
    }

    print(total);

    // var content = puzzleInput[row][col];

    // locations.forEach((element) {});

    // var rowAbove = getBorderLocationsForNumeric(numeric, row - 1);
    // var rowNow = [(row, numeric.start - 1), (row, numeric.end)];
    // var rowBelow = getBorderLocationsForNumeric(numeric, row + 1);
    // var joined = [...rowAbove, ...rowNow, ...rowBelow];

    // for these locations find how many numbers are around it
    // for each gear point you can
    //

    // Locate *

    // Foreach
    // Calculate container to get list of location records
    // You could see which contains a numeric
    // but at the same time you still need to work out
    // what group
    // The only thing you can do is have a long list of all location records for numerics
    // which i can do
    //

    // You could get
  });
}
