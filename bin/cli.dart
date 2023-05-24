import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:json_schema2/json_schema2.dart';

import 'shared/generate_app_service.dart';
import 'shared/generate_repos.dart';
import 'shared/handle_prop_value.dart';
import 'shared/normalize_method_name.dart';
import '../utils/string_extension.dart';
import '../utils/camelcase_to_snake_case.dart';
import '../utils/create_dir.dart';
import '../utils/insert_to_file.dart';

part "shared/get_property_type.dart";
part "shared/generate_model_classes.dart";

void main(List<String> arguments) async {
  final strUrl = arguments.isNotEmpty
      ? arguments[0]
      : "https://c.zeteam.uz/docs/jsons/business";
  final outputPath = arguments.length == 2 ? arguments[1] : null;

  final outputParams = "${outputPath != null ? "$outputPath/" : ""}params";
  final outputResult = "${outputPath != null ? "$outputPath/" : ""}result";
  final outputApi = "${outputPath != null ? "$outputPath/" : ""}api";
  final outputAppService = "${outputPath != null ? "$outputPath/" : ""}service";

  createDir(outputParams);
  createDir(outputResult);
  createDir(outputApi);
  createDir(outputAppService);

  final response = await Dio().get(strUrl);
  final decoded = jsonDecode(response.data);
  List<dynamic> methods = decoded['doc'];

  Map<String, List<dynamic>> repos = {};

  for (var method in methods) {
    var paramsSchema = method['paramsSchema'];
    var resultSchema = method['resultSchema'];
    String methodName = method['method'];
    String repo = methodName.split('.')[0];

    if (repos[repo] == null) {
      repos[repo] = [method];
    } else {
      repos[repo]!.add(method);
    }

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
      method: method,
      isTopLevel: true,
      isParams: true,
    );
    generateModelClasses(
      result,
      className: "${methodName.replaceAll(".", "_")}_result",
      outputPath: outputResult,
      method: method,
      isTopLevel: true,
      isResult: true,
    );
  }

  generateRepos(repos, outputPath: outputApi);
  generateAppService(outputPath: outputAppService);
}
