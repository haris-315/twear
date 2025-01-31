import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';

class TrendingPicks extends StatelessWidget {
  final List<Product> trendingProducts;

  const TrendingPicks({required this.trendingProducts, super.key});

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
            "Trending Picks",
            style: TextStyle(
              fontSize: swidth < 400 ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: themeMode.primTextColor,
            ),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        CarouselSlider.builder(
          itemCount: trendingProducts.length,
          itemBuilder: (context, index, realIndex) {
            final product = trendingProducts[index];
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
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: themeMode.backgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: themeMode.primTextColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: themeMode.borderColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.discount != null && product.discount != 0)
                    Positioned(
                      top: 10,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "-${product.discount}%",
                          style: TextStyle(
                            color: themeMode.primTextColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 440,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
          ),
        ),
      ],
    );
  }
}
