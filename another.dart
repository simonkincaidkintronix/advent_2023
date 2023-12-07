import 'dart:io';

import 'package:advent_2023/aoc_toolbox.dart';

Map<String, List<(int, int, int)>> getDataAsMappedRecords(List<String> input) {
  Map<String, List<(int, int, int)>> mapRecords = {};
  for (var x = 0; x < input.length; x++) {
    var seedName = RegExp(r'(\S+) map:').firstMatch(input[x])?.group(1) ?? '';

    // If we don't find a match, we're either on a blank line or one
    // with the numerics in. So we dont do anything. If we DO find something
    // this starts a process off.
    if (seedName != '') {
      bool check = false;
      for (var innerIndex = x + 1; check == false; innerIndex++) {
        // keep matching the following lines until we get to the next seedName

        if (innerIndex >= input.length) {
          check = true;
          break;
        }
        // three numerics seperated by whitespace
        RegExpMatch? matchSeedNumerics =
            RegExp(r'(\d+)\s(\d+)\s(\d+)').firstMatch(input[innerIndex]);

        if (matchSeedNumerics == null) {
          // We've reached the end
          check = true;
          break;
        }

        var record = (
          int.tryParse(matchSeedNumerics.group(1) ?? '') ?? 0,
          int.tryParse(matchSeedNumerics.group(2) ?? '') ?? 0,
          int.tryParse(matchSeedNumerics.group(3) ?? '') ?? 0,
        );
        if (!mapRecords.containsKey(seedName)) {
          // If not, initialize it with an empty list
          mapRecords[seedName] = [];
        }
        mapRecords[seedName]!.add(record);
      }
    }
  }
  return mapRecords;
}

void main() {
  const String filename = 'data/dayfive-sample.txt';
  List<String> puzzleInput = File(filename).readAsLinesSync();
  List<int> seeds = getAllNumerics(puzzleInput[0]);
  // expect(seeds.length % 2, 0);
  puzzleInput.removeAt(0);
  puzzleInput.removeAt(0);
  var structuredData = getDataAsMappedRecords(puzzleInput);

  int finalLocation = 1000000;
  bool foundLocation = false;

  for (finalLocation; foundLocation == false; finalLocation++) {
    List<MapEntry<String, List<(int, int, int)>>> reversedEntries =
        structuredData.entries.toList().reversed.toList();
    var tracker = finalLocation;
    for (var entry in reversedEntries) {
      // print('$tracker Key: ${entry.key}, Value: ${entry.value}');
      bool found = false;
      entry.value.forEach((element) {
        if (found == false) {
          var testResult = tracker + (element.$2 - element.$1);
          if (testResult >= element.$2 &&
              (testResult < (element.$2 + element.$3))) {
            tracker = testResult;
            // print('found $testResult in ${element.$2}');
            found = true;
          } else {
            // print('notfound');
          }
        }
        // is this in the range
      });
    }
    // check if its in a seed range
    for (var x = 0; x < seeds.length; x += 2) {
      int start = seeds[x];
      int end = seeds[x + 1];

      if (tracker >= start) {
        if (tracker <= start + end) {
          print(
              '$finalLocation Location --> Seed --> $tracker --> Found in a seed');
          foundLocation = true;
          break;
        }
      } else {
        print('$finalLocation Location Not Found');
      }
    }
  }
  // List<int> newSeedNumberRange = getRange(start, end);

  // now try part two
}
