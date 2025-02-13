import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/cart_cubit.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/product_inspection_page.dart';
import 'package:t_wear/screens/home/widgets/category.dart';
import 'package:t_wear/screens/home/widgets/shimmer_effect.dart';
import 'package:t_wear/screens/home/widgets/trends.dart';

// ignore: library_private_types_in_public_api
final GlobalKey<_HomeState> homeKey = GlobalKey();

class Home extends StatefulWidget {
  Home({
    key,
  }) : super(key: homeKey);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotateAnimation = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      _controller.forward();
    });
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
          endDrawer: CustomDrawer(themeMode: themeMode),
          floatingActionButton: ScaleTransition(
            scale: _scaleAnimation,
            child: RotationTransition(
              turns: _rotateAnimation,
              child: Container(

                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: themeMode.borderColor ?? Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(colors: [themeMode.oppositeShimmerColor!.withValues(alpha: .7),themeMode.oppositeShimmerColor!.withValues(alpha: .2)])
                      
                      
                ),
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
                        children: [
                          _categoryBuilder(swidth, sheight, themeMode),
                          const SizedBox(
                            height: 40,
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
                              themeMode,
                              cartState is CartSuccess
                                  ? cartState.cartedProdcuts
                                  : [])
                        ],
                      );
                    },
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


  Widget _buildProducts(HomeSuccess state, double swidth, double sheight,
      CTheme themeMode, List<Product> cartedProducts) {
    bool smallScreen = swidth <= 500;
    return Wrap(
      children: state.products.keys.expand(
            (key) => [
              if (key == "trending")
                SizedBox()
              else
                ...[SizedBox(
      width: swidth,
      child: Padding(
      padding: EdgeInsets.only(left: smallScreen ? 12 : 25.0,bottom: 18,top: 8),
      child: Text(
        key.toString().toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: themeMode.primTextColor),
      ),
    ),),

    ...state.products[key]!.map((product) {
      return ProductCard(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                                product: product)));
                  },
                  carted: cartedProducts.contains(product),
                  product: product,
                  cartAction: (cproduct) {
                    context
                        .read<CartCubit>()
                        .addToCart(cproduct, cartedProducts);
                  },
                );
              })],]).toList());




  }

}
