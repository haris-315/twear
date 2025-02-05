part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {
  final bool byCategory;

  HomeLoading({this.byCategory = false});
}

final class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

final class HomeSuccess extends HomeState {
  final bool isCategorizing;
  final bool isCarted;
  final Map<dynamic, List<Product>> products;

  HomeSuccess({this.isCarted = false,this.isCategorizing = false, required this.products});
}
