import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

class NavItem extends StatefulWidget {
  final String title;
  final CTheme themeMode;
  final VoidCallback? action;
  const NavItem(
      {super.key,
      required this.title,
      required this.themeMode,
      this.action});

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.action,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              _hovering = true;
            });
          },
          onExit: (event) {
            setState(() {
              _hovering = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: _hovering
                    ? BorderDirectional(
                        bottom: BorderSide(
                            color: widget.themeMode.borderColor ??
                                Colors.transparent,
                            width: 2))
                    : null),
            child: Text(
              widget.title,
              style: TextStyle(color: widget.themeMode.primTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
