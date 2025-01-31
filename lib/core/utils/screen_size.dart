import 'package:flutter/widgets.dart';

List getScreenSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return [width, height];
}
