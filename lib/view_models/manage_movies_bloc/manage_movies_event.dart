part of 'manage_movies_bloc.dart';

@immutable
abstract class ManageMoviesEvent {}

class GetAllMoviesEvent extends ManageMoviesEvent {}

class DeleteShowEvent extends ManageMoviesEvent {
  final String showID;
  DeleteShowEvent({required this.showID});
}

class GetAllAvailableMovieListEvent extends ManageMoviesEvent {
  GetAllAvailableMovieListEvent();
}

class AddNewMovieEvent extends ManageMoviesEvent {
  final String screen;
  final TimeOfDay time;
  final String movieName;
  final DateTime startDate;
  final DateTime endDate;
  final String ticketPrice;
  final List<ScreenModel> allScreens;
  AddNewMovieEvent(
      {required this.screen,
      required this.time,
      required this.movieName,
      required this.startDate,
      required this.endDate,
      required this.ticketPrice,
      required this.allScreens});
}

class UpdateMovieEvent extends ManageMoviesEvent {
  final String showID;
  final String screen;
  final dynamic time;
  final String movieName;
  final DateTime startDate;
  final DateTime endDate;
  final String ticketPrice;
  final List<ScreenModel> allScreens;
  UpdateMovieEvent(
      {required this.showID,
      required this.screen,
      required this.time,
      required this.movieName,
      required this.startDate,
      required this.endDate,
      required this.ticketPrice,
      required this.allScreens});
}
