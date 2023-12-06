List<int> getAllNumerics(String string) {
  List<int> all = [];

  return RegExp(r'(\d+)')
      .allMatches(string)
      .map((match) => int.parse(match.group(0)!))
      .toList();
}

List<int> getRange(int start, int length) {
  print('getRange called with start: $start and length: $length');
  return Iterable<int>.generate((start + length) - start, (i) => start + i)
      .toList();
}

int? findIndexInVirtualList(int x, int start, int length) {
  if (x >= start && x < start + length) {
    return x - start;
  }
  return null; // Return null if x is not in the range
}

mooseTest((List<int>, List<int>) map, int sourceNumber) {
  var index = map.$1.indexOf(sourceNumber);
  if (index != -1) {
    print('found $sourceNumber matches to ${map.$2[index]}');
    return map.$2[index];
  } else {
    return sourceNumber;
  }
}

List<List<T>> splitIntoPairs<T>(List<T> list) {
  return List.generate(list.length ~/ 2, (i) => [list[i * 2], list[i * 2 + 1]]);
}
