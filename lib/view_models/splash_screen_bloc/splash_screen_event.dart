part of 'splash_screen_bloc.dart';

@immutable
abstract class SplashScreenEvent {}

class SetUpOneSignal extends SplashScreenEvent {}

class NavigateToEvenet extends SplashScreenEvent {}

class CheckConnectivityEvenet extends SplashScreenEvent {}
