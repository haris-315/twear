part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class IsNotAdmin extends AdminState {}

final class IsAdmin extends AdminState {}