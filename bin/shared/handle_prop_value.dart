import '../../utils/string_extension.dart';

String handlePropValue(String propertyType, String key, bool? isRequired) {
  var res = StringBuffer();

  if (key.startsWith("_")) {
    res.writeln("   @JsonKey(name: \"$key\")");
    key = key.substring(1);
  }

  if (isRequired == true) {
    res.writeln("   final ${[
      "int",
      "num",
      "bool",
      "double",
      "dynamic"
    ].contains(propertyType) ? propertyType : propertyType.snakeCaseToPascalCase()} $key;");
  } else {
    res.writeln("   final ${[
      "int",
      "bool",
      "double",
      "num",
      "dynamic"
    ].contains(propertyType) ? propertyType : propertyType.snakeCaseToPascalCase()}? $key;");
  }
  return res.toString();
}
