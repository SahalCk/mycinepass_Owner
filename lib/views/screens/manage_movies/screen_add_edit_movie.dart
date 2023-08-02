// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddEditMovieScreen extends StatelessWidget {
  final bool isEditting;
  final int? index;
  const AddEditMovieScreen({super.key, required this.isEditting, this.index});

  @override
  Widget build(BuildContext context) {
    final movieNameController = TextEditingController();
    final showTimeController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final ticketPriceController = TextEditingController();
    final screenNumberController = TextEditingController();
    final _key = GlobalKey<FormState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar: CinePassAppBar().cinePassAppBar(
                context: context,
                title: isEditting ? 'Edit Movie' : 'Add New Movie'),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(children: [
                      sizedBoxHeight30,
                      CinePassTextFormField(
                          hint: 'Enter Movie Name',
                          prefixIcon:
                              const Icon(Icons.local_movies_rounded, size: 25),
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
                              endDateController.text =
                                  selectedDate.toString().substring(0, 10);
                            }
                          },
                          controller: endDateController),
                      sizedBoxHeight20,
                      CinePassTextFormField(
                          hint: 'Enter Ticket Price',
                          prefixIcon: const Icon(Icons.currency_rupee_rounded,
                              size: 25),
                          fieldName: 'Ticket Price',
                          isDigitsOnly: true,
                          controller: ticketPriceController),
                      sizedBoxHeight20,
                      CinePassTextFormFieldWithDropDown(
                          hint: 'Select Screen',
                          prefixIcon: const Icon(
                              Icons.screenshot_monitor_rounded,
                              size: 25),
                          fieldName: 'Screen',
                          function: () {},
                          isLast: true,
                          controller: screenNumberController),
                      sizedBoxHeight140,
                      sizedBoxHeight130,
                      CinePassButton(
                          function: () {},
                          text: isEditting ? 'Update Screen' : 'Add Screen')
                    ]),
                  ),
                ))));
  }
}
