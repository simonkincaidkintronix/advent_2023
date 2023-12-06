import 'dart:math';

import 'package:test/test.dart';

num calculateRace(final num chargingTime) {
  var raceTime = 7; // inputs
  var recordDistance = 9;
  return chargingTime * max(0, raceTime - chargingTime);
}

void main() {
  test('moo', () {
    expect(calculateRace(0), 0);
    expect(calculateRace(1), 6);
    expect(calculateRace(2), 10);
    expect(calculateRace(3), 12);
    expect(calculateRace(4), 12);
    expect(calculateRace(5), 10);
    expect(calculateRace(6), 6);
    expect(calculateRace(6), 6);
    expect(calculateRace(7), 0);
  });
}
