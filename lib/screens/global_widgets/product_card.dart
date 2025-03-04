import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/utils/card_dimensions.dart';
import 'package:t_wear/core/utils/date_calculator.dart';
import 'package:t_wear/core/utils/get_admin_stat.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/delete_confirm.dart';
import 'package:t_wear/screens/global_widgets/discount.dart';
import 'package:t_wear/screens/global_widgets/ratings.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

class ProductCard extends StatefulWidget {
  final Product? product;
  final bool skeletonMode;
  final Function(Product product)? cartAction;
  final VoidCallback onTap;
  final bool carted;
  final bool isAdmin;

  const ProductCard(
      {super.key,
      this.product,
      this.isAdmin = false,
      required this.onTap,
      this.skeletonMode = false,
      this.cartAction,
      this.carted = false});

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
    bool admin = isAdmin(context);

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
                // margin: const EdgeInsets.all(12),
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
                                    child: !isValidUrl(widget.product!.images[0]
                                            .toString())
                                        ? Image(
                                            image: MemoryImage(
                                                widget.product!.images[0]),
                                            loadingBuilder:
                                                (con, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                    color:
                                                        themeMode.borderColor2,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (con, obj, error) =>
                                                Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.image,
                                                size: 50,
                                                color: themeMode.iconColor,
                                              ),
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: widget.product!.images[0],
                                            fit: BoxFit.contain,
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Center(
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeMode.secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Text(
                                      widget.product!.discount != 0
                                          ? "Rs.${(widget.product!.price / (1 - (widget.product!.discount / 100))).toStringAsFixed(0)}"
                                          : "Rs.${widget.product!.price.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        color: widget.product!.discount != 0
                                            ? themeMode.secondaryTextColor
                                            : themeMode.borderColor2,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationThickness: 2,
                                        decorationColor: themeMode.borderColor2,
                                        decoration:
                                            widget.product!.discount != 0
                                                ? TextDecoration.lineThrough
                                                : null,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    if (widget.product!.discount != 0)
                                      Text(
                                        "Rs.${widget.product!.price.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: themeMode.borderColor2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: buildStars(
                                            product: widget.product!,
                                            themeMode: themeMode,
                                            shrinkMode: true),
                                      ),
                                      Spacer(),
                                      if (admin) ...[
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "postproduct",
                                                  arguments: widget.product!);
                                            },
                                            icon: const Icon(
                                              Icons.edit_note_rounded,
                                              color: Colors.amberAccent,
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              bool delete =
                                                  await showConfirmationDialog(
                                                      context, themeMode);
                                              if (delete) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  context.read<HomeBloc>().add(
                                                      DeleteProduct(
                                                          product:
                                                              widget.product!));
                                                });
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.amberAccent,
                                            )),
                                      ] else
                                        FittedBox(
                                          child: widget.carted
                                              ? IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.lightGreen,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    widget.cartAction!(
                                                        widget.product!);
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                    color: Colors.amberAccent,
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
                      top: 1,
                      right: 1,
                      child: Discount(
                        discount: "New",
                        size: 15,
                      )),
                if (widget.product!.discount != 0)
                  Positioned(
                      top: calculateDifference(widget.product!.postDate) <= 40
                          ? 37
                          : 1,
                      right: 1,
                      child: Discount(
                        discount:
                            "-${widget.product!.discount.toStringAsFixed(0)}%",
                        color: Colors.red,
                        size: 13,
                      )),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

