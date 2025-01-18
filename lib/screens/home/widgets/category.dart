import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/category.dart';
import 'package:t_wear/screens/global_widgets/glowing_container.dart';

class CategoryItem extends StatelessWidget {
  final CTheme themeMode;
  final String img;
  final String name;
  const CategoryItem(
      {super.key,
      required this.themeMode,
      required this.img,
      required this.name});

  @override
  Widget build(BuildContext context) {
    final width = getScreenSize(context).first;
    final height = getScreenSize(context).elementAt(1);

    return width <= 500
        ? FittedBox(
            child: glowingContainer(
              height: 60,
              fillColor: themeMode.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    name,
                    style:
                        TextStyle(color: themeMode.primTextColor, fontSize: 18),
                  ),
                ),
              ),
              themeMode: themeMode,
            ),
          )
        : glowingContainer(
            radius: 14,
            fillColor: themeMode.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: height * .09,
                      foregroundImage: NetworkImage(
                        img,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      name,
                      style: TextStyle(color: themeMode.primTextColor),
                    ),
                  ],
                ),
              ),
            ),
            themeMode: themeMode,
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
