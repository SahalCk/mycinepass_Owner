import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/owner_model.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc() : super(ObscureValueChangedState(obscureValue: true)) {
    on<ObscureValueChangedEvenet>(obscureValueChangedEvenet);
    on<SigninButtonClickedEvent>(signinButtonClickedEvent);
  }

  FutureOr<void> obscureValueChangedEvenet(
      ObscureValueChangedEvenet event, Emitter<LoginScreenState> emit) {
    final currentValue = event.currentValue;

    if (currentValue == false) {
      emit(ObscureValueChangedState(obscureValue: true));
    } else {
      emit(ObscureValueChangedState(obscureValue: false));
    }
  }

  FutureOr<void> signinButtonClickedEvent(
      SigninButtonClickedEvent event, Emitter<LoginScreenState> emit) async {
    emit(LoadingState());
    try {
      final respose = await APIServices().postAPI(
          'login', {"email": event.userName, "password": event.password});
      final status = jsonDecode(respose.body) as Map<String, dynamic>;
      if (respose.statusCode == 200) {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: status['token']);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool('isAlreadyLoggedIn', true);
        final reseponse = await APIServices()
            .getAPIWithToken('getCurrentOwner', status['token']);
        final statusOwner = jsonDecode(reseponse.body) as Map<String, dynamic>;
        OwnerModel ownerModel = OwnerModel.fromJson(statusOwner['data']);
        await storage.write(key: 'userId', value: ownerModel.id);
        await storage.write(key: 'theaterName', value: ownerModel.name);
        emit(LoginSuccessState());
      } else {
        if (status.containsKey("noUser")) {
          emit(ErrorState(message: "User Doesn't Exist"));
        } else if (status['status'] == "Denied") {
          emit(ErrorState(
              message: "Your request is Dinied! Please try after sometimes"));
        } else if (status['status'] == "Pending") {
          emit(ErrorState(message: "Your request is Pending! Please Wait"));
        } else if (status['status'] == "You are Blocked") {
          emit(ErrorState(message: "Your Account is Blocked!"));
        } else if (status["incPass"] == true) {
          emit(ErrorState(message: "Incorrect Password"));
        }
      }
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
