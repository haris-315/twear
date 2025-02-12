part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartSuccess extends CartState {
  final List<Product> cartedProdcuts;

  CartSuccess({required this.cartedProdcuts});
}

