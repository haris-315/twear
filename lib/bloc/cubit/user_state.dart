// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class Buyer extends UserState {
  final List<Product> orders;
  Buyer({
    required this.orders,
  });
}

final class Admin extends UserState {}