// Technically this indexAll function was generated
// byChatGPT when i realised there's no easy way to
// continue on from an indexOf query
//
List<int> indexAll(String str, Pattern pattern) {
  List<int> indices = [];
  int index = str.indexOf(pattern);
  while (index != -1) {
    indices.add(index);
    if (index + 1 < str.length) {
      index = str.indexOf(pattern, index + 1);
    } else {
      break;
    }
  }
  return indices..sort();
}
