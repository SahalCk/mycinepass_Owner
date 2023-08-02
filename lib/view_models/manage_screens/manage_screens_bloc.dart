// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/screen_model.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'manage_screens_event.dart';
part 'manage_screens_state.dart';

class ManageScreensBloc extends Bloc<ManageScreensEvent, ManageScreensState> {
  ManageScreensBloc() : super(ManageScreensInitial()) {
    on<GetAllScreensEvenet>(getAllScreensEvenet);
    on<AddNewScreenEvent>(addNewScreenEvent);
    on<UpdateScreenEvent>(updateScreenEvent);
    on<DeleteScreenEvent>(deleteScreenEvent);
  }

  FutureOr<void> getAllScreensEvenet(
      GetAllScreensEvenet event, Emitter<ManageScreensState> emit) async {
    List<ScreenModel> allScrens;
    emit(LoadingState());
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final userID = await storage.read(key: 'userId');
      final response =
          await APIServices().getAPIWithToken('select-screen/$userID', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      allScrens = List<ScreenModel>.from(status['data'].map((e) {
        ScreenModel screenmodel = ScreenModel.fromJson(e);
        return screenmodel;
      }));
      emit(AllScreensFetchedState(allScreens: allScrens));
    } catch (e) {
      emit(SomethinhWentWrongState(error: e.toString()));
    }
  }

  FutureOr<void> addNewScreenEvent(
      AddNewScreenEvent event, Emitter<ManageScreensState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _userID = await storage.read(key: 'userId');
      final respose = await APIServices().postAPIWithToken(
          'add-screen',
          {
            "owner": {"_id": _userID},
            "rows": event.numberOfRows,
            "columns": event.numberOfColumns,
            "screen": event.screenNumber
          },
          _token!);
      final status = jsonDecode(respose.body) as Map<String, dynamic>;
      if (status['success'] == true) {
        emit(NewScreenAddedState());
        add(GetAllScreensEvenet());
      } else if (status['message'] == 'Screen already exist') {
        emit(ScreenAddingFailedState(error: 'Screen already Exist!'));
        add(GetAllScreensEvenet());
      } else {
        emit(ScreenAddingFailedState(error: 'Something went wrong!'));
      }
    } catch (e) {
      emit(ScreenAddingFailedState(error: e.toString()));
    }
  }

  FutureOr<void> deleteScreenEvent(
      DeleteScreenEvent event, Emitter<ManageScreensState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final response = await APIServices().postAPIWithToken(
          'delete-screen', {"screenId": event.screenID}, _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['success'] == true) {
        emit(ScreenDeletedState());
        add(GetAllScreensEvenet());
      } else {
        emit(DeletionFailedState(error: 'Screen Deletion Failed'));
      }
    } catch (e) {
      emit(DeletionFailedState(error: e.toString()));
    }
  }

  FutureOr<void> updateScreenEvent(
      UpdateScreenEvent event, Emitter<ManageScreensState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _userID = await storage.read(key: 'userId');
      final respose = await APIServices().postAPIWithToken(
          'edit-screen',
          {
            "owner": {"_id": _userID},
            "rows": event.numberOfRows,
            "columns": event.numberOfColumns,
            "screen": event.screenNumber,
            "newId": event.screenID
          },
          _token!);
      final status = jsonDecode(respose.body) as Map<String, dynamic>;
      if (status['success'] == true) {
        emit(ScreenUpdatedState());
        add(GetAllScreensEvenet());
      } else {
        emit(ScreenUpdationFailedState(error: 'Screen Updation Failed'));
      }
    } catch (e) {
      emit(ScreenUpdationFailedState(error: e.toString()));
    }
  }
}
