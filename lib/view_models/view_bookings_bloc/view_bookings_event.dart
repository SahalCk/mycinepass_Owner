part of 'view_bookings_bloc.dart';

@immutable
abstract class ViewBookingsEvent {}

class GetAllTransactionsEvent extends ViewBookingsEvent {}

class GetFilteredTransactions extends ViewBookingsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final List<MovieBookingModel> allTransactions;

  GetFilteredTransactions(
      {required this.startDate,
      required this.endDate,
      required this.allTransactions});
}

class DownloadExcelEvent extends ViewBookingsEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<MovieBookingModel> allTransactions;

  DownloadExcelEvent(
      {required this.startDate,
      required this.endDate,
      required this.allTransactions});
}
