import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/manage_movies_bloc/manage_movies_bloc.dart';
import 'package:cinepass_owner/views/screens/manage_movies/screen_add_edit_movie.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_movie_card.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageMoviesScreen extends StatelessWidget {
  const ManageMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ManageMoviesBloc>(context).add(GetAllMoviesEvent());
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar: CinePassAppBar().cinePassAppBarWithoutBackbutton(
                context: context, title: 'Manage Movies'),
            body: Stack(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                  child: Column(
                    children: [
                      sizedBoxHeight20,
                      Expanded(
                        child:
                            BlocConsumer<ManageMoviesBloc, ManageMoviesState>(
                          listenWhen: (previous, current) =>
                              current is ManageMoviesActionState,
                          buildWhen: (previous, current) =>
                              current is! ManageMoviesActionState,
                          listener: (context, state) {
                            if (state is ShowDeletedState) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              errorSnackBar(
                                  context, 'Show Deleted Successfully!');
                            } else if (state is ShowDeletionFailedState) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              errorSnackBar(context, state.error);
                            }
                          },
                          builder: (context, state) {
                            if (state is AllMoviesGotState) {
                              return state.movieModelList.isNotEmpty
                                  ? ListView.separated(
                                      padding: EdgeInsets.only(
                                          bottom: Adaptive.h(10)),
                                      itemBuilder: (context, index) {
                                        return CinePassMovieCard(
                                            index: index,
                                            showID:
                                                state.movieModelList[index].id,
                                            screenID: state
                                                .movieModelList[index].screenId,
                                            movieName: state
                                                .movieModelList[index]
                                                .movieName,
                                            screenNumber: state
                                                .movieModelList[index].screen
                                                .toString(),
                                            showTime: state
                                                .movieModelList[index].showTime,
                                            startDate: state
                                                .movieModelList[index].startDate
                                                .toString()
                                                .substring(0, 10),
                                            endDate: state
                                                .movieModelList[index].endDate
                                                .toString()
                                                .substring(0, 10),
                                            ticketPrice: state
                                                .movieModelList[index].price
                                                .toString());
                                      },
                                      separatorBuilder: (context, index) {
                                        return sizedBoxHeight15;
                                      },
                                      itemCount: state.movieModelList.length)
                                  : const Center(
                                      child: Text(
                                        'Movies not found!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    );
                            } else {
                              return Center(
                                child: LottieBuilder.asset(
                                  'animations/content_loading.json',
                                  width: Adaptive.h(20),
                                  height: Adaptive.w(38),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )),
              Positioned(
                right: Adaptive.w(5),
                bottom: Adaptive.h(12),
                child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const AddEditMovieScreen(isEditting: false)));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 32)),
              ),
            ])));
  }
}
