import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/widgets/category.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    double swidth = getScreenSize(context).first;
    double sheight = getScreenSize(context).last;
    CTheme themeMode = getThemeMode(context);
    return Column(children: [
      Shimmer.fromColors(
          baseColor: themeMode.backgroundColor ?? Colors.red,
          highlightColor: themeMode.oppositeShimmerColor ?? Colors.white,
          child: SizedBox(
            height: swidth <= 500
                ? swidth < 400
                    ? swidth * 0.22
                    : swidth * 0.19
                : sheight * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: swidth <= 500
                      ? EdgeInsets.only(
                          left: swidth <= 400 ? 10 : 19.0,
                          top: 22,
                          bottom: 22,
                          right: swidth <= 400 ? 10 : 19.0)
                      : const EdgeInsets.only(
                          left: 19, right: 19, top: 16, bottom: 16),
                  child: CategoryItem(
                    skeletonMode: true,
                    name: categories[index].name,
                    img: categories[index].image,
                    themeMode: themeMode,
                  ),
                );
              },
            ),
          )),
      const SizedBox(
        height: 20,
      ),
      Shimmer.fromColors(
          baseColor: themeMode.backgroundColor ?? Colors.red,
          highlightColor: themeMode.oppositeShimmerColor ?? Colors.green,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: swidth <= 500
                      ? 2
                      : swidth <= 750
                          ? 3
                          : 4),
              itemBuilder: (context, index) {
                return ProductCard(
                  onTap: () {},
                  skeletonMode: true,
                );
              }))
    ]);
  }
}
