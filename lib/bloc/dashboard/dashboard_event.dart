part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class PostNewProduct {
  final Product product;

  PostNewProduct({required this.product});
}

