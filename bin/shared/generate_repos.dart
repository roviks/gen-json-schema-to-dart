import '../../utils/camelcase_to_snake_case.dart';
import '../../utils/insert_to_file.dart';
import '../../utils/string_extension.dart';
import 'normalize_method_name.dart';

void generateRepos(
  Map<String, List<dynamic>> repos, {
  String? outputPath,
  bool isTopLevel = false,
}) {
  repos.forEach((key, value) {
    final buffer = StringBuffer();
    final imports = StringBuffer();

    imports.writeln('import \'../service/app_service.dart\';');
    final repositoryName = "${key.capitalize()}Repository";
    final repositoryFile = "${key}_repository.dart".toLowerCase();
    buffer.writeln();
    buffer.writeln("class $repositoryName {");
    if (repos[key] != null) {
      for (var method in repos[key]!) {
        String methodName = method['method'];
        final normalizedClassName = normalizeMethodName(methodName, ".");
        final fileName = camelCaseToSnakeCase(methodName.replaceAll(".", "_"));
        imports.writeln('import \'../params/${fileName}_params.dart\';');
        imports.writeln('import \'../result/${fileName}_result.dart\';');
        buffer.writeln(
            "  static Future<${normalizedClassName}Result> ${methodName.split(".")[1]}(${normalizedClassName}Params params) async {");
        buffer.writeln("    var res = await rpc(");
        buffer.writeln("      \"${methodName.replaceAll("_", ".")}\",");
        if (method["isParamsEmpty"] != true) {
          buffer.writeln("      params: params.toJson(),");
        }
        buffer.writeln("    );");
        buffer.writeln();
        if (method["isResultEmpty"] == true) {
          buffer.writeln("   return res;");
        } else {
          buffer
              .writeln("   return ${normalizedClassName}Result.fromJson(res);");
        }
        buffer.writeln("  }");
        buffer.writeln();
      }
    }
    buffer.writeln("}");

    insertContentAtBeginning(
      "$outputPath/$repositoryFile",
      "${imports.toString()}${buffer.toString()}",
    );
  });
}
