part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

abstract class HomeScreenActionState extends HomeScreenState {}

abstract class HomeScreenPieChartState extends HomeScreenState {}

abstract class HomeScreenGraphState extends HomeScreenState {}

class LoadingState extends HomeScreenState {}

class ErrorState extends HomeScreenActionState {
  final String error;
  ErrorState({required this.error});
}

class AllValuesFetchedState extends HomeScreenState {
  final String userName;
  final String dailySale;
  final String monthlySale;
  final List<dynamic> listOfMonths;
  final String yearlySale;
  final String booked;
  final String cancelled;
  final String totalRevenue;
  final String totalBookings;
  final String activeBookings;
  final String expiredBookings;
  final double bookedPercentage;
  final double cancelledPercentage;

  AllValuesFetchedState(
      {required this.userName,
      required this.dailySale,
      required this.monthlySale,
      required this.listOfMonths,
      required this.yearlySale,
      required this.booked,
      required this.cancelled,
      required this.totalRevenue,
      required this.totalBookings,
      required this.activeBookings,
      required this.expiredBookings,
      required this.bookedPercentage,
      required this.cancelledPercentage});
}

class PiChartIndexIsTouched extends HomeScreenPieChartState {
  final int index;
  PiChartIndexIsTouched({required this.index});
}
