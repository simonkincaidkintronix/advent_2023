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
        // var rowNow = getBorderLocationsForNumeric(numeric, row - 1);
        var rowNow = [(row, numeric.start - 1), (row, numeric.end)];
        var rowBelow = getBorderLocationsForNumeric(numeric, row + 1);
        var joined = [...rowAbove, ...rowNow, ...rowBelow];
        bool hasNeighbouringSymbol = false;
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
    print(puzzleInputProcessed);
  });
}
