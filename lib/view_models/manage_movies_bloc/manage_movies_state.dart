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

class ShowDeletionFailedState extends ManageMoviesActionState {
  final String error;
  ShowDeletionFailedState({required this.error});
}

class ShowDeletedState extends ManageMoviesActionState {}

class AllMoviesNamesGotState extends ManageMoviesActionState {
  final List<String> allMoviesList;
  AllMoviesNamesGotState({required this.allMoviesList});
}

class NewMovieAddedState extends ManageMoviesActionState {}

class NewMovieAddFailedState extends ManageMoviesActionState {
  final String error;
  NewMovieAddFailedState({required this.error});
}

class MovieEdittedSuccessfullState extends ManageMoviesActionState {}

class MovieEditFailedState extends ManageMoviesActionState {
  final String error;
  MovieEditFailedState({required this.error});
}
