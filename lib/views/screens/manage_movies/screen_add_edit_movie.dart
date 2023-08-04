// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cinepass_owner/models/movie_model.dart';
import 'package:cinepass_owner/models/screen_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/manage_movies_bloc/manage_movies_bloc.dart';
import 'package:cinepass_owner/view_models/manage_screens/manage_screens_bloc.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddEditMovieScreen extends StatelessWidget {
  final bool isEditting;
  final String? screenID;
  final int? index;
  final String? showID;
  final List<MovieModel>? allShowsList;
  const AddEditMovieScreen(
      {super.key,
      required this.isEditting,
      this.screenID,
      this.index,
      this.showID,
      this.allShowsList});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ManageMoviesBloc>(context)
        .add(GetAllAvailableMovieListEvent());
    BlocProvider.of<ManageScreensBloc>(context).add(GetAllScreensEvenet());

    List<String> allMoviesNamesList = [];
    List<ScreenModel> allScreens = [];
    TimeOfDay? showTime;
    DateTime? startDate = isEditting ? allShowsList![index!].startDate : null;
    DateTime? endDate = isEditting ? allShowsList![index!].endDate : null;

    final movieNameController = TextEditingController(
        text: isEditting ? allShowsList![index!].movieName : '');
    final showTimeController = TextEditingController(
        text: isEditting ? allShowsList![index!].showTime.toUpperCase() : '');
    final startDateController = TextEditingController(
        text: isEditting
            ? allShowsList![index!].startDate.toString().substring(0, 10)
            : '');
    final endDateController = TextEditingController(
        text: isEditting
            ? allShowsList![index!].endDate.toString().substring(0, 10)
            : '');
    final ticketPriceController = TextEditingController(
        text: isEditting ? allShowsList![index!].price.toString() : '');
    final screenNumberController = TextEditingController(
        text: isEditting ? allShowsList![index!].screen.toString() : '');

    final _key = GlobalKey<FormState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar: CinePassAppBar().cinePassAppBar(
                context: context,
                title: isEditting ? 'Edit Show' : 'Add New Show'),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(children: [
                      sizedBoxHeight30,
                      CinePassAutoFillTextFormField(
                          hint: 'Enter Movie Name',
                          prefixIcon:
                              const Icon(Icons.local_movies_rounded, size: 25),
                          allItemsList: allMoviesNamesList,
                          fieldName: 'Movie Name',
                          controller: movieNameController),
                      sizedBoxHeight20,
                      CinePassTextFormField(
                          hint: 'Select Show Time',
                          prefixIcon: const Icon(Icons.timer_rounded, size: 25),
                          fieldName: 'Show Time',
                          function: () async {
                            TimeOfDay? tempTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (tempTime != null) {
                              showTime = tempTime;
                              String? selectedTime = tempTime.format(context);
                              showTimeController.text = selectedTime;
                            }
                          },
                          controller: showTimeController),
                      sizedBoxHeight20,
                      CinePassTextFormField(
                          hint: 'Select Start Date',
                          prefixIcon: const Icon(Icons.calendar_month_rounded,
                              size: 25),
                          fieldName: 'Start Date',
                          function: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)));
                            if (selectedDate != null) {
                              startDate = selectedDate;
                              startDateController.text =
                                  selectedDate.toString().substring(0, 10);
                            }
                          },
                          controller: startDateController),
                      sizedBoxHeight20,
                      CinePassTextFormField(
                          hint: 'Select End Date',
                          prefixIcon: const Icon(Icons.calendar_month_rounded,
                              size: 25),
                          fieldName: 'End Date',
                          function: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)));

                            if (selectedDate != null) {
                              endDate = selectedDate;
                              endDateController.text =
                                  selectedDate.toString().substring(0, 10);
                            }
                          },
                          controller: endDateController),
                      sizedBoxHeight20,
                      BlocListener<ManageMoviesBloc, ManageMoviesState>(
                        listenWhen: (previous, current) =>
                            current is ManageMoviesActionState,
                        listener: (context, state) {
                          if (state is NewMovieAddedState) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            successSnackBar(
                                context, 'New Show has Added Successfully');
                          } else if (state is NewMovieAddFailedState) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            errorSnackBar(context, 'state');
                          } else if (state is MovieEdittedSuccessfullState) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            successSnackBar(
                                context, 'Show has Updated Successfully');
                          } else if (state is MovieEditFailedState) {
                            Navigator.of(context).pop();
                            successSnackBar(context, state.error);
                          }
                        },
                        child: CinePassTextFormField(
                            hint: 'Enter Ticket Price',
                            prefixIcon: const Icon(Icons.currency_rupee_rounded,
                                size: 25),
                            fieldName: 'Ticket Price',
                            isDigitsOnly: true,
                            controller: ticketPriceController),
                      ),
                      sizedBoxHeight20,
                      BlocBuilder<ManageScreensBloc, ManageScreensState>(
                        buildWhen: (previous, current) =>
                            current is! ManageScreenActionState,
                        builder: (context, state) {
                          if (state is AllScreensFetchedState) {
                            allScreens = [...state.allScreens];
                          }
                          return CinePassTextFormFieldWithDropDown(
                              hint: 'Select Screen',
                              prefixIcon: const Icon(
                                  Icons.screenshot_monitor_rounded,
                                  size: 25),
                              fieldName: 'Screen',
                              presetValue: isEditting
                                  ? allShowsList![index!].screen.toString()
                                  : null,
                              items: List<String>.generate(
                                  allScreens.length,
                                  (index) =>
                                      allScreens[index].screen.toString()),
                              function: () {},
                              isLast: true,
                              controller: screenNumberController);
                        },
                      ),
                      sizedBoxHeight140,
                      sizedBoxHeight130,
                      CinePassButton(
                          function: () {
                            if (isEditting) {
                              if (_key.currentState!.validate()) {
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return const CinePassLoading();
                                  },
                                );
                                dynamic time =
                                    showTimeController.text.replaceAll(' ', '');
                                time = time.toLowerCase();

                                BlocProvider.of<ManageMoviesBloc>(context).add(
                                    UpdateMovieEvent(
                                        showID: showID!,
                                        screen: screenNumberController.text,
                                        time: time,
                                        movieName: movieNameController.text,
                                        startDate: startDate!,
                                        endDate: endDate!,
                                        ticketPrice: ticketPriceController.text,
                                        allScreens: allScreens));
                              }
                            } else {
                              if (_key.currentState!.validate()) {
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return const CinePassLoading();
                                  },
                                );
                                BlocProvider.of<ManageMoviesBloc>(context).add(
                                    AddNewMovieEvent(
                                        screen: screenNumberController.text,
                                        time: showTime!,
                                        movieName: movieNameController.text,
                                        startDate: startDate!,
                                        endDate: endDate!,
                                        ticketPrice: ticketPriceController.text,
                                        allScreens: allScreens));
                              }
                            }
                          },
                          text: isEditting ? 'Update Show' : 'Add Show')
                    ]),
                  ),
                ))));
  }

  TimeOfDay convertToTimeOfDay(String timeString) {
    List<String> timeComponents = timeString.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1].substring(0, 2));
    String amPm = timeComponents[1].substring(2).toLowerCase();
    if (amPm == 'pm' && hour != 12) {
      hour += 12;
    } else if (amPm == 'am' && hour == 12) {
      hour = 0;
    }
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return timeOfDay;
  }
}
