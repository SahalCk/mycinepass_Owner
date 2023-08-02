// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/movie_model.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'manage_movies_event.dart';
part 'manage_movies_state.dart';

class ManageMoviesBloc extends Bloc<ManageMoviesEvent, ManageMoviesState> {
  ManageMoviesBloc() : super(ManageMoviesInitial()) {
    on<GetAllMoviesEvent>(getAllMoviesEvent);
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
}
