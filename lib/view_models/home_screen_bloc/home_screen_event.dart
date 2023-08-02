part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class GetAllValuesEvent extends HomeScreenEvent {}

class PiChartIndexTouchedEvent extends HomeScreenEvent {
  final int index;
  PiChartIndexTouchedEvent({required this.index});
}
