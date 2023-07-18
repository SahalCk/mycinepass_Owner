part of 'splash_screen_bloc.dart';

@immutable
abstract class SplashScreenState {}

class SplashScreenInitial extends SplashScreenState {}

class NavigateToLoginScreen extends SplashScreenState {}

class NavigateToHomeScreen extends SplashScreenState {}
