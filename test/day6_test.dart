import 'dart:math';

import 'package:test/test.dart';

typedef Race = (int raceTime, int recordDistance);

num calculateRaceDistance(final Race race, final num chargingTime) {
  return chargingTime * max(0, race.$1 - chargingTime);
}

num calculateNumberWinningPosition(final Race race) {
  List<int> potentialWinningSetups = [];

  // how would you work out the maximum
  // you would need to start from 0, and then only increment until
  // you reached some sort of limit, which could be the time limit of the race?

  for (var chargingTime = 0; chargingTime < race.$1; chargingTime++) {
    if (race.$2 < calculateRaceDistance(race, chargingTime)) {
      potentialWinningSetups.add(chargingTime);
    }
  }
  return potentialWinningSetups.length;
}

int calculateNumberWinningPositions2(Race race) {
  int raceTime = race.$1;
  int recordDistance = race.$2;

  // Coefficients for the quadratic equation
  double a = -1;
  double b = raceTime.toDouble();
  double c = -recordDistance.toDouble();

  // Calculate discriminant
  double discriminant = b * b - 4 * a * c;

  // Check if the discriminant is positive
  if (discriminant < 0) {
    return 0; // No real solutions
  }

  // Calculate the roots
  double sqrtDiscriminant = sqrt(discriminant);
  double root1 = (-b + sqrtDiscriminant) / (2 * a);
  double root2 = (-b - sqrtDiscriminant) / (2 * a);

  // Ensure roots are within valid range (0 to raceTime)
  root1 = root1.clamp(0, raceTime).toDouble();
  root2 = root2.clamp(0, raceTime).toDouble();

  // Count integer values within the range
  int winningCount = 0;
  for (int chargingTime = root1.ceil();
      chargingTime < root2.floor();
      chargingTime++) {
    if (chargingTime <= raceTime && chargingTime > 0) {
      winningCount++;
    }
  }

  return winningCount;
}

void main() {
  test('Basic tests', () {
    expect(calculateRaceDistance((7, 9), 0), 0);
    expect(calculateRaceDistance((7, 9), 1), 6);
    expect(calculateRaceDistance((7, 9), 2), 10);
    expect(calculateRaceDistance((7, 9), 3), 12);
    expect(calculateRaceDistance((7, 9), 4), 12);
    expect(calculateRaceDistance((7, 9), 5), 10);
    expect(calculateRaceDistance((7, 9), 6), 6);
    expect(calculateRaceDistance((7, 9), 6), 6);
    expect(calculateRaceDistance((7, 9), 7), 0);
  });

  // brute force would be to cycle through charging time
  // but in typical AoC fashion we dont even want to attempt
  // to do that.

  // I'll do one test with brute force to check i've got the right logic
  test('Calculate number of ways you could win', () {
    expect(calculateNumberWinningPosition((7, 9)), 4);
    expect(calculateNumberWinningPosition((15, 40)), 8);
    expect(calculateNumberWinningPosition((30, 200)), 9);
    expect(
        calculateNumberWinningPosition((7, 9)) *
            calculateNumberWinningPosition((15, 40)) *
            calculateNumberWinningPosition((30, 200)),
        288);
  });

  test('part one brute force', () {
    var x = calculateNumberWinningPosition((56, 546)) *
        calculateNumberWinningPosition((97, 1927)) *
        calculateNumberWinningPosition((78, 1131)) *
        calculateNumberWinningPosition((75, 1139));
    expect(x, 0); // got the correct answer
  });

  // test('Attempt a non brute force method', () {
  //   expect(calculateNumberWinningPositions2((7, 9)), 4);
  //   expect(calculateNumberWinningPositions2((15, 40)), 8);
  //   expect(calculateNumberWinningPositions2((30, 200)), 9);
  // });

  test('Attempt a non brute force method', () {
    expect(calculateNumberWinningPosition((56977875, 546192711311139)), 4);
  });
}
