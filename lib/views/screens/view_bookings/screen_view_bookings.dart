// ignore_for_file: use_build_context_synchronously

import 'package:cinepass_owner/models/transaction_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/view_bookings_bloc/view_bookings_bloc.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ViewBookingsBloc>(context).add(GetAllTransactionsEvent());
    final fromDateController = TextEditingController();
    final toDateController = TextEditingController();
    List<MovieBookingModel>? allTransactions;
    List<MovieBookingModel>? filteredTransaction;
    DateTime? startDate;
    DateTime? endDate;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar: CinePassAppBar().cinePassAppBarWithoutBackbutton(
              context: context,
              title: 'View Bookings',
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: Column(children: [
                  sizedBoxHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Adaptive.h(6),
                        width: Adaptive.w(38.5),
                        child: TextField(
                          showCursor: false,
                          controller: fromDateController,
                          keyboardType: TextInputType.none,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13.5),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: textFormFieldColor,
                              suffixIcon:
                                  const Icon(Icons.calendar_month_rounded),
                              suffixIconColor: primaryColor,
                              hintStyle: TextStyle(
                                  color: hintColor,
                                  fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textFormFieldColor)),
                              hintText: 'From Date'),
                          onTap: () async {
                            DateTime currentDate = DateTime.now();
                            final fromDate = await showDatePicker(
                                initialDate: DateTime.now(),
                                firstDate: currentDate
                                    .subtract(const Duration(days: 365)),
                                lastDate:
                                    currentDate.add(const Duration(days: 365)),
                                initialDatePickerMode: DatePickerMode.day,
                                context: context);

                            if (fromDate == null) {
                              return;
                            }
                            startDate = fromDate;
                            fromDateController.text =
                                fromDate.toString().substring(0, 10);
                            if (startDate != null && endDate != null) {
                              BlocProvider.of<ViewBookingsBloc>(context).add(
                                  GetFilteredTransactions(
                                      startDate: startDate!,
                                      endDate: endDate!,
                                      allTransactions: allTransactions!));
                            }
                          },
                        ),
                      ),
                      SizedBox(width: Adaptive.w(2)),
                      SizedBox(
                        height: Adaptive.h(6),
                        width: Adaptive.w(38.5),
                        child: TextField(
                          showCursor: false,
                          controller: toDateController,
                          keyboardType: TextInputType.none,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13.5),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: textFormFieldColor,
                              suffixIcon:
                                  const Icon(Icons.calendar_month_rounded),
                              suffixIconColor: primaryColor,
                              hintStyle: TextStyle(
                                  color: hintColor,
                                  fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textFormFieldColor)),
                              hintText: 'To Date'),
                          onTap: () async {
                            DateTime? currentDate = DateTime.now();
                            final toDate = await showDatePicker(
                                initialDate: DateTime.now(),
                                firstDate: currentDate
                                    .subtract(const Duration(days: 365)),
                                lastDate:
                                    currentDate.add(const Duration(days: 365)),
                                initialDatePickerMode: DatePickerMode.day,
                                context: context);

                            if (toDate == null) {
                              return;
                            }
                            endDate = toDate;
                            toDateController.text =
                                toDate.toString().substring(0, 10);
                            if (startDate != null && endDate != null) {
                              BlocProvider.of<ViewBookingsBloc>(context).add(
                                  GetFilteredTransactions(
                                      startDate: startDate!,
                                      endDate: endDate!,
                                      allTransactions: allTransactions!));
                            }
                          },
                        ),
                      ),
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            fromDateController.clear();
                            toDateController.clear();
                            startDate = null;
                            endDate = null;
                            BlocProvider.of<ViewBookingsBloc>(context)
                                .add(GetAllTransactionsEvent());
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 26,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        BlocProvider.of<ViewBookingsBloc>(context).add(
                            DownloadExcelEvent(
                                startDate: startDate,
                                endDate: endDate,
                                allTransactions: allTransactions!));
                      },
                      child: const Text('Download Report')),
                  BlocConsumer<ViewBookingsBloc, ViewBookingsState>(
                    listenWhen: (previous, current) =>
                        current is ViewBookingsActionState,
                    buildWhen: (previous, current) =>
                        current is! ViewBookingsActionState,
                    listener: (context, state) {
                      if (state is SomethinhWentWrongState) {
                        errorSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is AllTransactionsGotState) {
                        allTransactions = state.allTransactions;
                        return Expanded(
                            child: state.allTransactions.isNotEmpty
                                ? ListView.separated(
                                    padding:
                                        EdgeInsets.only(bottom: Adaptive.h(12)),
                                    itemBuilder: (context, index) {
                                      return CinePassBookingCard(
                                          movieBookingModel:
                                              allTransactions![index]);
                                    },
                                    separatorBuilder: (context, index) {
                                      return sizedBoxHeight10;
                                    },
                                    itemCount: state.allTransactions.length)
                                : const Center(
                                    child: Text(
                                      'Transactions not found!',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ));
                      } else if (state is FilteredTransactionsGotState) {
                        filteredTransaction = state.filteredList;
                        return Expanded(
                            child: state.filteredList.isNotEmpty
                                ? ListView.separated(
                                    padding:
                                        EdgeInsets.only(bottom: Adaptive.h(12)),
                                    itemBuilder: (context, index) {
                                      return CinePassBookingCard(
                                          movieBookingModel:
                                              filteredTransaction![index]);
                                    },
                                    separatorBuilder: (context, index) {
                                      return sizedBoxHeight10;
                                    },
                                    itemCount: state.filteredList.length)
                                : const Center(
                                    child: Text(
                                      'Transactions not found!',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ));
                      } else {
                        return Expanded(
                          child: Center(
                            child: LottieBuilder.asset(
                              'animations/content_loading.json',
                              width: Adaptive.h(20),
                              height: Adaptive.w(38),
                            ),
                          ),
                        );
                      }
                    },
                  )
                ]))));
  }
}
