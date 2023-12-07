import 'dart:io';
import 'dart:math';

import 'package:advent_2023/aoc_toolbox.dart';
import 'package:test/test.dart';

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
  test('D5:P1 seeds are correct', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    var seeds = getAllNumerics(puzzleInput[0]);
    expect(seeds, [79, 14, 55, 13]);
  });

  test('D5:P1 all seed map names correct', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    // Reduce to just the 'maps'
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);

    List<String> maps = [];

    for (var x = 0; x < puzzleInput.length; x++) {
      var seedMap =
          RegExp(r'(\S+) map:').firstMatch(puzzleInput[x])?.group(1) ?? '';
      if (seedMap != '') {
        maps.add(
            RegExp(r'(\S+) map:').firstMatch(puzzleInput[x])?.group(1) ?? '');
      }
    }

    expect(maps, [
      'seed-to-soil',
      'soil-to-fertilizer',
      'fertilizer-to-water',
      'water-to-light',
      'light-to-temperature',
      'temperature-to-humidity',
      'humidity-to-location'
    ]);
  });

  test('D5:P1 get numbers', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    // Reduce to just the 'maps'
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);

    expect(
        getDataAsMappedRecords(puzzleInput),
        equals({
          'seed-to-soil': [(50, 98, 2), (52, 50, 48)],
          'soil-to-fertilizer': [
            (0, 15, 37),
            (37, 52, 2),
            (39, 0, 15),
          ],
          'fertilizer-to-water': [
            (49, 53, 8),
            (0, 11, 42),
            (42, 0, 7),
            (57, 7, 4),
          ],
          'water-to-light': [
            (88, 18, 7),
            (18, 25, 70),
          ],
          'light-to-temperature': [(45, 77, 23), (81, 45, 19), (68, 64, 13)],
          'temperature-to-humidity': [
            (0, 69, 1),
            (1, 0, 69),
          ],
          'humidity-to-location': [
            (60, 56, 37),
            (56, 93, 4),
          ]
        }));

    // expect(mapRecords, [
    //   'seed-to-soil': [(50, 98,  2)],
    //   'soil-to-fertilizer',
    //   'fertilizer-to-water',
    //   'water-to-light',
    //   'light-to-temperature',
    //   'temperature-to-humidity',
    //   'humidity-to-location'
    // ]);
  });

  // how do i load all these in
  // break it on new lines and
  //

  test('D5:P1 seed to soil test', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    List<int> seeds = getAllNumerics(puzzleInput[0]);
    for (var seed in seeds) {
      // 79 should goto soil 81
    }

    // Reduce to just the 'maps'
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);
    var map = getDataAsMappedRecords(puzzleInput);

    // var expandedMap

