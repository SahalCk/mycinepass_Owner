part of 'signup_screen_bloc.dart';

@immutable
abstract class SignupScreenEvent {}

class IDProofUploadEvent extends SignupScreenEvent {}

class SelectLocationFromGoogleMap extends SignupScreenEvent {}

class LocationFoundEvenet extends SignupScreenEvent {
  final String location;
  LocationFoundEvenet({required this.location});
}

class ValidateSignUp extends SignupScreenEvent {
  final TheaterOwnerModel theaterOwnerModel;
  ValidateSignUp({required this.theaterOwnerModel});
}

class ResedOtpEvenet extends SignupScreenEvent {
  final String email;
  ResedOtpEvenet({required this.email});
}

class OTPConfirmButtonPressedEvenet extends SignupScreenEvent {
  final String otp;
  final TheaterOwnerModel theaterOwnerModel;
  OTPConfirmButtonPressedEvenet(
      {required this.otp, required this.theaterOwnerModel});
}
