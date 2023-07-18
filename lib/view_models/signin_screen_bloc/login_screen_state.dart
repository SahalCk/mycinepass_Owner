part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenState {}

class LoginScreenInitial extends LoginScreenState {}

abstract class LoginScreenActionState extends LoginScreenState {}

class ObscureValueChangedState extends LoginScreenState {
  final bool obscureValue;

  ObscureValueChangedState({required this.obscureValue});
}

class LoadingState extends LoginScreenActionState {}

class ErrorState extends LoginScreenActionState {
  final String message;
  ErrorState({required this.message});
}

class LoginSuccessState extends LoginScreenActionState {}
