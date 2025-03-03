
import 'package:flutter/material.dart';

class ColorChangingProgressIndicator extends StatefulWidget {
  @override
  _ColorChangingProgressIndicatorState createState() =>
      _ColorChangingProgressIndicatorState();
}

class _ColorChangingProgressIndicatorState
    extends State<ColorChangingProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  final List<Color> _colors = [
    Colors.red,
    Colors.lightGreenAccent,
    Colors.blueAccent,
    Colors.pink,
    Colors.yellowAccent
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: _colors[0],
      end: _colors[1],
    ).animate(_controller)
      ..addListener(() {
        setState(() {}); // Redraw the widget to update the color
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_colorAnimation.value!),
            backgroundColor: Colors.transparent,
          );
}
}