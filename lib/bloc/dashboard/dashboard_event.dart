part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class PostNewProduct {
  final Product product;

  PostNewProduct({required this.product});
}

final class FeedProducts extends DashboardEvent {
  final Map<dynamic,List<Product>> products;

  FeedProducts({required this.products});
}

final class GetDashboardDetails extends DashboardEvent {}