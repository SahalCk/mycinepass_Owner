// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/manage_screens/manage_screens_bloc.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_screen_widget.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageScreensScreen extends StatelessWidget {
  const ManageScreensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenNumberController = TextEditingController();
    final numberOfColumnsController = TextEditingController();
    final numberOfRowsController = TextEditingController();
    final _key = GlobalKey<FormState>();

    BlocProvider.of<ManageScreensBloc>(context).add(GetAllScreensEvenet());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        appBar: CinePassAppBar().cinePassAppBarWithoutBackbutton(
            context: context, title: 'Manage Screens'),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
              child: Column(
                children: [
                  sizedBoxHeight20,
                  Expanded(
                    child: BlocConsumer<ManageScreensBloc, ManageScreensState>(
                      listener: (context, state) {
                        if (state is NewScreenAddedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          successSnackBar(
                              context, 'New Screen has Added Successfully!');
                        } else if (state is ScreenAddingFailedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          errorSnackBar(context, state.error);
                        } else if (state is SomethinhWentWrongState) {
                          errorSnackBar(context, state.error);
                        } else if (state is ScreenUpdatedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          successSnackBar(
                              context, 'Screen has Updated Successfully');
                        } else if (state is ScreenUpdationFailedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          errorSnackBar(context, state.error);
                        } else if (state is ScreenDeletedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          errorSnackBar(context, 'Screen Deleted Successfully');
                        } else if (state is DeletionFailedState) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          errorSnackBar(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        if (state is AllScreensFetchedState) {
                          return state.allScreens.isNotEmpty
                              ? ListView.separated(
                                  padding:
                                      EdgeInsets.only(bottom: Adaptive.h(10)),
                                  itemBuilder: (context, index) {
                                    return CinePassScreenWidget(
                                        screenID: state.allScreens[index].id,
                                        screenNumber: state
                                            .allScreens[index].screen
                                            .toString(),
                                        columns: state.allScreens[index].columns
                                            .toString(),
                                        rows: state.allScreens[index].rows
                                            .toString(),
                                        totalSeats: state
                                            .allScreens[index].totalSeats
                                            .toString());
                                  },
                                  separatorBuilder: (context, index) {
                                    return sizedBoxHeight10;
                                  },
                                  itemCount: state.allScreens.length)
                              : const Center(
                                  child: Text(
                                    'Screens not found!',
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
              ),
            ),
            Positioned(
              right: Adaptive.w(5),
              bottom: Adaptive.h(12),
              child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Form(
                          key: _key,
                          child: SimpleDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            contentPadding: EdgeInsets.all(Adaptive.h(2)),
                            backgroundColor: backgroundColor,
                            title: const Text('Add New Screen',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                            children: [
                              sizedBoxHeight20,
                              CinePassTextFormField(
                                  hint: 'Enter Screen Number',
                                  fieldName: 'Screen Number',
                                  prefixIcon: Icon(Icons.fit_screen_rounded,
                                      color: primaryColor),
                                  controller: screenNumberController,
                                  isDigitsOnly: true),
                              sizedBoxHeight20,
                              CinePassTextFormField(
                                  hint: 'Enter Number of Columns',
                                  fieldName: 'Number of Columns',
                                  controller: numberOfColumnsController,
                                  prefixIcon: Icon(
                                    Icons.view_column_rounded,
                                    color: primaryColor,
                                  ),
                                  isDigitsOnly: true),
                              sizedBoxHeight20,
                              CinePassTextFormField(
                                  hint: 'Enter Number of Rows',
                                  fieldName: 'Number of Rows',
                                  controller: numberOfRowsController,
                                  prefixIcon: Icon(Icons.table_rows_rounded,
                                      color: primaryColor),
                                  isDigitsOnly: true),
                              sizedBoxHeight30,
                              CinePassButton(
                                  function: () {
                                    if (_key.currentState!.validate()) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const CinePassLoading();
                                        },
                                      );
                                      BlocProvider.of<ManageScreensBloc>(
                                              context)
                                          .add(AddNewScreenEvent(
                                              screenNumber:
                                                  screenNumberController.text,
                                              numberOfColumns:
                                                  numberOfColumnsController
                                                      .text,
                                              numberOfRows:
                                                  numberOfRowsController.text));
                                    }
                                  },
                                  text: 'Add Screen')
                            ],
                          ),
                        );
                      },
                    ).then((value) {
                      screenNumberController.clear();
                      numberOfColumnsController.clear();
                      numberOfRowsController.clear();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 32)),
            ),
          ],
        ),
      ),
    );
  }
}
