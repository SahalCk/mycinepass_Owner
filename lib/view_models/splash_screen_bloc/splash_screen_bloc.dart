import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<NavigateToEvenet>(navigateToEvenet);
    on<SetUpOneSignal>(setUpOneSignal);
  }

  FutureOr<void> navigateToEvenet(
      NavigateToEvenet event, Emitter<SplashScreenState> emit) async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool('isAlreadyLoggedIn') == null) {
      await sharedPreferences.setBool('isAlreadyLoggedIn', false);
    }

    final currentStatus = sharedPreferences.getBool('isAlreadyLoggedIn');
    if (currentStatus == false) {
      emit(NavigateToLoginScreen());
    } else if (currentStatus == true) {
      emit(NavigateToHomeScreen());
    }
  }

  FutureOr<void> setUpOneSignal(
      SetUpOneSignal event, Emitter<SplashScreenState> emit) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("df2bbf91-cf63-4ef8-aecc-48d2a197a861");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      log("Accepted permission: $accepted");
    });
    emit(OneSignalSetupCompleatedState());
  }
}
