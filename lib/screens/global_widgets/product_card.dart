import 'package:flutter/material.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = getThemeMode(context);
    double width = getScreenSize(context).first;
    // ignore: unused_local_variable
    double height = getScreenSize(context).last;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width <= 450
            ? width * .6
            : width <= 600
                ? width * .5
                : width <= 700
                    ? width * .4
                    : width * .26,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeMode.buttonColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: themeMode.shadowColor ?? Colors.black.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: themeMode.borderColor ?? Colors.grey,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: product.images.isNotEmpty
                  ? AspectRatio(
                      aspectRatio:
                          1.5, // Ensures consistent height-to-width ratio
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit
                            .contain, // Ensures the whole image fits inside
                        errorBuilder: (context, error, stackTrace) => Container(
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

            // Product Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18, // Slightly increased font size
                      fontWeight: FontWeight.bold,
                      color: themeMode.primTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Company and Category
                  Text(
                    "By ${product.company} - ${product.category.name}",
                    style: TextStyle(
                      fontSize: 14,
                      color: themeMode.secondaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price, Discount, and Stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: themeMode.borderColor2,
                            ),
                          ),
                          if (product.discount != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '-${product.discount!.toStringAsFixed(0)}%',
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
                        product.stock > 0 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: product.stock > 0
                              ? themeMode.borderColor2
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Delivery Time
                  Row(
                    children: [
                      const Icon(Icons.local_shipping, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Delivery: ${product.delivery} days',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Target Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size: ${product.size}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                      Text(
                        'Gender: ${product.gender}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                      Text(
                        'Age: ${product.targetAge}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeMode.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
