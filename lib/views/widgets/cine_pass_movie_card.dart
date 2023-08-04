// ignore_for_file: prefer_const_constructors

import 'package:cinepass_owner/models/movie_model.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/manage_movies_bloc/manage_movies_bloc.dart';
import 'package:cinepass_owner/views/screens/manage_movies/screen_add_edit_movie.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassMovieCard extends StatelessWidget {
  final int index;
  final String showID;
  final String screenID;
  final String screenNumber;
  final String movieName;
  final String showTime;
  final String startDate;
  final String endDate;

  final String ticketPrice;
  const CinePassMovieCard(
      {super.key,
      required this.showID,
      required this.index,
      required this.screenID,
      required this.movieName,
      required this.screenNumber,
      required this.showTime,
      required this.startDate,
      required this.endDate,
      required this.ticketPrice});

  @override
  Widget build(BuildContext context) {
    List<String> backGroundImages = [
      'assets/card_background/bg1.jpg',
      'assets/card_background/bg2.jpg',
      'assets/card_background/bg3.jpg',
      'assets/card_background/bg4.jpg'
    ];
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Adaptive.h(1.3), horizontal: Adaptive.w(3)),
      width: Adaptive.w(100),
      height: Adaptive.h(26),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              fit: BoxFit.fill,
              opacity: 0.08,
              image: AssetImage(
                  backGroundImages[index % backGroundImages.length.round()]))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen Number : $screenNumber',
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: Adaptive.w(95),
            child: Text('Movie Name : $movieName',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Text('Show Time : $showTime',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('Start Date : $startDate',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('End Date : $endDate',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('Ticket Price : ₹$ticketPrice',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          sizedBoxHeight15,
          Row(
            children: [
              BlocBuilder<ManageMoviesBloc, ManageMoviesState>(
                buildWhen: (previous, current) =>
                    current is! ManageMoviesActionState,
                builder: (context, state) {
                  List<MovieModel> movieList = [];
                  if (state is AllMoviesGotState) {
                    movieList = [...state.movieModelList];
                  }
                  return SizedBox(
                    width: Adaptive.w(18),
                    height: Adaptive.h(3.5),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddEditMovieScreen(
                                  isEditting: true,
                                  screenID: screenID,
                                  allShowsList: movieList,
                                  showID: showID,
                                  index: index)));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7))),
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        )),
                  );
                },
              ),
              SizedBox(
                width: Adaptive.w(2.5),
              ),
              SizedBox(
                width: Adaptive.w(18),
                height: Adaptive.h(3.5),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              'Are you sure you want to delete $movieName from $screenNumber?',
                              style: const TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return const CinePassLoading();
                                      },
                                    );
                                    BlocProvider.of<ManageMoviesBloc>(context)
                                        .add(DeleteShowEvent(showID: showID));
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'))
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
