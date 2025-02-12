import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/models/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartSuccess(cartedProdcuts: []));

   addToCart(Product product, List<Product>? cart) {
    return emit(CartSuccess(cartedProdcuts: [...?cart, product]));
  }

  removeFromCart(Product product, List<Product> cart) {
    cart.remove(product);
    return emit(CartSuccess(cartedProdcuts: cart));
  }
}
