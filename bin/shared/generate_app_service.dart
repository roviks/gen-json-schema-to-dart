import 'dart:io';

import '../../utils/insert_to_file.dart';

void generateAppService({
  required String outputPath,
}) {
  final appErrorFile = File("${Directory.current.path}/lib/app_error.dart");
  final appServiceFile = File("${Directory.current.path}/lib/app_service.dart");

  final appService = StringBuffer();
  final appError = StringBuffer();

  appService.writeln(appServiceFile.readAsStringSync());
  appError.writeln(appErrorFile.readAsStringSync());

  insertContentAtBeginning(
    "$outputPath/app_service.dart",
    appService.toString(),
  );
  insertContentAtBeginning(
    "$outputPath/app_error.dart",
    appError.toString(),
  );
}
