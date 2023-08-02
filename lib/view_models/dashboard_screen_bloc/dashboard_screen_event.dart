part of 'dashboard_screen_bloc.dart';

@immutable
abstract class DashboardScreenEvent {}

class BottomNavigationBarOptionSelectedEvenet extends DashboardScreenEvent {
  final int index;
  BottomNavigationBarOptionSelectedEvenet({required this.index});
}
