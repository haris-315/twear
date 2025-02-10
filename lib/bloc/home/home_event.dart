part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LoadHomeData extends HomeEvent {
  final bool isCarting;
  final Product? product;
  final Map<dynamic, List<Product>>? productsMap;

  LoadHomeData({
    this.isCarting = false,
    this.product,
    this.productsMap,
  });
}

final class AddToCart extends HomeEvent {}

final class RemoveFromCart extends HomeEvent {
  final Product product;

  RemoveFromCart({required this.product});
}

final class GetByCategory extends HomeEvent {
  final Category category;

  GetByCategory({required this.category});
}

final class GetBySearch extends HomeEvent {
  final String query;

  GetBySearch({required this.query});
}
