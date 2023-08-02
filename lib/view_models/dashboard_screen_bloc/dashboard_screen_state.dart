part of 'dashboard_screen_bloc.dart';

@immutable
abstract class DashboardScreenState {}

class DashboardScreenInitial extends DashboardScreenState {}

abstract class DashboardScreenActionState extends DashboardScreenState {}

class BottomNavigationItemSelectedState extends DashboardScreenState {
  final int index;

  BottomNavigationItemSelectedState({required this.index});
}
