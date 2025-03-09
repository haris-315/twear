import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/card_dimensions.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/screens/dashboard/widgets/pending_orders.dart';
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
        AnimationController(vsync: this, duration: Duration(seconds: 1));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (state is DashboardSuccess) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        "Welcome to Your Dashboard!",
                        style: TextStyle(
                          fontSize: width <= 500 ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: themeMode.primTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideTransition(
                      position: _slideAnimation2,
                      child: Text(
                        "Here's an overview of your store's performance.",
                        textAlign:
                            width <= 500 ? TextAlign.center : TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
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
                            color: const Color.fromRGBO(105, 240, 174, 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state.dashboardDetails['products'] != null &&
                      (state.dashboardDetails['products'] as List?)!
                          .cast<DBP>()
                          .isNotEmpty) ...[
                    Text(
                      "Pending Orders",
                      style: TextStyle(
                          color: themeMode.primTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0),
                      child: PendingOrders(
                          products: state.dashboardDetails['products']),
                    ),
                  ],
                  SizedBox(
                    height: 24,
                  ),
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
                    _buildProducts(width, height, themeMode,
                        state.dashboardDetails['products'])
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, "postproduct");
            },
            icon: Icon(Icons.add, color: themeMode.iconColor),
            label: Text('Add New Product',
                style: TextStyle(color: themeMode.primTextColor)),
            backgroundColor: themeMode.buttonColor,
          ),
        );
      }),
    );
  }

  Widget _buildProducts(
      double swidth, double sheight, CTheme themeMode, List<DBP> dbps) {
    bool smallScreen = swidth <= 500;

    return Wrap(
        spacing: smallScreen ? 3 : 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        children: dbps.map((dbp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                ProductCard(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: dbp.product)));
                  },
                  carted: true,
                  product: dbp.product,
                  cartAction: (cproduct) {},
                ),
                SizedBox(
                  height: 9,
                ),
                ClipPath(
                  clipper: WaterMarkClipper(),
                  child: Container(
                    width: responsiveWidth(swidth) - 20,
                    color: dbp.color,
                    child: Center(
                      child: Text(
                        dbp.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList());
  }
}

class WaterMarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(20, size.height / 2);

    path.lineTo(0, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
