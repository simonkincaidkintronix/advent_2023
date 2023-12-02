import 'dart:io';
import 'package:test/test.dart';

Map<String, int> analyseGameRound(String round) {
  // remember double digits
  // r denotes raw string so no need for escape slashes
  // \d is any digit 0 - 9
  // () means capturing group ... you can directly access the numeric
  // (+) repeat matches whatevers in the brackets i.e. multiple digits
  // \s+ matches spaces and the plus sign indicates repeating allowed as before
  return {
    'r': int.tryParse(
            RegExp(r'(\d+)\s+red').firstMatch(round)?.group(1) ?? '') ??
        0,
    'g': int.tryParse(
            RegExp(r'(\d+)\s+green').firstMatch(round)?.group(1) ?? '') ??
        0,
    'b': int.tryParse(
            RegExp(r'(\d+)\s+blue').firstMatch(round)?.group(1) ?? '') ??
        0,
  };
}

int getGameId(String gameInput) {
  return int.tryParse(
          RegExp(r'Game\s+(\d+)').firstMatch(gameInput)?.group(1) ?? '') ??
      0;
}

List<String> getGameRounds(String gameInput) {
  String rounds = gameInput.split(':')[1];
  return rounds.split(';');
}

bool checkWithinMaximums(String gameInput, Map<String, int> maximums) {
  bool ok = true;
  getGameRounds(gameInput).forEach((round) {
    Map<String, int> x = analyseGameRound(round);
    if (x['b'] != null && x['b']! > (maximums['b'] ?? 0)) {
      ok = false;
    }
    if (x['r'] != null && x['r']! > (maximums['r'] ?? 0)) {
      ok = false;
    }
    if (x['g'] != null && x['g']! > (maximums['g'] ?? 0)) {
      ok = false;
    }
  });
  return ok;
}

void main() {
  final game1 = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green';
  final game2 = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green';
  final game3 =
      'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red';
  final game4 =
      'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red';
  final game5 = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green';

  test('day two : can analyse a game round accurately', () {
    expect(analyseGameRound('3 blue'), {'r': 0, 'b': 3, 'g': 0});
    expect(
        analyseGameRound('1 red, 2 green, 6 blue'), {'r': 1, 'b': 6, 'g': 2});
    expect(
        analyseGameRound('6 red, 1 blue, 3 green'), {'r': 6, 'b': 1, 'g': 3});
    expect(analyseGameRound(' 8 green, 6 blue, 20 red'),
        {'r': 20, 'b': 6, 'g': 8});
  });

  test('day two : can get the ID for a game accurately', () {
    expect(getGameId(game1), 1);
    expect(getGameId(game2), 5);
    expect(getGameId(game3), 3);
  });

  test('day two : can accurately work out how many rounds in each game', () {
    expect(getGameRounds(game1).length, 3);
    expect(getGameRounds(game2).length, 2);
    expect(getGameRounds(game3).length, 3);
  });
  // 12 red, 13 green, 14 blue
  test(
      'day two: can check the each round of a game does not exceed some totals',
      () {
    expect(checkWithinMaximums(game1, {'r': 4, 'g': 2, 'b': 6}), true);
    expect(checkWithinMaximums(game2, {'r': 6, 'g': 3, 'b': 2}), true);
    expect(checkWithinMaximums(game3, {'r': 20, 'g': 13, 'b': 6}), true);
  });

  test('day two : check game 1 ', () {
    expect(checkWithinMaximums(game1, {'r': 12, 'g': 13, 'b': 14}), true);
  });
  test('day two : check game 2 ', () {
    expect(checkWithinMaximums(game2, {'r': 12, 'g': 13, 'b': 14}), true);
  });
  test('day two : check game 3 ', () {
    expect(checkWithinMaximums(game3, {'r': 12, 'g': 13, 'b': 14}), false);
  });
  test('day two : check game 4 ', () {
    expect(checkWithinMaximums(game4, {'r': 12, 'g': 13, 'b': 14}), false);
  });
  test('day two : check game 5 ', () {
    expect(checkWithinMaximums(game5, {'r': 12, 'g': 13, 'b': 14}), true);
  });

  test('day two : can work out which games are possible', () {
    List<String> allGames = [
      'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
      'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
      'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
      'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
      'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'
    ];
    var maximums = {'r': 12, 'g': 13, 'b': 14};
    int sum_of_ids = 0;
    allGames.forEach((gameInput) {
      if (checkWithinMaximums(gameInput, maximums)) {
        sum_of_ids += getGameId(gameInput);
      }
    });
    expect(sum_of_ids, 8);
  });

  test('D2 : Can take the input and get correct answer', () {
    const String filename = 'instructions/day_two/day_two_input.md';
    final List<String> games = File(filename).readAsLinesSync();
    var maximums = {'r': 12, 'g': 13, 'b': 14};
    int idSum = 0;
    games.forEach((gameInput) {
      if (checkWithinMaximums(gameInput, maximums)) {
        print('$gameInput passed');
        var x = getGameId(gameInput);
        print(x);
        idSum += getGameId(gameInput);
        print(idSum);
      }
    });
    print(idSum); // got it correct
  });

  test('D2:Part Two: Can match the example ', () {
    List<String> allGames = [
      'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
      'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
      'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
      'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
      'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'
    ];

    // var minimums = {'r': 0, 'g': 0, 'b': 0};
    // you want to find the maximums in each game, by looking at each game round

    allGames.forEach((gameInput) {
      Map<String, int> max = {'r': 0, 'g': 0, 'b': 0};
      getGameRounds(gameInput).forEach((round) {
        Map<String, int> x = analyseGameRound(round);
        max['r'] =
            ((max['r'] ?? 0) > (x['r'] ?? 0)) ? max['r'] ?? 0 : x['r'] ?? 0;
        max['g'] =
            ((max['g'] ?? 0) > (x['g'] ?? 0)) ? max['g'] ?? 0 : x['g'] ?? 0;
        max['b'] =
            ((max['b'] ?? 0) > (x['b'] ?? 0)) ? max['b'] ?? 0 : x['b'] ?? 0;
      });
      var id = getGameId(gameInput);
      print('ID:$id ($gameInput) resulted in ${max.toString()}');

      var power = (max['r'] ?? 0) * (max['g'] ?? 0) * (max['b'] ?? 0);

      print('power is $power');
      // tidy up at end
    });
  });

  test('D2:Part Two: Get the answer', () {
    const String filename = 'instructions/day_two/day_two_input.md';
    final List<String> games = File(filename).readAsLinesSync();
    int totalPower = 0;
    games.forEach((gameInput) {
      Map<String, int> max = {'r': 0, 'g': 0, 'b': 0};
      getGameRounds(gameInput).forEach((round) {
        Map<String, int> x = analyseGameRound(round);
        max['r'] =
            ((max['r'] ?? 0) > (x['r'] ?? 0)) ? max['r'] ?? 0 : x['r'] ?? 0;
        max['g'] =
            ((max['g'] ?? 0) > (x['g'] ?? 0)) ? max['g'] ?? 0 : x['g'] ?? 0;
        max['b'] =
            ((max['b'] ?? 0) > (x['b'] ?? 0)) ? max['b'] ?? 0 : x['b'] ?? 0;
      });
      var id = getGameId(gameInput);
      print('ID:$id ($gameInput) resulted in ${max.toString()}');

      var power = (max['r'] ?? 0) * (max['g'] ?? 0) * (max['b'] ?? 0);

      totalPower += power;
      // tidy up at end
    });
    print('power is $totalPower');
  });
}
