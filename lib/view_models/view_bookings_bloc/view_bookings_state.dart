part of 'view_bookings_bloc.dart';

@immutable
abstract class ViewBookingsState {}

class ViewBookingsInitial extends ViewBookingsState {}

class ViewBookingsActionState extends ViewBookingsState {}

class LoadingState extends ViewBookingsState {}

class AllTransactionsGotState extends ViewBookingsState {
  final List<MovieBookingModel> allTransactions;
  AllTransactionsGotState({required this.allTransactions});
}

class FilteredTransactionsGotState extends ViewBookingsState {
  final List<MovieBookingModel> filteredList;
  FilteredTransactionsGotState({required this.filteredList});
}

class SomethinhWentWrongState extends ViewBookingsActionState {
  final String error;
  SomethinhWentWrongState({required this.error});
}
