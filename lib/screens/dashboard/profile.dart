import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/screens/global_widgets/glowing_container.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/prime_button.dart';
import 'package:t_wear/screens/dashboard/widgets/section_builder.dart';
import 'package:t_wear/screens/dashboard/widgets/section_child.dart';

class ProfilePg extends StatefulWidget {
  const ProfilePg({super.key});

  @override
  State<ProfilePg> createState() => _ProfilePgState();
}

class _ProfilePgState extends State<ProfilePg> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = getScreenSize(context).first;
    double height = getScreenSize(context).elementAt(1);
    final CTheme themeMode = getThemeMode(context);

    return Scaffold(
      backgroundColor: themeMode.backgroundColor,
      appBar: NavBar(
        themeMode: themeMode,
        scrollController: scrollController,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Center(
              child: glowingContainer(
                shape: BoxShape.circle,
                child: CircleAvatar(
                  radius: height * 0.07 + width * 0.05,
                  foregroundImage: const AssetImage("images/hero.jpg"),
                ),
                themeMode: themeMode,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Guest315",
              style: TextStyle(
                fontSize: 28,
                fontFeatures: const [FontFeature.swash(2)],
                color: themeMode.primTextColor,
              ),
            ),
            const SizedBox(height: 20),
            buildSection(
              themeMode: themeMode,
              sectionTitle: "Personal Information",
              items: [
                buildItem(
                  icon: Icons.date_range,
                  label: "Joined on",
                  value: "01/01/2024",
                  themeMode: themeMode,
                ),
                buildItem(
                  icon: Icons.location_on,
                  label: "Physical Address",
                  value: "D.I.K Pakistan",
                  themeMode: themeMode,
                ),
                buildItem(
                  icon: Icons.phone,
                  label: "Phone",
                  value: "+923150398498 & +923150907995",
                  themeMode: themeMode,
                ),
                buildItem(
                  icon: Icons.email,
                  label: "Email",
                  value: "hkffking@gmail.com",
                  themeMode: themeMode,
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildSection(
              themeMode: themeMode,
              sectionTitle: "Performance",
              items: [
                buildItem(
                  icon: Icons.post_add,
                  label: "Products Posted",
                  value: "14",
                  themeMode: themeMode,
                ),
                buildItem(
                  icon: Icons.sell,
                  label: "Total Sales",
                  value: "23",
                  themeMode: themeMode,
                ),
                buildItem(
                  icon: Icons.star,
                  label: "Avg Rating",
                  value: "3/5",
                  themeMode: themeMode,
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * .04,
                ),
                PrimeButton(
                    action: () {
                      print("posting new product");
                      Navigator.pushNamed(context, "postproduct");
                    },
                    themeMode: themeMode,
                    fillColor:
                        themeMode.getThemeType() is Light ? Colors.black : null,
                    width: width <= 700 ? width * .3 : width * .15,
                    child: FittedBox(
                      child: Text(
                        'Post Product',
                        style: TextStyle(
                            color: themeMode.getThemeType() is Light
                                ? themeMode.backgroundColor
                                : themeMode.primTextColor),
                      ),
                    )),
                SizedBox(
                  width: width * .06,
                ),
                PrimeButton(
                    action: () {
                      print("posting new product");
                    },
                    themeMode: themeMode,
                    width: width <= 700 ? width * .3 : width * .15,
                    child: FittedBox(
                      child: Text(
                        'Post Product',
                        style: TextStyle(color: themeMode.primTextColor),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
