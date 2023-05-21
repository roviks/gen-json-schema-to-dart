part of "../cli.dart";

void generateModelClasses(
  JsonSchema schema, {
  required String className,
  String? outputPath,
  String? outputFile,
  FileMode fileMode = FileMode.append,
  bool isTopLevel = false,
}) {
  final buffer = StringBuffer();

  final normalizedClassName = normalizeMethodName(className);

  if (schema.properties.isNotEmpty) {
    if (isTopLevel == true) {
      buffer
          .writeln('import \'package:json_annotation/json_annotation.dart\';');
      buffer.writeln();
      buffer.writeln('part \'${camelCaseToSnakeCase(className)}.g.dart\';');
    }

    buffer.writeln();
    buffer.writeln('@JsonSerializable()');
  }
  buffer.writeln('class $normalizedClassName {');

  if (schema.properties.isNotEmpty) {
    buffer.writeln('   $normalizedClassName({');
    schema.properties.forEach((key, value) {
      final propertySchema = schema.properties[key];

      final isRequired = schema.requiredProperties?.contains(key);
      if (propertySchema != null && propertySchema.typeList != null) {
        if (isRequired == true) {
          buffer.writeln('    required this.$key,');
        } else {
          buffer.writeln('    this.$key,');
        }
      }
    });
    buffer.writeln('  });');
    buffer.writeln();
  } else {
    buffer.writeln('   const $normalizedClassName();');
  }

  schema.properties.forEach((key, value) {
    final propertySchema = schema.properties[key];

    if (propertySchema != null && propertySchema.typeList != null) {
      final (propertyType, isChild) = getPropertyType(
        propertySchema,
        className: className,
        outputPath: outputPath,
        key: key,
      );
      if (isChild == true) {
        final childClassName = '${className}_${key.toLowerCase()}';

        generateModelClasses(
          propertySchema,
          className: childClassName,
          outputPath: outputPath,
          outputFile: outputFile ?? className,
          fileMode: FileMode.append,
        );
      }
      final isRequired = schema.requiredProperties?.contains(key);
      buffer.write(handlePropValue(propertyType, key, isRequired));
    } else {
      print(
          "SOMETHIN WENT WRONG Empty property in scheme ``$key`` \"$outputPath/${camelCaseToSnakeCase(className)}.dart\"");
    }
  });

  if (schema.properties.isNotEmpty) {
    buffer.writeln();
    buffer.writeln(
        '  factory $normalizedClassName.fromJson(Map<String, dynamic> json) => _\$${normalizedClassName}FromJson(json);');
    buffer.writeln(
        '  Map<String, dynamic> toJson() => _\$${normalizedClassName}ToJson(this);');
  }

  buffer.writeln('}');

  final generatedCode = buffer.toString();

  insertContentAtBeginning(
      "$outputPath/${camelCaseToSnakeCase(outputFile ?? className)}.dart",
      generatedCode);
}
