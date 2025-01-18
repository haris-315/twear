// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/products_repo.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/product_card.dart';
import 'package:t_wear/screens/home/widgets/category.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  late List<Product> products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final double swidth = MediaQuery.of(context).size.width;
    final double sheight = MediaQuery.of(context).size.height;
    final CTheme themeMode = getThemeMode(context);

    return Scaffold(
      backgroundColor: themeMode.backgroundColor,
      appBar: NavBar(
        themeMode: themeMode,
        scrollController: scrollController,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              width: swidth,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
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
                                  left: swidth <= 400 ? 8 : 19.0,
                                  top: 16,
                                  bottom: 16,
                                  right: swidth <= 400 ? 8 : 19.0)
                              : const EdgeInsets.only(
                                  left: 19, right: 19, top: 16, bottom: 16),
                          child: CategoryItem(
                            name: categories[index].name,
                            img: categories[index].image,
                            themeMode: themeMode,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ProductCard(
              product: products.first,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
