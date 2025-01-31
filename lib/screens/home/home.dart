import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/widgets/category.dart';
import 'package:t_wear/screens/home/widgets/shimmer_effect.dart';
import 'package:t_wear/screens/home/widgets/trends.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final double swidth = MediaQuery.of(context).size.width;
    final double sheight = MediaQuery.of(context).size.height;
    final CTheme themeMode = getThemeMode(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: themeMode.backgroundColor,
          appBar: NavBar(
            themeMode: themeMode,
            scrollController: scrollController,
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: state is HomeSuccess
                ? Column(
                    children: [
                      _categoryBuilder(swidth, sheight, themeMode),
                      const SizedBox(
                        height: 40,
                      ),
                      if (!state.isCategorizing)
                        TrendingPicks(
                            trendingProducts: state.products['trending'] ?? []),
                      const SizedBox(
                        height: 40,
                      ),
                      ..._buildProducts(state, swidth, sheight, themeMode)
                    ],
                  )
                : state is HomeLoading
                    ? Column(
                        children: [
                          if (state.byCategory)
                            _categoryBuilder(swidth, sheight, themeMode),
                          ShimmerEffect(
                              forCategories: state.byCategory ? true : false),
                        ],
                      )
                    : state is HomeError
                        ? Center(
                            child: Text(state.message),
                          )
                        : const Placeholder(),
          ),
        );
      },
    );
  }

  SizedBox _categoryBuilder(double swidth, double sheight, CTheme themeMode) {
    return SizedBox(
      height: swidth <= 500
          ? swidth < 400
              ? swidth * 0.22
              : swidth * 0.19
          : sheight * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: swidth <= 500
                ? EdgeInsets.only(
                    left: swidth <= 400 ? 10 : 19.0,
                    top: 22,
                    bottom: 22,
                    right: swidth <= 400 ? 10 : 19.0)
                : const EdgeInsets.only(
                    left: 19, right: 19, top: 16, bottom: 16),
            child: CategoryItem(
              category: categories[index],
              themeMode: themeMode,
            ),
          );
        },
      ),
    );
  }

  Iterable _buildProducts(
      HomeSuccess state, double swidth, double sheight, CTheme themeMode) {
    bool smallScreen = swidth <= 500;
    return state.products.keys.map(
      (key) => key == 'trending'
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: smallScreen
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(width: swidth),
                  Padding(
                    padding: EdgeInsets.only(left: smallScreen ? 0 : 25.0),
                    child: Text(
                      key.toString().toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: themeMode.primTextColor),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children:
                        List.generate(state.products[key]!.length, (index) {
                      return ProductCard(
                        onTap: () {
                          Navigator.pushNamed(context, "inspect-widget",
                              arguments: state.products[key]![index]);
                        },
                        product: state.products[key]![index],
                      );
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
