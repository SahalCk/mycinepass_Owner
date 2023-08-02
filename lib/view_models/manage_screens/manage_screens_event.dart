part of 'manage_screens_bloc.dart';

@immutable
abstract class ManageScreensEvent {}

class GetAllScreensEvenet extends ManageScreensEvent {}

class AddNewScreenEvent extends ManageScreensEvent {
  final String screenNumber;
  final String numberOfColumns;
  final String numberOfRows;

  AddNewScreenEvent(
      {required this.screenNumber,
      required this.numberOfColumns,
      required this.numberOfRows});
}

class UpdateScreenEvent extends ManageScreensEvent {
  final String screenNumber;
  final String numberOfColumns;
  final String numberOfRows;
  final String screenID;

  UpdateScreenEvent(
      {required this.screenNumber,
      required this.numberOfColumns,
      required this.numberOfRows,
      required this.screenID});
}

class DeleteScreenEvent extends ManageScreensEvent {
  final String screenID;
  DeleteScreenEvent({required this.screenID});
}
