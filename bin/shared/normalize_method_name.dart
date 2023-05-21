import '../../utils/string_extension.dart';

String normalizeMethodName(String methodName, [String pattern = "_"]) {
  var res = [];

  for (var word in methodName.split(pattern)) {
    res.add(word.capitalize());
  }

  return res.join('');
}
