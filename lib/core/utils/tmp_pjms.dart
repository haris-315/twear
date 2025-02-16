import 'package:uuid/uuid.dart';

void main(List<String> args) {
  for (int i = 0; i <= 14; i++) {
    print(Uuid().v1());
  }
}
