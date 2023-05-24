import 'dart:io';

void createDir(String directoryPath) {
  final directory = Directory(directoryPath);

  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }

  directory.createSync(recursive: true);
}
