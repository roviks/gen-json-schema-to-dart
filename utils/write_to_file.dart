import 'dart:io';

void insertContentAtBeginning(String filePath, String content) {
  final file = File(filePath);
  String? existingContent;
  if (file.existsSync()) {
    existingContent = file.readAsStringSync();
  }

  // Read the existing content of the file

  // Open the file in write mode
  final openedFile = file.openSync(mode: FileMode.write);

  // Write the new content at the beginning of the file
  openedFile.writeStringSync(content);
  if (existingContent != null) {
    openedFile.writeStringSync(existingContent);
  }

  // Close the file
  openedFile.closeSync();
}
