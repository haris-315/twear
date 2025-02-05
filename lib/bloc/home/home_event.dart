part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LoadHomeData extends HomeEvent {}
final class AddToCart extends HomeEvent {
}

final class GetByCategory extends HomeEvent {
  final Category category;

  GetByCategory({required this.category});
}

final class GetBySearch extends HomeEvent {
  final String query;

  GetBySearch({required this.query});
}
