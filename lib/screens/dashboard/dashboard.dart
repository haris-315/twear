import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/card_dimensions.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/kpi.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/product_inspection_page.dart';

class DashBoardPg extends StatefulWidget {
  const DashBoardPg({super.key});

  @override
  State<DashBoardPg> createState() => _DashBoardPgState();
}

class _DashBoardPgState extends State<DashBoardPg>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _slideAnimation2;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDashboardDetails());
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -2), end: Offset(0, 0))
        .animate(_animationController);
    _slideAnimation2 = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CTheme themeMode = getThemeMode(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) =>
          LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        // ignore: unused_local_variable
        double height = constraints.maxWidth;
        return Scaffold(
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
                  if (state is DashboardSuccess) ...[
                    SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        "Welcome to Your Dashboard!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: themeMode.primTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: _slideAnimation2,
                      child: Text(
                        "Here's an overview of your store's performance.",
                        style: TextStyle(
                          fontSize: 16,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
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
                              value:
                                  "Rs.${state.dashboardDetails['totalRevenue'].toStringAsFixed(0)}",
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
                              value:
                                  "${state.dashboardDetails["avgRating"].toStringAsFixed(1)}/5",
                              color: Colors.greenAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Container(
                    //   // duration: const Duration(milliseconds: 950),
                    //   // curve: Curves.easeIn,
                    //   decoration: BoxDecoration(
                    //     color: themeMode.backgroundColor,
                    //     borderRadius: BorderRadius.circular(16),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: themeMode.shadowColor ?? Colors.black12,
                    //         blurRadius: 4,
                    //         offset: const Offset(0, 4),
                    //       ),
                    //     ],
                    //   ),
                    //   height: 300,
                    //   child: const WeeklySalesChart(),
                    // ),
                    const SizedBox(height: 40),
                    // Wrap(
                    //   spacing: width * .2,
                    //   children: [
                    //     PrimeButton(
                    //       width: width <= 500 ? width * .3 : width * .2,
                    //       action: () {
                    //         Navigator.pushNamed(context, "postproduct");
                    //       },
                    //       themeMode: themeMode,
                    //       child: FittedBox(
                    //         child: Text(
                    //           'Post Product',
                    //           style: TextStyle(color: themeMode.primTextColor),
                    //         ),
                    //       ),
                    //     ),
                    //     PrimeButton(
                    //       width: width <= 500 ? width * .3 : width * .2,
                    //       action: () {
                    //         print("Viewing analytics...");
                    //       },
                    //       themeMode: themeMode,
                    //       child: FittedBox(
                    //         child: Text(
                    //           'View Analytics',
                    //           style: TextStyle(color: themeMode.primTextColor),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 30),
                    if (state.dashboardDetails['products'] != null &&
                        (state.dashboardDetails['products'] as List?)!
                            .cast<DBP>()
                            .isNotEmpty) ...[
                      Text(
                        "Products Info",
                        style: TextStyle(
                            color: themeMode.primTextColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Wrap(
                        spacing: width <= 500 ? 3 : 10,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: (state.dashboardDetails['products'] as List)
                            .cast<DBP>()
                            .map((DBP dbp) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ProductCard(
                                      product: dbp.product,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product: dbp.product),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    ClipPath(
                                      clipper: WaterMarkClipper(),
                                      child: Container(
                                        color: dbp.color,
                                        width: responsiveWidth(width),
                                        child: Center(
                                          child: Text(
                                            dbp.name,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      )
                    ] else
                      Center(
                        child: Text(
                          "More data not available...",
                          style: TextStyle(
                              color: themeMode.primTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                  ],
                  if (state is DashboardLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: themeMode.borderColor2,
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      }),
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
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height); // Bottom-right corner
    path.lineTo(20, size.height / 2); // Bottom-left after the cut

    // Diagonal cut
    path.lineTo(0, 0);
    // Back to start

    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
