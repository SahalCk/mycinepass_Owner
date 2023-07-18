import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/theater_owner_model.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'signup_screen_event.dart';
part 'signup_screen_state.dart';

class SignupScreenBloc extends Bloc<SignupScreenEvent, SignupScreenState> {
  SignupScreenBloc() : super(SignupScreenInitial()) {
    on<SelectLocationFromGoogleMap>(selectLocationFromGoogleMap);
    on<IDProofUploadEvent>(iDProofUploadEvent);
    on<ValidateSignUp>(validateSignUp);
    on<ResedOtpEvenet>(resedOtpEvenet);
    on<OTPConfirmButtonPressedEvenet>(oTPConfirmButtonPressedEvenet);
    on<LocationFoundEvenet>(locationFoundEvenet);
  }

  FutureOr<void> iDProofUploadEvent(
      IDProofUploadEvent event, Emitter<SignupScreenState> emit) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      emit(PhotoUplaodErrorState());
    } else {
      final imagePath = image.path;
      emit(AdharPhotoUplaodedState(imagePath: imagePath));
    }
  }

  FutureOr<void> validateSignUp(
      ValidateSignUp event, Emitter<SignupScreenState> emit) async {
    emit(LoadingState());
    final theaterOwnerModel = event.theaterOwnerModel;
    if (mailvalidation(theaterOwnerModel.email)) {
      emit(InvalidEmailState());
    } else if (theaterOwnerModel.phoneNumber.length < 10) {
      emit(InvalidMobileNumberState());
    } else if (theaterOwnerModel.adharNumber.length < 12) {
      emit(InvalidAdharNumber());
    } else if (theaterOwnerModel.adharPhotoPath.isEmpty) {
      emit(AdharPhotoNotAddedState());
    } else if (theaterOwnerModel.password !=
        theaterOwnerModel.confrimPassword) {
      emit(PasswordMismatchesState());
    } else {
      try {
        final cloudinary = Cloudinary.signedConfig(
            apiKey: "976681121275463",
            apiSecret: "mmMY_18TTAi6nrm48kDVfDfa8Kw",
            cloudName: "dt55a1jw7");

        CloudinaryResponse response = await cloudinary.upload(
          file: event.theaterOwnerModel.adharPhotoPath,
          fileBytes:
              File(event.theaterOwnerModel.adharPhotoPath).readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
        );

        if (response.isSuccessful) {
          final imageUrl = response.secureUrl.toString();
          final http.Response apiResponse =
              await APIServices().postAPI('ownerOtp', {
            "Name": event.theaterOwnerModel.ownerName,
            "Email": event.theaterOwnerModel.email,
            "Adhaar": event.theaterOwnerModel.adharNumber,
            "Licence": event.theaterOwnerModel.licenseID,
            "Location": event.theaterOwnerModel.location,
            "Phone": event.theaterOwnerModel.phoneNumber,
            "Password": event.theaterOwnerModel.password,
          });
          log(apiResponse.body);
          final status = jsonDecode(apiResponse.body) as Map<String, dynamic>;
          if (status['message'] == 'Created the account') {
            event.theaterOwnerModel.adharPhotoPath = imageUrl;
            emit(NavigateToOtpScreen(ownerModel: event.theaterOwnerModel));
          } else if (status["ownerExist"] == true) {
            emit(OwnerAlreadyExistState());
          }
        } else {
          emit(SomethingWentWrongState());
        }
      } catch (e) {
        emit(SomethingWentWrongState(message: e.toString()));
      }
    }
  }

  bool mailvalidation(String email) {
    if (!email.contains('@') || !email.contains('.')) {
      return true;
    } else {
      final splitted = email.split('@');
      if (splitted[0].isEmpty) {
        return true;
      } else if (splitted[1].isEmpty) {
        return true;
      }
    }
    return false;
  }

  FutureOr<void> resedOtpEvenet(
      ResedOtpEvenet event, Emitter<SignupScreenState> emit) async {
    try {
      final response =
          await APIServices().postAPI('resendOtp', {"email": event.email});
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['otpSent'] == true) {
        emit(OTPResentState());
      } else {
        emit(SomethingWentWrongState());
      }
    } catch (e) {
      emit(SomethingWentWrongState(message: e.toString()));
    }
  }

  FutureOr<void> oTPConfirmButtonPressedEvenet(
      OTPConfirmButtonPressedEvenet event,
      Emitter<SignupScreenState> emit) async {
    emit(LoadingState());
    try {
      final response = await APIServices().postAPI('signUp', {
        "OwnerData": {
          "Name": event.theaterOwnerModel.ownerName,
          "Email": event.theaterOwnerModel.email,
          "Adhaar": event.theaterOwnerModel.adharNumber,
          "Licence": event.theaterOwnerModel.licenseID,
          "Location": event.theaterOwnerModel.location,
          "Phone": event.theaterOwnerModel.phoneNumber,
          "Password": event.theaterOwnerModel.password,
        },
        "imageData": event.theaterOwnerModel.adharPhotoPath,
        "otp": event.otp
      });

      if (response.statusCode == 200) {
        emit(SuccessPopupState());
        await Future.delayed(const Duration(seconds: 3));
        emit(AccountCreatedSuccessState());
      } else {
        emit(IncorrectOTPState());
      }
    } catch (e) {
      emit(SomethingWentWrongState(message: e.toString()));
    }
  }

  FutureOr<void> selectLocationFromGoogleMap(
      SelectLocationFromGoogleMap event, Emitter<SignupScreenState> emit) {
    emit(SelectLocationState());
  }

  FutureOr<void> locationFoundEvenet(
      LocationFoundEvenet event, Emitter<SignupScreenState> emit) {
    emit(LocationFoundState(location: event.location));
  }
}
