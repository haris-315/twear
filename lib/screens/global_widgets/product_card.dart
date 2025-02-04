import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t_wear/core/utils/card_dimensions.dart';
import 'package:t_wear/core/utils/date_calculator.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/discount.dart';
import 'package:t_wear/screens/global_widgets/ratings.dart';

class ProductCard extends StatefulWidget {
  final Product? product;
  final bool skeletonMode;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    this.product,
    required this.onTap,
    this.skeletonMode = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double aspectRatio = 1.5;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = getThemeMode(context);
    final [screenWidth, screenHeight] = getScreenSize(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform.scale(
          scale: isHovered ? 1.05 : 1.0,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 950),
                curve: Curves.easeInOut,
                width: responsiveWidth(screenWidth),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeMode.buttonColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: themeMode.shadowColor ??
                          Colors.black.withValues(alpha: isHovered ? 0.4 : 0.2),
                      blurRadius: isHovered ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: themeMode.borderColor ?? Colors.grey,
                    width: 1.5,
                  ),
                ),
                child: widget.skeletonMode
                    ? SizedBox(
                        width: responsiveWidth(screenWidth),
                        height: 260,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: widget.product!.images.isNotEmpty
                                ? AspectRatio(
                                    aspectRatio: screenWidth < 600 ? 1.2 : 1.4,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.product!.images[0],
                                      fit: BoxFit.contain,
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            color: themeMode.borderColor2,
                                          ),
                                        ),
                                      ),
                                      errorWidget:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                          color: themeMode.iconColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: themeMode.iconColor,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: widget.product?.name,
                                  child: Text(
                                    widget.product!.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeMode.primTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "By ${widget.product?.company} - ${widget.product?.category.name}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeMode.secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Row(children: [
                                  ...buildStars(widget.product!),
                                  FittedBox(
                                    child: IconButton(
                                        iconSize: 43,
                                        onPressed: () {
                                          print(
                                              "Trying to cart ${widget.product!.name}");
                                        },
                                        icon: const Icon(
                                          Icons.shopify_rounded,
                                          color: Colors.lightGreen,
                                        )),
                                  )
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              if (widget.product != null) ...[
                if (calculateDifference(widget.product!.postDate) <= 40)
                  const Positioned(
                      top: 13,
                      right: 13,
                      child: Discount(
                        discount: "New",
                        size: 15,
                      )),
                if (widget.product!.discount != null &&
                    widget.product!.discount != 0)
                  Positioned(
                      top: calculateDifference(widget.product!.postDate) <= 40
                          ? 48
                          : 13,
                      right: 13,
                      child: Discount(
                        discount: "-${widget.product!.discount ?? 9}%",
                        color: Colors.red,
                        size: 14,
                      )),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
