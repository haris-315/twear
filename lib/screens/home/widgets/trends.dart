import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/date_calculator.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/discount.dart';
import 'package:t_wear/screens/home/product_inspection_page.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

class TrendingPicks extends StatefulWidget {
  final List<Product> trendingProducts;

  const TrendingPicks({required this.trendingProducts, super.key});

  @override
  State<TrendingPicks> createState() => _TrendingPicksState();
}

class _TrendingPicksState extends State<TrendingPicks> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

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
        Column(
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: widget.trendingProducts.length,
              itemBuilder: (context, index, realIndex) {
                final product = widget.trendingProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(product: product)));
                  },
                  child: Container(
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
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: swidth <= 600 ? 270 : 460,
                            child: !isValidUrl(product.images.first.toString())
                                ? Image(
                                    image: MemoryImage(product.images.first),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context,child, chunk) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeMode.backgroundColor!,
                                            themeMode.backgroundColor!
                                                .withValues(alpha: 0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: themeMode.borderColor2,
                                          
                                        ),
                                      ),
                                    ),
                                    errorBuilder: (context, obj, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeMode.backgroundColor!,
                                            themeMode.backgroundColor!
                                                .withValues(alpha: 0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: themeMode.iconColor,
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: product.images.first,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeMode.backgroundColor!,
                                            themeMode.backgroundColor!
                                                .withValues(alpha: 0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: themeMode.borderColor2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeMode.backgroundColor!,
                                            themeMode.backgroundColor!
                                                .withValues(alpha: 0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: themeMode.iconColor,
                                      ),
                                    ),
                                  ),
                          ),
                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          // Product Details
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    tileMode: TileMode.mirror,
                                    colors: [
                                      Colors.black.withValues(alpha: .5),
                                      Colors.black.withValues(alpha: .2)
                                    ]),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rs. ${product.price} Only",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                      SizedBox(width: swidth * .1),
                                      if (calculateDifference(
                                              product.postDate) <=
                                          40)
                                        const Discount(
                                          discount: "New",
                                          size: 13,
                                        ),
                                      SizedBox(width: swidth * .1),
                                      if (product.discount != 0) ...[
                                        Discount(
                                            size: 12,
                                            discount:
                                                "-${product.discount.toStringAsFixed(0)}%",
                                            color: Colors.red),
                                        SizedBox(width: swidth * .1),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlayCurve: Curves.easeInOutCubicEmphasized,
                height: swidth <= 600 ? 270 : 460,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 0.95,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_currentIndex > 0) {
                      _carouselController.previousPage();
                    } else {
                      _carouselController.animateToPage(
                          widget.trendingProducts.length - 1,
                          duration: Duration(milliseconds: 120));
                    }
                  },
                  icon: Icon(Icons.arrow_left_outlined,
                      color: themeMode.iconColor),
                ),
                DotsIndicator(
                  dotsCount: widget.trendingProducts.length,
                  position: _currentIndex,
                  decorator: DotsDecorator(
                    activeColor: Colors.blueAccent,
                    size: const Size.square(8.0),
                    activeSize: const Size(18.0, 8.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_currentIndex < widget.trendingProducts.length - 1) {
                      _carouselController.nextPage();
                    } else {
                      _carouselController.animateToPage(0,
                          duration: Duration(milliseconds: 120));
                    }
                  },
                  icon: Icon(Icons.arrow_right_outlined,
                      color: themeMode.iconColor),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
