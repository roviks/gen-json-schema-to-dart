import 'dart:io';

void createDir(String directoryPath) {
  final directory = Directory(directoryPath);

  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
    print('Directory removed: $directoryPath');
  }

  directory.createSync(recursive: true);
  print('Directory created: $directoryPath');
}
