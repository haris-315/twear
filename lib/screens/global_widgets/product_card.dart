import 'package:flutter/material.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';

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
    final double screenWidth = getScreenSize(context).first;

    double cardWidth = screenWidth <= 450
        ? screenWidth * 0.6
        : screenWidth <= 600
            ? screenWidth * 0.5
            : screenWidth <= 790
                ? screenWidth * 0.35
                : screenWidth <= 900
                    ? screenWidth * 0.3
                    : screenWidth * .24;

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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 950),
            curve: Curves.easeInOut,
            width: cardWidth,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeMode.buttonColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: themeMode.shadowColor ??
                      Colors.black.withOpacity(isHovered ? 0.4 : 0.2),
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
                    width: cardWidth,
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
                                aspectRatio: aspectRatio,
                                child: Image.network(
                                  widget.product!.images[0],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
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
                            const SizedBox(height: 8),
                            Text(
                              "By ${widget.product?.company} - ${widget.product?.category.name}",
                              style: TextStyle(
                                fontSize: 14,
                                color: themeMode.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${widget.product?.price.toStringAsFixed(2)} Rs',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode.borderColor2,
                                      ),
                                    ),
                                    if (widget.product?.discount != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '-${widget.product?.discount!.toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  widget.product!.stock > 0
                                      ? 'In Stock'
                                      : 'Out of Stock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: widget.product!.stock > 0
                                        ? themeMode.borderColor2
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  size: 18,
                                  color: themeMode.iconColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Delivery: ${widget.product?.delivery} Rs',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeMode.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildItem(
                                  themeMode.secondaryTextColor,
                                  "Size",
                                  widget.product!.size,
                                ),
                                _buildItem(
                                  themeMode.secondaryTextColor,
                                  "Gender",
                                  widget.product!.gender,
                                ),
                                _buildItem(
                                  themeMode.secondaryTextColor,
                                  "Age",
                                  widget.product!.targetAge,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _buildItem(Color? color, String t1, String t2) => Column(
        children: [
          Text(
            t1,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
          Text(
            t2,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      );
}
