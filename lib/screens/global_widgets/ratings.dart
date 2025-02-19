import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/models/product_model.dart';

List<Widget> buildStars({ required Product product,bool shrinkMode = false,required CTheme themeMode}) {
  return shrinkMode ? [Icon(Icons.star,color: Colors.amberAccent), Text(product.avgRating().toString(),style: TextStyle(color: themeMode.secondaryTextColor),)] : List.generate(
      5,
      (index) => Icon(
            Icons.star,
            color:
                index < product.avgRating() ? Colors.amberAccent : Colors.grey,
          ));
}
