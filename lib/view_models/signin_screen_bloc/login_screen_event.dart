part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenEvent {}

class ObscureValueChangedEvenet extends LoginScreenEvent {
  final bool currentValue;

  ObscureValueChangedEvenet({required this.currentValue});
}

class SigninButtonClickedEvent extends LoginScreenEvent {
  final String userName;
  final String password;

  SigninButtonClickedEvent({required this.userName, required this.password});
}
