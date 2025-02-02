import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/category.dart';

class CategoryItem extends StatefulWidget {
  final CTheme themeMode;
  final Category category;
  final bool skeletonMode;

  const CategoryItem({
    super.key,
    required this.themeMode,
    this.skeletonMode = false,
    required this.category,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = getScreenSize(context).first;
    final height = getScreenSize(context).elementAt(1);
    final themeMode = getThemeMode(context);
    return GestureDetector(
      onTap: () {
        context.read<HomeBloc>().add(GetByCategory(category: widget.category));
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Transform.scale(
          scale: isHovered ? 1.05 : 1.0, // Scale the widget on hover
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 960),
            curve: Curves.easeInOut,
            height: width <= 500 ? 40 : null,
            decoration: BoxDecoration(
              color: themeMode.buttonColor,
              borderRadius: BorderRadius.circular(width <= 500 ? 10 : 16),
              boxShadow: [
                BoxShadow(
                  color: themeMode.shadowColor ??
                      Colors.black.withValues(alpha: isHovered ? 0.4 : 0.2),
                  blurRadius: isHovered ? 19 : 15,
                  offset: const Offset(0, 4),
                ),
              ],
              // border: Border.all(
              //   color: themeMode.borderColor ?? Colors.grey,
              //   width: 1.5,
              // ),
            ),
            child: width <= 500
                ? widget.skeletonMode
                    ? const SizedBox(
                        width: 80,
                        height: 40,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Text(
                            widget.category.name,
                            style: TextStyle(
                              color: widget.themeMode.primTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * .09,
                            foregroundImage: widget.skeletonMode
                                ? null
                                : CachedNetworkImageProvider(
                                  errorListener: (_) => Icon(Icons.error,color: themeMode.iconColor,),
                                    widget.category.image),
                            backgroundColor: Colors.grey[300],
                            child: widget.skeletonMode
                                ? Icon(Icons.category,
                                    size: height * 0.05,
                                    color: Colors.grey[600])
                                : null,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.category.name,
                            style: TextStyle(
                                color: widget.themeMode.primTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

List<Category> categories = [
  Category(
      name: "Fashion",
      id: 1,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218212/c1_vl9lgi.webp"),
  Category(
      name: "Men",
      id: 2,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218213/c2_eeulzq.webp"),
  Category(
      name: "Women",
      id: 5,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218252/c5_rtvniw.webp"),
  Category(
      name: "Traditional",
      id: 3,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218241/c3_t7toca.webp"),
  Category(
      name: "Winter",
      id: 4,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218210/c4_injdfj.webp"),
  Category(
      name: "Perfumes",
      id: 6,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218210/c6_u6xdn4.webp"),
  Category(
      name: "Kid's",
      id: 7,
      image:
          "https://res.cloudinary.com/dume7lvn5/image/upload/v1737218227/c7_tyirhd.webp"),
];
