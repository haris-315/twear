part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {
  final Map<String,dynamic> dashboardDetails;

  DashboardSuccess({required this.dashboardDetails});
}

final class DashboardError extends DashboardState {}