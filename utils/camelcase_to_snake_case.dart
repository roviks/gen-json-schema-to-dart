String camelCaseToSnakeCase(String input) {
  final regex = RegExp(r'(?<=[a-z])[A-Z]');
  final snakeCase =
      input.replaceAllMapped(regex, (match) => '_${match.group(0)}');
  return snakeCase.toLowerCase();
}
