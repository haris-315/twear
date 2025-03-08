import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:t_wear/bloc/cubit/cart_cubit.dart';
import 'package:t_wear/bloc/cubit/user_cubit.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_admin_stat.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/product_inspection_page.dart';
import 'package:t_wear/screens/home/widgets/carousal_shimmer.dart';
import 'package:t_wear/screens/home/widgets/category.dart';
import 'package:t_wear/screens/home/widgets/footer.dart';
import 'package:t_wear/screens/home/widgets/shimmer_effect.dart';
import 'package:t_wear/screens/home/widgets/trends.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool admin = false;
  final ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData(context));

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotateAnimation = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3)).then((_) {
        _controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double swidth = MediaQuery.of(context).size.width;
    final double sheight = MediaQuery.of(context).size.height;
    final CTheme themeMode = getThemeMode(context);
    admin = isAdmin(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          if (context.read<UserCubit>().state is Buyer && isFirstBuild) {
            context
                .read<UserCubit>()
                .addToPending([...state.products.values.last]);
            isFirstBuild = false;
          }
        }
        return Scaffold(
          backgroundColor: themeMode.backgroundColor,
          appBar: NavBar(
            themeMode: themeMode,
            scrollController: scrollController,
          ),
          endDrawer: CustomDrawer(
            themeMode: themeMode,
            scrollController: scrollController,
          ),
          floatingActionButton: ScaleTransition(
            scale: _scaleAnimation,
            child: RotationTransition(
              turns: _rotateAnimation,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: themeMode.borderColor ?? Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(colors: [
                      themeMode.buttonColor!.withValues(alpha: .7),
                      themeMode.buttonColor!.withValues(alpha: .2)
                    ])),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pushNamed(context, "cart");
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    color: themeMode.iconColor,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: state is HomeSuccess
                ? BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _categoryBuilder(swidth, sheight, themeMode),
                          const SizedBox(
                            height: 3,
                          ),
                          if (!state.isCategorizing)
                            TrendingPicks(
                                trendingProducts:
                                    state.products['trending'] ?? []),
                          const SizedBox(
                            height: 40,
                          ),
                          _buildProducts(
                              state,
                              swidth,
                              sheight,
                              state.isCategorizing,
                              themeMode,
                              cartState is CartSuccess
                                  ? cartState.cartedProdcuts
                                  : []),
                          SizedBox(
                            height: 20,
                          ),
                          Footer()
                        ],
                      );
                    },
                  )
                : state is HomeLoading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!state.byCategory)
                            SizedBox(
                              height: swidth <= 500 ? 104 : sheight * 0.35,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: swidth <= 500
                                            ? EdgeInsets.only(
                                                left: swidth <= 400 ? 10 : 19.0,
                                                top: 22,
                                                bottom: 22,
                                                right:
                                                    swidth <= 400 ? 10 : 19.0)
                                            : const EdgeInsets.only(
                                                left: 19,
                                                right: 19,
                                                top: 16,
                                                bottom: 16),
                                        child: ShimmerLoadingEffect(
                                          isCategory: true,
                                        ));
                                  },
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          if (!state.byCategory) TrendingPicksShimmer(),
                          SizedBox(
                            height: 20,
                            width: swidth,
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: List<ShimmerLoadingEffect>.generate(
                                12, (index) => ShimmerLoadingEffect()),
                          )
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
    ScrollController controller = ScrollController();
    return SizedBox(
      height: swidth <= 500 ? 104 : sheight * 0.35,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, right: 8.0),
        child: Scrollbar(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListView.builder(
              controller: controller,
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
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(HomeSuccess state, double swidth, double sheight,
      bool isForCategory, CTheme themeMode, List<Product> cartedProducts) {
    bool smallScreen = swidth <= 500;
    Map<dynamic, List<Product>> products =
        state.products.filterWithKey((key, value) => key != "trending");

    return Wrap(
        spacing: smallScreen ? 3 : 12.0,
        runSpacing: 26,
        alignment: WrapAlignment.center,
        children: products.keys
            .expand((key) => [
                  if (isForCategory)
                    SizedBox(
                      width: swidth,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: smallScreen ? 12 : 25.0,
                              bottom: 18,
                              top: 8),
                          child: Text(
                            key.toString().toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: themeMode.primTextColor),
                          ),
                        ),
                      ),
                    ),
                  ...state.products[key]!.map((product) {
                    return ProductCard(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product)));
                      },
                      carted: cartedProducts.contains(product),
                      product: product,
                      cartAction: (cproduct) {
                        context
                            .read<CartCubit>()
                            .addToCart(cproduct, cartedProducts);
                      },
                    );
                  }),
                ])
            .toList());
  }
}
