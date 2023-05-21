import 'dart:convert';
import 'dart:io';
import 'package:json_schema2/json_schema2.dart';
import 'package:http/http.dart' as http;

import 'shared/handle_prop_value.dart';
import 'shared/normalize_method_name.dart';
import '../utils/string_extension.dart';
import '../utils/camelcase_to_snake_case.dart';
import '../utils/create_dir.dart';
import '../utils/write_to_file.dart';

part "shared/get_property_type.dart";
part "shared/generate_model_classes.dart";

void main(List<String> arguments) async {
  final strUrl = arguments.isNotEmpty
      ? arguments[0]
      : "https://c.zeteam.uz/docs/jsons/business";
  final outputPath = arguments.length == 2 ? arguments[1] : null;

  final outputParams = "${outputPath != null ? "$outputPath/" : ""}params";
  final outputResult = "${outputPath != null ? "$outputPath/" : ""}result";

  createDir(outputParams);
  createDir(outputResult);
  final url = Uri.parse(strUrl);

  final response = await http.get(url);
  final decoded = jsonDecode(response.body);
  List<dynamic> methods = decoded['doc'];

  for (var method in methods) {
    var paramsSchema = method['paramsSchema'];
    String methodName = method['method'];
    var resultSchema = method['resultSchema'];

    final params = JsonSchema.createSchema(
      jsonEncode(paramsSchema),
      schemaVersion: SchemaVersion.draft6,
    );
    final result = JsonSchema.createSchema(
      jsonEncode(resultSchema),
      schemaVersion: SchemaVersion.draft6,
    );

    generateModelClasses(
      params,
      className: "${methodName.replaceAll(".", "_")}_params",
      outputPath: outputParams,
      isTopLevel: true,
    );
    generateModelClasses(
      result,
      className: "${methodName.replaceAll(".", "_")}_result",
      outputPath: outputResult,
      isTopLevel: true,
    );
  }
}
