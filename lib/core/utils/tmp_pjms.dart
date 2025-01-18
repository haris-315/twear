import 'dart:convert';
import 'dart:io';

void writeData({required String location, required Map data}) {
  final File json = File(location);
  String data2Write;
  if (!json.existsSync()) {
    json.createSync(recursive: true);
  }
  String oldData = json.readAsStringSync();
  List decodedOldData =
      oldData == "" ? [] : jsonDecode(oldData);
  decodedOldData.add(data);
  data2Write = jsonEncode(decodedOldData);

  json.writeAsStringSync(data2Write);
}

List readData(String location) {
  final File json = File(location);
  final readData = json.readAsStringSync();
  return jsonDecode(readData);
}