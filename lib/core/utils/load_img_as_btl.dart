import 'dart:convert';
import 'dart:io';

String loadImage2Save(String path) {
  File file = File(path);
  final bytes = file.readAsBytesSync();
  print(base64Encode(bytes));
  return base64Encode(bytes);
}
