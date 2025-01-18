import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/global_widgets/nav_item.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  const NavBar({
    super.key,
    required this.themeMode,
    required this.scrollController,
  });

  final CTheme themeMode;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: themeMode.appBarColor,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 80),
                curve: Curves.easeInOutCirc);
          },
          child: Text(
            "Twear",
            style:
                TextStyle(color: themeMode.primTextColor, fontFamily: "jman"),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme(
                themeMode.getThemeType().runtimeType == Dark().runtimeType
                    ? Light()
                    : Dark());
          },
          icon: themeMode.getThemeType().runtimeType == Dark().runtimeType
              ? const Icon(
                  Icons.light_mode_sharp,
                  color: Colors.white,
                )
              : Transform.rotate(
                  angle: 12,
                  child: const Icon(
                    Icons.nightlight_round_sharp,
                    color: Colors.black,
                  ),
                ),
        ),
        NavItem(
          title: "Home",
          themeMode: themeMode,
          action: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "home");
          },
        ),
        NavItem(
          title: "Product",
          themeMode: themeMode,
          action: () {
            Navigator.pushNamed(context, "products");
          },
        ),
        NavItem(
          title: "Contact",
          themeMode: themeMode,
        ),
        const CircleAvatar(
          foregroundImage: AssetImage("images/hero.jpg"),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
