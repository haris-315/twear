import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/date_calculator.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/discount.dart';
import 'package:t_wear/screens/global_widgets/ratings.dart';

class TrendingPicks extends StatefulWidget {
  final List<Product> trendingProducts;

  const TrendingPicks({required this.trendingProducts, super.key});

  @override
  State<TrendingPicks> createState() => _TrendingPicksState();
}

class _TrendingPicksState extends State<TrendingPicks> {
  final List<GlobalKey> _globalKeys = [];
  final Map<int, double> _infoBoxHeights = {};
  bool showRating = false;

  @override
  void initState() {
    super.initState();
    _globalKeys.addAll(
        List.generate(widget.trendingProducts.length, (_) => GlobalKey()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _globalKeys.length; i++) {
        final renderBox =
            _globalKeys[i].currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          _infoBoxHeights[i] = renderBox.size.height;
        }
      }
      setState(() {
        showRating = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CTheme themeMode = getThemeMode(context);
    final [swidth, sheight] = getScreenSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Text(
            "🔥 Trending Picks",
            style: TextStyle(
              fontSize: swidth < 400 ? 22 : 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: themeMode.primTextColor,
            ),
          ),
        ),
        const SizedBox(height: 22),
        CarouselSlider.builder(
          itemCount: widget.trendingProducts.length,
          itemBuilder: (context, index, realIndex) {
            final product = widget.trendingProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "inspect-product",
                    arguments: product);
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: themeMode.backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: product.images.first,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: themeMode.borderColor2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: themeMode.iconColor,
                              ),
                            ),
                          ),
                          Container(
                            key: _globalKeys[
                                index], // Use unique key for each item
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeMode.backgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: themeMode.primTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\$${product.price}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode.borderColor2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: swidth * .1,
                                    ),
                                    if (calculateDifference(product.postDate) <=
                                        40)
                                      const Discount(
                                        discount: "New",
                                      ),
                                    SizedBox(
                                      width: swidth * .1,
                                    ),
                                    if (product.discount != null &&
                                        product.discount != 0) ...[
                                      Discount(
                                          discount: "-${product.discount}%",
                                          color: Colors.red),
                                      SizedBox(
                                        width: swidth * .1,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showRating)
                    Positioned(
                      right: 9.5,
                      bottom: _infoBoxHeights[index] ?? 0,
                      child: ClipPath(
                          clipper: TrapezoidClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeMode.backgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 3, right: 2, bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: buildStars(product),
                              ),
                            ),
                          )),
                    ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            autoPlayCurve: Curves.easeInOutCubicEmphasized,
            height: swidth <= 600 ? 270 : 460,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 0.95,
          ),
        ),
      ],
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.2, 0); // Top-left (offset inward)
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height); // Bottom-right (offset inward)
    path.lineTo(0, size.height); // Bottom-left
    path.close(); // Close the path to form the trapezoid
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
