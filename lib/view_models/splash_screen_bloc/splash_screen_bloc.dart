import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<NavigateToEvenet>(navigateToEvenet);
  }

  FutureOr<void> navigateToEvenet(
      NavigateToEvenet event, Emitter<SplashScreenState> emit) async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final currentStatus = sharedPreferences.getBool('isAlreadyLoggedIn');
    if (currentStatus == null) {
      await sharedPreferences.setBool('isAlreadyLoggedIn', false);
    }

    if (currentStatus == false) {
      emit(NavigateToLoginScreen());
    } else if (currentStatus == true) {
      emit(NavigateToHomeScreen());
    }
  }
}
