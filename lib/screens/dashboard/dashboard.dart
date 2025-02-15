import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/dashboard/widgets/weekly_sales_chart.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/kpi.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/prime_button.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';

import '../home/product_inspection_page.dart';

class DashBoardPg extends StatefulWidget {
  const DashBoardPg({super.key});

  @override
  State<DashBoardPg> createState() => _DashBoardPgState();
}

class _DashBoardPgState extends State<DashBoardPg> {
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DashboardBloc>().add(GetDashboardDetails());

  }


  @override
  Widget build(BuildContext context) {
    double width = getScreenSize(context).first;
    final CTheme themeMode = getThemeMode(context);


    return BlocBuilder<DashboardBloc,DashboardState>(
      builder: (context, state) => Scaffold(
        endDrawer: CustomDrawer(themeMode: themeMode),
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
                if (state is DashboardSuccess)
                ...[Text(
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
                        value: "${state.dashboardDetails['totalOrders']}",
                        color: Colors.yellowAccent),
                    buildKpiCard(
                        themeMode: themeMode,
                        icon: Icons.attach_money,
                        title: "Revenue",
                        value: "Rs.${state.dashboardDetails['totalRevenue'].toStringAsFixed(0)}",
                        color: Colors.redAccent),
                    buildKpiCard(
                      themeMode: themeMode,
                      icon: Icons.people,
                      title: "Customers",
                      value: "75",
                      color: Colors.blueAccent,
                    ),
                    buildKpiCard(
                        themeMode: themeMode,
                        icon: Icons.star,
                        title: "Avg. Rating",
                        value: "${state.dashboardDetails["avgRating"].toStringAsFixed(1)}/5",
                        color: Colors.greenAccent),
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

                  Wrap(
                    children: (state.dashboardDetails['products'] as List)
                        .cast<DBP>() // Ensure it's List<DBP>
                        .map((DBP dbp) => Stack(
                      children: [
                        ProductCard(
                          product: dbp.product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: dbp.product),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 40,
                          child: ClipPath(
                            clipper: WaterMarkClipper(),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              color: Colors.red,
                              child: Text(
                                dbp.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
                        .toList(), // Ensure `map()` result is converted to List
                  )
                ],

                if (state is DashboardLoading)
                  CircularProgressIndicator(color: themeMode.borderColor2,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class WaterMarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at top-left
    path.lineTo(0, 0);
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height); // Bottom-right corner
    path.lineTo(20, size.height/2); // Bottom-left after the cut

    // Diagonal cut
    path.lineTo(0, 0);
    // Back to start

    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}