import 'package:flutter/material.dart';
import 'package:t_wear/models/product_model.dart';

List<Icon> buildStars(Product product) {
  return List.generate(
      5,
      (index) => Icon(
            Icons.star,
            color:
                index < product.avgRating() ? Colors.amberAccent : Colors.grey,
          ));
}
