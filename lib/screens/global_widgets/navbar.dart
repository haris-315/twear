import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/screens/global_widgets/nav_item.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  const NavBar({
    super.key,
    required this.themeMode,
    required this.scrollController,
  });

  final CTheme themeMode;

  List<NavItem> navItems(CTheme themeMode, BuildContext context) => [
        NavItem(
          title: "Home",
          themeMode: themeMode,
          action: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "home");
          },
        ),
        NavItem(
          title: "Dashboard",
          themeMode: themeMode,
          action: () {
            Navigator.pushNamed(context, "products");
          },
        ),
        NavItem(
          title: "Contact",
          themeMode: themeMode,
        )
      ];

  @override
  Widget build(BuildContext context) {
    final [width, height] = getScreenSize(context);
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
        if (ModalRoute.of(context)?.settings.name == "home" ||
            ModalRoute.of(context)?.settings.name == "/")
          Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: themeMode.borderColor ?? Colors.red),
                  borderRadius: BorderRadius.circular(16)),
              height: 34,
              width: width * .5,
              child: SearchBar(
                onSubmitted: (query) {
                  context.read<HomeBloc>().add(GetBySearch(query: query));
                },
                overlayColor:
                    WidgetStateColor.resolveWith((_) => Colors.transparent),
                textStyle: WidgetStateTextStyle.resolveWith(
                    (_) => TextStyle(color: themeMode.primTextColor)),
                shadowColor:
                    WidgetStateColor.resolveWith((_) => Colors.transparent),
                backgroundColor: WidgetStateColor.resolveWith(
                    (_) => themeMode.appBarColor ?? Colors.red),
                hintText: "Search",
                hintStyle: WidgetStateProperty.resolveWith(
                    (_) => TextStyle(color: themeMode.primTextColor)),
                trailing: [
                  Icon(
                    Icons.search,
                    color: themeMode.iconColor,
                  )
                ],
              )),
        if (width <= 500)
          DrawerButton(
            color: themeMode.iconColor,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          )
        else ...[
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
          ...navItems(themeMode, context)
        ]
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
