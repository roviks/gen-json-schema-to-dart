import 'dart:io';

void appendToFile(String filePath, String content) {
  final file = File(filePath);
  String? existingContent;
  if (file.existsSync()) {
    existingContent = file.readAsStringSync();
  }

  final openedFile = file.openSync(mode: FileMode.write);

  if (existingContent != null) {
    openedFile.writeStringSync(existingContent);
  }
  openedFile.writeStringSync(content);

  openedFile.closeSync();
}
