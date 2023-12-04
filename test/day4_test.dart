import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';

int? getFirstNumeric(String string) {
  return int.tryParse(RegExp(r'(\d+)').firstMatch(string)?.group(1) ?? '');
}

List<int> getAllNumerics(String string) {
  List<int> all = [];

  return RegExp(r'(\d+)')
      .allMatches(string)
      .map((match) => int.parse(match.group(0)!))
      .toList();
}

List<String> getParts(String string, String regex) {
  return string.split(RegExp(regex)).map((s) => s.trim()).toList();
}

void main() {
  test('D4:P1', () {
    List<String> puzzleInput = [
      'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
      'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
      'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
      'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
      'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
      'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11',
    ];

    const String filename = 'data/dayfour.txt';
    puzzleInput = File(filename).readAsLinesSync();

    var totalScore = 0;

    puzzleInput.forEach((card) {
      List<String> parts = getParts(card, r':|\|');
      int? cardId = getFirstNumeric(parts[0]);
      List<int> winningNumbers = getAllNumerics(parts[1]);
      List<int> myNumbers = getAllNumerics(parts[2]);
      // compare how many winningNumbers are in myNumbers, and which ones
      List<int> myWinningNumbers =
          winningNumbers.where((winner) => myNumbers.contains(winner)).toList();
      // var score = (2 ^ myWinningNumbers.length);
      int score = (myWinningNumbers.length > 0)
          ? pow(2, myWinningNumbers.length - 1) as int
          : 0;
      totalScore += score;
    });
    print(totalScore);
  });

  test('D4:P2 Attempt Two', () {
    List<String> puzzleInput = [
      'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
      'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
      'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
      'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
      'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
      'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11',
    ];

    const String filename = 'data/dayfour.txt';
    puzzleInput = File(filename).readAsLinesSync();

    List<String> originalCards = [...puzzleInput];

    int howManyWinningNumbers(String card) {
      List<String> parts = getParts(card, r':|\|');
      int? cardId = getFirstNumeric(parts[0]);
      List<int> winningNumbers = getAllNumerics(parts[1]);
      List<int> myNumbers = getAllNumerics(parts[2]);
      if (cardId == null) throw Exception('No card ID');
      List<int> myWinningNumbers =
          winningNumbers.where((winner) => myNumbers.contains(winner)).toList();
      return myWinningNumbers.length;
    }

    List<int> getWinningNumbers(String card) {
      List<String> parts = getParts(card, r':|\|');
      int? cardId = getFirstNumeric(parts[0]);
      List<int> winningNumbers = getAllNumerics(parts[1]);
      List<int> myNumbers = getAllNumerics(parts[2]);
      if (cardId == null) throw Exception('No card ID');
      List<int> myWinningNumbers =
          winningNumbers.where((winner) => myNumbers.contains(winner)).toList();
      return myWinningNumbers;
    }

    int getMyCardId(String card) {
      List<String> parts = getParts(card, r':|\|');
      int? cardId = getFirstNumeric(parts[0]);
      if (cardId == null) throw Exception('No card ID');
      return cardId;
    }

    String getCopyOfCard(int cardId) {
      return originalCards[cardId - 1];
    }

    int? findLocation(id) {
      for (int i = 0; i < puzzleInput.length; i++) {
        // print('location $i');
        if (getFirstNumeric(puzzleInput[i]) == id) {
          return i;
        }
      }
      return null;
    }

    int scratch(String card) {
      int cardId = getMyCardId(card);
      int result = 0;
      int i = 0;
      result++;
      List<String> parts = getParts(card, r':|\|');
      List<int> winningNumbers = getAllNumerics(parts[1]);
      List<int> myNumbers = getAllNumerics(parts[2]);
      List<int> myWinningNumbers =
          winningNumbers.where((winner) => myNumbers.contains(winner)).toList();
      myWinningNumbers.forEach((element) {
        result += scratch(puzzleInput[cardId + ++i]);
      });
      return result;
    }

    int? totalResults() {
      int result = 0;
      for (int i = 0; i < puzzleInput.length; i++) {
        result += scratch(puzzleInput[i]);
      }
      return result;
    }

    List<String> getMyPrizes(int cardId, int score) {
      List<String> prizes = [];
      int startingId = cardId + 1;
      int endId = startingId + score - 1;

      for (int currentId = startingId; currentId <= endId; currentId++) {
        prizes.add(getCopyOfCard(currentId));
      }
      return prizes;
    }

    int putInTheCorrectPlace(String cardCopy) {
      var id = getMyCardId(cardCopy);
      var location = findLocation(id);
      return location ?? 0;
      // print('Location: $location');
    }

    int moo(String baa) {
      int score = howManyWinningNumbers(baa);
      int cardId = getMyCardId(baa);
      List<String> prizes = getMyPrizes(cardId, score);
      int result = 0;

      prizes.forEach((element) {
        result++;
        result += moo(element);
      });
      return result;
    }

    int? simonsLastTryFuckThis() {
      int totalCopies = 0;
      for (int i = 0; i < puzzleInput.length; i++) {
        totalCopies += moo(puzzleInput[i]);
        print('* $totalCopies');
      }
      return totalCopies + puzzleInput.length;
    }

    expect(simonsLastTryFuckThis(), 30);

    // expect(puzzleInput.length, 30);
  });
}
