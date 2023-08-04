// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/manage_screens/manage_screens_bloc.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassScreenWidget extends StatelessWidget {
  final String screenID;
  final String screenNumber;
  final String columns;
  final String rows;
  final String totalSeats;

  const CinePassScreenWidget(
      {super.key,
      required this.screenID,
      required this.screenNumber,
      required this.columns,
      required this.rows,
      required this.totalSeats});

  @override
  Widget build(BuildContext context) {
    final screenNumberController = TextEditingController(text: screenNumber);
    final numberOfColumnsController = TextEditingController(text: columns);
    final numberOfRowsController = TextEditingController(text: rows);
    final _key = GlobalKey<FormState>();

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Adaptive.h(1.3), horizontal: Adaptive.h(2)),
      height: Adaptive.h(15.5),
      width: Adaptive.w(100),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          SizedBox(
            height: Adaptive.h(9),
            width: Adaptive.w(18),
            child: Opacity(
                opacity: 0.75,
                child:
                    Image.asset('assets/manage_screens.png', fit: BoxFit.fill)),
          ),
          SizedBox(width: Adaptive.w(5)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Adaptive.w(35),
                child: Text('Screen : $screenNumber',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
              ),
              Text('Columns : $columns',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text('Rows : $rows',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text('Total Seats : $totalSeats',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          SizedBox(width: Adaptive.w(6)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Adaptive.w(18),
                height: Adaptive.h(3.8),
                child: ElevatedButton(
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
                              title: const Text('Update Screen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                              alignment: Alignment.center,
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
                                            .add(UpdateScreenEvent(
                                                screenID: screenID,
                                                screenNumber:
                                                    screenNumberController.text,
                                                numberOfColumns:
                                                    numberOfColumnsController
                                                        .text,
                                                numberOfRows:
                                                    numberOfRowsController
                                                        .text));
                                      }
                                    },
                                    text: 'Update Screen')
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
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              sizedBoxHeight10,
              SizedBox(
                width: Adaptive.w(18),
                height: Adaptive.h(3.8),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              'Are you sure you want to delete Screen $screenNumber?',
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
                                    BlocProvider.of<ManageScreensBloc>(context)
                                        .add(DeleteScreenEvent(
                                            screenID: screenID));
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
