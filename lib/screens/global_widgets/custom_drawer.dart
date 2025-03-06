import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_admin_stat.dart';

class CustomDrawer extends StatefulWidget {
  final CTheme themeMode;
  final ScrollController? scrollController;
  const CustomDrawer({
    super.key,
    required this.themeMode,
    this.scrollController,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<Widget> drawerItems(CTheme themeMode, BuildContext context, bool admin) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    return [
      ListTile(
        selectedTileColor: themeMode.borderColor2!.withValues(alpha: .2),
        enabled: currentRoute == "home" ? false : true,
        leading: Icon(Icons.home, color: themeMode.iconColor),
        selected: currentRoute == "home" ? true : false,
        title: Text("Home", style: TextStyle(color: themeMode.primTextColor)),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, "home");
        },
      ),
      if (admin)
        ListTile(
          selectedTileColor: themeMode.borderColor2!.withValues(alpha: .2),
          enabled: currentRoute == "dashboard" ? false : true,
          selected: currentRoute == "dashboard" ? true : false,
          leading: Icon(Icons.dashboard, color: themeMode.iconColor),
          title: Text("Dashboard",
              style: TextStyle(color: themeMode.primTextColor)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              "dashboard",
            );
          },
        ),
      if (currentRoute == "home")
        ListTile(
          leading: Icon(Icons.contact_page, color: themeMode.iconColor),
          title: Text("Dev Contact",
              style: TextStyle(color: themeMode.primTextColor)),
          onTap: () {
            Navigator.pop(context);
            widget.scrollController!.animateTo(
                widget.scrollController!.position.extentTotal,
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeIn);
          },
        ),
      ListTile(
        leading: Icon(Icons.dark_mode, color: themeMode.iconColor),
        title: Text("Switch Theme",
            style: TextStyle(color: themeMode.primTextColor)),
        onTap: () {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ThemeCubit>().toggleTheme(
                  widget.themeMode.getThemeType().runtimeType ==
                          Dark().runtimeType
                      ? Light()
                      : Dark(),
                );
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool admin = isAdmin(context);
    return Drawer(
      backgroundColor: widget.themeMode.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: widget.themeMode.appBarColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guest315",
                        style: TextStyle(
                          color: widget.themeMode.primTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "guestdemo315@guest.com",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.themeMode.borderColor2,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 36,
                  foregroundImage: AssetImage("assets/images/hero.jpg"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: drawerItems(widget.themeMode, context, admin),
            ),
          ),
        ],
      ),
    );
  }
}