// 50 98 2
    map.forEach((seedName, seedMaps) {
      List<int> totalDestinationRange = [];
      List<int> totalSourceRange = [];

      print(seedName);
      for ((int, int, int) seedMap in seedMaps) {
        totalDestinationRange.addAll(getRange(seedMap.$1, seedMap.$3));
        totalSourceRange.addAll(getRange(seedMap.$2, seedMap.$3));
      }
      (List<int>, List<int>) seedMapFinal =
          (totalSourceRange, totalDestinationRange);
      print(mooseTest(seedMapFinal, 13));
      // really we want to combine these records into a megaThor!
      // var megaThor =
    });
  });

  test('D5:P1 seed to soil test', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    List<int> seeds = getAllNumerics(puzzleInput[0]);
    for (var seed in seeds) {
      // 79 should goto soil 81
    }

    // Reduce to just the 'maps'
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);
    var map = getDataAsMappedRecords(puzzleInput);

    // var expandedMap
    map.forEach((seedName, seedMaps) {
      List<int> totalDestinationRange = [];
      List<int> totalSourceRange = [];

      print(seedName);
      for ((int, int, int) seedMap in seedMaps) {
        totalDestinationRange.addAll(getRange(seedMap.$1, seedMap.$3));
        totalSourceRange.addAll(getRange(seedMap.$2, seedMap.$3));
      }
      (List<int>, List<int>) seedMapFinal =
          (totalSourceRange, totalDestinationRange);
      print(mooseTest(seedMapFinal, 13));
      // really we want to combine these records into a megaThor!
      // var megaThor =
    });
  });
  test('D5:Sample Test', () {
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    List<int> seeds = getAllNumerics(puzzleInput[0]);
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);
    var structuredData = getDataAsMappedRecords(puzzleInput);
    List<int> total = [];

    for (int seed in seeds) {
      var start = seed;
      structuredData.forEach((seedName, seedMaps) {
        List<int> totalDestinationRange = [];
        List<int> totalSourceRange = [];

        // These lines were too unperformant for large numbers
        for ((int, int, int) seedMap in seedMaps) {
          int? virtualDestIndex =
              findIndexInVirtualList(start, seedMap.$1, seedMap.$3);
          int? virtualSourceIndex =
              findIndexInVirtualList(start, seedMap.$2, seedMap.$3) ?? 0;
          // print(virtualDestIndex);
          print(virtualSourceIndex);
          var solution = virtualSourceIndex + seedMap.$3;
          print('solution is apparently $solution');
          // now convert to destination somehow
          totalDestinationRange.addAll(getRange(seedMap.$1, seedMap.$3));
          totalSourceRange.addAll(getRange(seedMap.$2, seedMap.$3));
        }
        (List<int>, List<int>) seedMapFinal =
            (totalSourceRange, totalDestinationRange);
        // end of unperformant

        start = (mooseTest(seedMapFinal, start));

        // all moose test is doing is trying to find something
        // surely we can do some calculations rather than
        // try to make this range manually
        // so we are searching for: start in this scope
        // which is just the seed and we can leave it as it is
        //
        //
      });
      total.add(start);
      print(start);
    }
    print(total);
    int minValue = total.reduce((a, b) => a < b ? a : b);
    print('Lowest value: $minValue');
  });

  // ****************************************
  // ****************************************
  // ****************************************
  // ****************************************
  // ****************************************
  // ****************************************

  test('D5:Part One Performant Solution', () {
    // The key here is NOT to have to build the List<ints> else
    // the script will blow up. But my tired brain cant see what
    // is probably an obvious solution so going back to step one.
    const String filename = 'data/dayfive-sample.txt';
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
  });

  test('D5:Part Two Performant Solution', () {
    // The key here is NOT to have to build the List<ints> else
    // the script will blow up. But my tired brain cant see what
    // is probably an obvious solution so going back to step one.
    const String filename = 'data/dayfive-sample.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    List<int> seeds = getAllNumerics(puzzleInput[0]);
    // So the seeds are now something that we want tp explode
    expect(seeds.length % 2, 0);

    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);
    var structuredData = getDataAsMappedRecords(puzzleInput);
    List<int> total = [];
    int minValue = 0;
    for (var x = 0; x < seeds.length; x += 2) {
      int start = seeds[x];
      int end = seeds[x + 1];

      // List<int> newSeedNumberRange = getRange(start, end);

      for (int seed = start; seed < start + end; seed++) {
        // for (int seed in newSeedNumberRange) {
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
        // total.add(tracker);
        if (minValue == 0 || tracker < minValue) {
          minValue = tracker;
        }
        // mayb
      }
      // int minValue = total.reduce((a, b) => a < b ? a : b);
      print(minValue);
    }
  });

  test('D5:Part One done nicer', () {
    int? searchMap(int needle, List<(int, int, int)> haystack) {
      bool continueSearch = true;
      for (var loop = 0; loop < haystack.length; loop++) {
        if (continueSearch == false) break;
        if (needle >= haystack[loop].$2) {
          // dont make the second calculation needlessly
          if (needle <= haystack[loop].$2 + haystack[loop].$3) {
            continueSearch = false;
            // will need to calculate difference here within scope of map
            var difference = haystack[loop].$1 - haystack[loop].$2; // 2
            return needle + difference;
          }
        }
      }
      return needle;
    }

    const String filename = 'data/dayfive.txt';
    List<String> puzzleInput = File(filename).readAsLinesSync();
    List<int> seeds = getAllNumerics(puzzleInput[0]);
    // expect(seeds.length % 2, 0);
    puzzleInput.removeAt(0);
    puzzleInput.removeAt(0);
    var structuredData = getDataAsMappedRecords(puzzleInput);

    List<int> possibles = [];
    for (var seed in seeds) {
      var tracker = seed;
      structuredData.forEach((seedName, seedMaps) {
        var temp = tracker;
        tracker = searchMap(tracker, seedMaps) ?? -1;
        print('$temp --> $seedName --> $tracker');
      });
      possibles.add(tracker);
    }
    print(possibles.reduce(min));
    return possibles.reduce(min);

    // now try part two
  });

  test('D5:Part Two Reverse ', () {
    int? searchMap(int needle, List<(int, int, int)> haystack) {
      bool continueSearch = true;
      for (var loop = 0; loop < haystack.length; loop++) {
        if (continueSearch == false) break;
        if (needle >= haystack[loop].$2) {
          // dont make the second calculation needlessly
          if (needle <= haystack[loop].$2 + haystack[loop].$3) {
            continueSearch = false;
            // will need to calculate difference here within scope of map
            var difference = haystack[loop].$1 - haystack[loop].$2; // 2
            return needle + difference;
          }
        }
      }
      return needle;
    }

    const String filename = 'data/dayfive.txt';
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
  });
}
