extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }

    return this[0].toUpperCase() + substring(1);
  }

  String snakeCaseToCamelCase() {
    final parts = split('_');
    final camelCase = StringBuffer(parts[0]);

    for (int i = 1; i < parts.length; i++) {
      final part = parts[i];
      camelCase.write(part.substring(0, 1).toUpperCase());
      camelCase.write(part.substring(1));
    }

    return camelCase.toString();
  }

  String snakeCaseToPascalCase() {
    final parts = split('_');
    final pascalCase = StringBuffer();

    for (final part in parts) {
      pascalCase.write(part.substring(0, 1).toUpperCase());
      pascalCase.write(part.substring(1));
    }

    return pascalCase.toString();
  }
}
