part of 'manage_screens_bloc.dart';

@immutable
abstract class ManageScreensState {}

class ManageScreensInitial extends ManageScreensState {}

abstract class ManageScreenActionState extends ManageScreensState {}

class LoadingState extends ManageScreensState {}

class AllScreensFetchedState extends ManageScreensState {
  final List<ScreenModel> allScreens;
  AllScreensFetchedState({required this.allScreens});
}

class NewScreenAddedState extends ManageScreenActionState {}

class ScreenUpdatedState extends ManageScreenActionState {}

class ScreenUpdationFailedState extends ManageScreenActionState {
  final String error;
  ScreenUpdationFailedState({required this.error});
}

class ScreenAddingFailedState extends ManageScreenActionState {
  final String error;
  ScreenAddingFailedState({required this.error});
}

class ScreenDeletedState extends ManageScreenActionState {}

class DeletionFailedState extends ManageScreenActionState {
  final String error;
  DeletionFailedState({required this.error});
}

class SomethinhWentWrongState extends ManageScreenActionState {
  final String error;
  SomethinhWentWrongState({required this.error});
}
