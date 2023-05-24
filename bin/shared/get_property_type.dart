part of "../cli.dart";

(String, bool?) getPropertyType(
  JsonSchema propertySchema, {
  String? className,
  String? key,
  String? outputPath,
}) {
  final type = propertySchema.type;
  final format = propertySchema.format;

  if (type == SchemaType.string) {
    if (format == "date-time") {
      return ('DateTime', null);
    } else {
      return ('String', null);
    }
  } else if (type == SchemaType.number) {
    return ('double', null);
  } else if (type == SchemaType.integer) {
    return ('int', null);
  } else if (type == SchemaType.boolean) {
    return ('bool', null);
  } else if (type == SchemaType.array) {
    final itemsSchema = propertySchema.items;

    if (itemsSchema == null) {
      return ("List<dynamic>", null);
    }
    final itemType = getPropertyType(itemsSchema, outputPath: outputPath);
    return ('List<$itemType>', null);
  } else if (type == SchemaType.object) {
    final childClassName = '${className!}_${key?.capitalize()}';

    return (childClassName, true);
    // } else {
    //   final childClassName = '${className}Object';
    //   generateModelClasses(
    //     propertySchema,
    //     childClassName,
    //     outputPath: outputPath,
    //     fileMode: FileMode.append,
    //   );
    //   return childClassName;
    // }
  } else {
    return ('dynamic', null);
  }
}
