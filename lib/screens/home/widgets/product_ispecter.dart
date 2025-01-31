import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

class ProductInspecter extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  ProductInspecter({super.key});

  @override
  Widget build(BuildContext context) {
    var [width, height] = getScreenSize(context);
    CTheme themeMode = getThemeMode(context);
    Product product = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
        backgroundColor: themeMode.backgroundColor,
        appBar:
            NavBar(themeMode: themeMode, scrollController: scrollController),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
                height: 300,
                width: width,
                child: CarouselView(
                    itemExtent: width,
                    enableSplash: false,
                    children: List.generate(
                        product.images.length,
                        (index) => isValidUrl(product.images[index])
                            ? Image.network(product.images[index])
                            : Image.memory(
                                base64Decode(product.images[index])))),
              )
            ],
          ),
        ));
  }
}
