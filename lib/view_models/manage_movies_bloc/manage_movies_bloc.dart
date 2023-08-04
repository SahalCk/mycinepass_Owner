// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/movie_model.dart';
import 'package:cinepass_owner/models/screen_model.dart';
import 'package:cinepass_owner/services/api_keys.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'manage_movies_event.dart';
part 'manage_movies_state.dart';

class ManageMoviesBloc extends Bloc<ManageMoviesEvent, ManageMoviesState> {
  ManageMoviesBloc() : super(ManageMoviesInitial()) {
    on<GetAllMoviesEvent>(getAllMoviesEvent);
    on<DeleteShowEvent>(deleteShowEvent);
    on<GetAllAvailableMovieListEvent>(getAllAvailableMovieListEvent);
    on<AddNewMovieEvent>(addNewMovieEvent);
    on<UpdateMovieEvent>(updateMovieEvent);
  }

  FutureOr<void> getAllMoviesEvent(
      GetAllMoviesEvent event, Emitter<ManageMoviesState> emit) async {
    emit(LoadingState());
    try {
      List<MovieModel> allMovies;
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _userID = await storage.read(key: 'userId');
      final response =
          await APIServices().getAPIWithToken('get-shows/$_userID', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      allMovies = List<MovieModel>.from(status['data'].map((e) {
        MovieModel model = MovieModel.fromJson(e);
        return model;
      }));
      emit(AllMoviesGotState(movieModelList: allMovies));
    } catch (e) {
      emit(SomethinhWentWrongState(error: e.toString()));
    }
  }

  FutureOr<void> deleteShowEvent(
      DeleteShowEvent event, Emitter<ManageMoviesState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');

      final response = await APIServices()
          .postAPIWithToken('delete-show', {"showId": event.showID}, _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Show Deleted') {
        emit(ShowDeletedState());
        add(GetAllMoviesEvent());
      } else {
        emit(ShowDeletionFailedState(error: 'Show Deletion Failed'));
        add(GetAllMoviesEvent());
      }
    } catch (e) {
      emit(ShowDeletionFailedState(error: e.toString()));
    }
  }

  FutureOr<void> getAllAvailableMovieListEvent(
      GetAllAvailableMovieListEvent event,
      Emitter<ManageMoviesState> emit) async {
    try {
      final response = await get(
          Uri.parse('https://bookmyscreen.onrender.com/admin/getMovies'),
          headers: {
            'Content-type': 'application/json;charset=utf-8',
            'Accept': 'application/json',
            'authorization': 'Bearer $adminAPI'
          });
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      List<String> allMovieNames = List<String>.from(status['data'].map((e) {
        String movieName = e['title'];
        return movieName;
      }));
      emit(AllMoviesNamesGotState(allMoviesList: allMovieNames));
    } catch (e) {
      emit(SomethinhWentWrongState(error: e.toString()));
    }
  }

  FutureOr<void> addNewMovieEvent(
      AddNewMovieEvent event, Emitter<ManageMoviesState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _ownerID = await storage.read(key: 'userId');
      final response = await APIServices().postAPIWithToken(
          'add-show',
          {
            "owner": {"_id": _ownerID},
            "screen": event.screen,
            "time": event.time.toString(),
            "inputValue": event.movieName,
            "startDate": event.startDate.toString(),
            "endDate": event.endDate.toString(),
            "price": int.parse(event.ticketPrice)
          },
          _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Show already Exist') {
        emit(NewMovieAddFailedState(error: 'Show Already Exist!'));
      } else if (status['message'] == 'Show added successfully') {
        add(GetAllMoviesEvent());
        emit(NewMovieAddedState());
      } else {
        emit(NewMovieAddFailedState(error: 'Something went wrong'));
      }
    } catch (e) {
      emit(NewMovieAddFailedState(error: e.toString()));
    }
  }

  FutureOr<void> updateMovieEvent(
      UpdateMovieEvent event, Emitter<ManageMoviesState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _ownerID = await storage.read(key: 'userId');
      final response = await APIServices().postAPIWithToken(
          'edit-show',
          {
            "editId": event.showID,
            "owner": {"_id": _ownerID},
            "screen": event.screen,
            "showTime": event.time.toString(),
            "inputValue": event.movieName,
            "startDate": event.startDate.toString(),
            "endDate": event.endDate.toString(),
            "editprice": int.parse(event.ticketPrice)
          },
          _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      if (status['message'] == 'Show Updated') {
        emit(MovieEdittedSuccessfullState());
        add(GetAllMoviesEvent());
      } else {
        emit(MovieEditFailedState(error: 'Something went wrong'));
      }
    } catch (e) {
      emit(MovieEditFailedState(error: e.toString()));
    }
  }
}
