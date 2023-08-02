part of 'manage_movies_bloc.dart';

@immutable
abstract class ManageMoviesState {}

class ManageMoviesInitial extends ManageMoviesState {}

abstract class ManageMoviesActionState extends ManageMoviesState {}

class LoadingState extends ManageMoviesState {}

class AllMoviesGotState extends ManageMoviesState {
  final List<MovieModel> movieModelList;
  AllMoviesGotState({required this.movieModelList});
}

class SomethinhWentWrongState extends ManageMoviesActionState {
  final String error;
  SomethinhWentWrongState({required this.error});
}
