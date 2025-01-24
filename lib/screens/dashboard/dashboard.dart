import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/screens/dashboard/widgets/weekly_sales_chart.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/prime_button.dart';

class DashBoardPg extends StatefulWidget {
  const DashBoardPg({super.key});

  @override
  State<DashBoardPg> createState() => _DashBoardPgState();
}

class _DashBoardPgState extends State<DashBoardPg> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = getScreenSize(context).first;
    final CTheme themeMode = getThemeMode(context);

    return Scaffold(
      backgroundColor: themeMode.backgroundColor,
      appBar: NavBar(
        themeMode: themeMode,
        scrollController: scrollController,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Welcome to Your Dashboard!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeMode.primTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Here's an overview of your store's performance.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeMode.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  buildKpiCard(
                    themeMode: themeMode,
                    icon: Icons.shopping_cart,
                    title: "Total Orders",
                    value: "150",
                  ),
                  buildKpiCard(
                    themeMode: themeMode,
                    icon: Icons.attach_money,
                    title: "Revenue",
                    value: "Rs.12,000",
                  ),
                  buildKpiCard(
                    themeMode: themeMode,
                    icon: Icons.people,
                    title: "Customers",
                    value: "75",
                  ),
                  buildKpiCard(
                    themeMode: themeMode,
                    icon: Icons.star,
                    title: "Avg. Rating",
                    value: "4.5/5",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 950),
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  color: themeMode.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: themeMode.shadowColor ?? Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                height: 300,
                child: const WeeklySalesChart(),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Wrap(
                spacing: width * .2,
                children: [
                  PrimeButton(
                    width: width <= 500 ? width * .3 : width * .2,
                    action: () {
                      Navigator.pushNamed(context, "postproduct");
                    },
                    themeMode: themeMode,
                    child: FittedBox(
                      child: Text(
                        'Post Product',
                        style: TextStyle(color: themeMode.primTextColor),
                      ),
                    ),
                  ),
                  PrimeButton(
                    width: width <= 500 ? width * .3 : width * .2,
                    action: () {
                      print("Viewing analytics...");
                    },
                    themeMode: themeMode,
                    child: FittedBox(
                      child: Text(
                        'View Analytics',
                        style: TextStyle(color: themeMode.primTextColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKpiCard({
    required CTheme themeMode,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 950),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: themeMode.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeMode.shadowColor ?? Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: 150,
      height: 160,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: themeMode.iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: themeMode.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: themeMode.primTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
