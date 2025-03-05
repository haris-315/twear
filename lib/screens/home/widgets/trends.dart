import 'dart:async';

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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.trendingProducts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CTheme themeMode = getThemeMode(context);
    final [swidth, sheight] = getScreenSize(context);

    final bool isLargeScreen = swidth > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            "🔥 Trending Picks",
            style: TextStyle(
              fontSize: swidth < 400 ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: themeMode.primTextColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isLargeScreen)
          // Large Screen Layout: Compact Custom Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: 320, // Reduced height for compactness
              child: Row(
                children: [
                  // Left Side: Big Card
                  Expanded(
                    flex: 2,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: _buildProductCard(
                        key: ValueKey(widget.trendingProducts[_currentIndex].id),
                        product: widget.trendingProducts[_currentIndex],
                        themeMode: themeMode,
                        isBig: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right Side: Two Small Cards
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Top Small Card
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: _buildProductCard(
                              key: ValueKey(widget.trendingProducts[(_currentIndex + 1) % widget.trendingProducts.length].id),
                              product: widget.trendingProducts[(_currentIndex + 1) % widget.trendingProducts.length],
                              themeMode: themeMode,
                              isBig: false,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: _buildProductCard(
                              key: ValueKey(widget.trendingProducts[(_currentIndex + 2) % widget.trendingProducts.length].id),
                              product: widget.trendingProducts[(_currentIndex + 2) % widget.trendingProducts.length],
                              themeMode: themeMode,
                              isBig: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Small Screen Layout: Simple Carousel
          CarouselSlider.builder(
            itemCount: widget.trendingProducts.length,
            itemBuilder: (context, index, realIndex) {
              final product = widget.trendingProducts[index];
              return _buildProductCard(
                key: ValueKey(product.id),
                product: product,
                themeMode: themeMode,
                isBig: true,
              );
            },
            options: CarouselOptions(
              autoPlayCurve: Curves.easeInOut,
              height: 270,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex - 1 + widget.trendingProducts.length) % widget.trendingProducts.length;
                });
              },
              icon: Icon(Icons.arrow_left_outlined, color: themeMode.iconColor),
            ),
            DotsIndicator(
              dotsCount: widget.trendingProducts.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                activeColor: Colors.blueAccent,
                size: const Size.square(8.0),
                activeSize: const Size(18.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex + 1) % widget.trendingProducts.length;
                });
              },
              icon: Icon(Icons.arrow_right_outlined, color: themeMode.iconColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required Key key,
    required Product product,
    required CTheme themeMode,
    required bool isBig,
  }) {
    return GestureDetector(
      key: key,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: themeMode.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: !isValidUrl(product.images.first.toString())
                    ? Image(
                        image: MemoryImage(product.images.first),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, chunk) =>
                            _buildLoadingPlaceholder(themeMode),
                        errorBuilder: (context, obj, error) =>
                            _buildErrorPlaceholder(themeMode),
                      )
                    : CachedNetworkImage(
                        imageUrl: product.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildLoadingPlaceholder(themeMode),
                        errorWidget: (context, url, error) =>
                            _buildErrorPlaceholder(themeMode),
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
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
                          fontSize: isBig ? 18 : 16,
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
                              fontSize: isBig ? 16 : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.amberAccent,
                            ),
                          ),
                          const Spacer(),
                          if (calculateDifference(product.postDate) <= 40)
                            const Discount(
                              discount: "New",
                              size: 12,
                            ),
                          if (product.discount != 0) ...[
                            const SizedBox(width: 8),
                            Discount(
                              size: 12,
                              discount: "-${product.discount.toStringAsFixed(0)}%",
                              color: Colors.red,
                            ),
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
  }

  Widget _buildLoadingPlaceholder(CTheme themeMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeMode.backgroundColor!,
            themeMode.backgroundColor!.withValues(alpha: 0.5),
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
    );
  }

  Widget _buildErrorPlaceholder(CTheme themeMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeMode.backgroundColor!,
            themeMode.backgroundColor!.withValues(alpha: 0.5),
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
    );
  }
}