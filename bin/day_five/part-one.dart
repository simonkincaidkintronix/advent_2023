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
  const String filename = 'data/dayfive.txt';
  List<String> puzzleInput = File(filename).readAsLinesSync();
  List<int> seeds = getAllNumerics(puzzleInput[0]);
  puzzleInput.removeAt(0);
  puzzleInput.removeAt(0);
  var structuredData = getDataAsMappedRecords(puzzleInput);
  List<int> total = [];
  for (int seed in seeds) {
    int tracker = seed;

    structuredData.forEach((seedName, seedMaps) {
      print('[$tracker] --> $seedName');
      int indexInRange = -1;
      int indexValue = 0;

      for ((int, int, int) seedMap in seedMaps) {
        var find = findIndexInVirtualList(tracker, seedMap.$2, seedMap.$3);
        if (find is int) {
          indexInRange = find;
          indexValue = seedMap.$1;
        }
      }

      // change tracker so that it begins the next conversion with this new value
      tracker = (indexInRange == -1) ? tracker : indexInRange + indexValue;
      // tracker = internalRecordTracker;
      // total.add(internalRecordTracker);
    });
    // Seed has been passed through all the way to location
    print('Seed finished with $tracker');
    total.add(tracker);
  }

  int minValue = total.reduce((a, b) => a < b ? a : b);
  print(minValue);
}
