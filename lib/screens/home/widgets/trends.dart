import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/ratings.dart';

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
        // Section Title
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

        // Carousel Slider
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
                  // Card Background
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
                          // Product Image
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: product.images.first,
                              fit: BoxFit.cover,
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
                          // Product Details
                          Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Price
                                    Text(
                                      "\$${product.price}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode.borderColor2,
                                      ),
                                    ),
                                    // Rating Stars
                                    ...buildStars(product),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Discount Badge as Ribbon
                  if (product.discount != null && product.discount != 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Transform.rotate(
                        angle: 0.2, // Slight diagonal effect
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: swidth <= 600 ? 270 : 460,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
          ),
        ),
      ],
    );
  }
}
