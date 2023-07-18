part of 'signup_screen_bloc.dart';

@immutable
abstract class SignupScreenState {}

class SignupScreenInitial extends SignupScreenState {}

abstract class SignUpActionState extends SignupScreenState {}

class SelectLocationState extends SignUpActionState {}

class LocationFoundState extends SignupScreenState {
  final String location;
  LocationFoundState({required this.location});
}

class AdharPhotoUplaodedState extends SignupScreenState {
  final String imagePath;

  AdharPhotoUplaodedState({required this.imagePath});
}

class PhotoUplaodErrorState extends SignUpActionState {}

class InvalidEmailState extends SignUpActionState {}

class InvalidMobileNumberState extends SignUpActionState {}

class InvalidAdharNumber extends SignUpActionState {}

class AdharPhotoNotAddedState extends SignUpActionState {}

class PasswordMismatchesState extends SignUpActionState {}

class LoadingState extends SignUpActionState {}

class SomethingWentWrongState extends SignUpActionState {
  final String? message;

  SomethingWentWrongState({this.message});
}

class OwnerAlreadyExistState extends SignUpActionState {}

class NavigateToOtpScreen extends SignUpActionState {
  final TheaterOwnerModel ownerModel;
  NavigateToOtpScreen({required this.ownerModel});
}

class OTPResentState extends SignUpActionState {}

class IncorrectOTPState extends SignUpActionState {}

class SuccessPopupState extends SignUpActionState {}

class AccountCreatedSuccessState extends SignUpActionState {}
