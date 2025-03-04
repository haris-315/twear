part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LoadHomeData extends HomeEvent {
  final Map<dynamic, List<Product>>? productsMap;
  final BuildContext? context;

  LoadHomeData(
    this.context, {
    this.productsMap,
  });
}

final class GetByCategory extends HomeEvent {
  final Category category;

  GetByCategory({required this.category});
}

final class GetBySearch extends HomeEvent {
  final String query;

  GetBySearch({required this.query});
}

final class AddProduct extends HomeEvent {
  final Product product;

  AddProduct({required this.product});
}
final class UpdateProduct extends HomeEvent {
  final Product product;

  UpdateProduct({required this.product});
}
final class DeleteProduct extends HomeEvent {
  final Product product;

  DeleteProduct({required this.product});
}
