// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/models/transaction_model.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

part 'view_bookings_event.dart';
part 'view_bookings_state.dart';

class ViewBookingsBloc extends Bloc<ViewBookingsEvent, ViewBookingsState> {
  ViewBookingsBloc() : super(ViewBookingsInitial()) {
    on<GetAllTransactionsEvent>(getAllTransactionsEvent);
    on<GetFilteredTransactions>(getFilteredTransactions);
    on<DownloadExcelEvent>(downloadExcelEvent);
  }

  FutureOr<void> getAllTransactionsEvent(
      GetAllTransactionsEvent event, Emitter<ViewBookingsState> emit) async {
    emit(LoadingState());
    try {
      List<MovieBookingModel> allTransactions;
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _userID = await storage.read(key: 'userId');
      final response =
          await APIServices().getAPIWithToken('get-bookings/$_userID', _token!);
      final status = jsonDecode(response.body) as Map<String, dynamic>;
      allTransactions = List<MovieBookingModel>.from(status['data'].map((e) {
        MovieBookingModel bookingModel = MovieBookingModel.fromJson(e);
        return bookingModel;
      }));
      emit(AllTransactionsGotState(allTransactions: allTransactions));
    } catch (e) {
      emit(SomethinhWentWrongState(error: e.toString()));
    }
  }

  FutureOr<void> getFilteredTransactions(
      GetFilteredTransactions event, Emitter<ViewBookingsState> emit) {
    List<MovieBookingModel> filteredList = [];
    filteredList.clear();
    for (MovieBookingModel model in event.allTransactions) {
      if (model.date.isAfter(event.startDate) &&
          model.date.isBefore(event.endDate)) {
        filteredList.add(model);
      }
    }
    emit(FilteredTransactionsGotState(filteredList: filteredList));
  }

  FutureOr<void> downloadExcelEvent(
      DownloadExcelEvent event, Emitter<ViewBookingsState> emit) async {
    log(event.allTransactions.length.toString());
    log(event.startDate.toString());
    log(event.endDate.toString());
    try {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Id');
      sheet.getRangeByName('A1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('B1').setText('User Name');
      sheet.getRangeByName('B1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('C1').setText('Movie Name');
      sheet.getRangeByName('C1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('D1').setText('Theater Name');
      sheet.getRangeByName('D1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('E1').setText('Location');
      sheet.getRangeByName('E1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('F1').setText('Show time');
      sheet.getRangeByName('F1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('G1').setText('Date and Time');
      sheet.getRangeByName('G1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('H1').setText('Seats');
      sheet.getRangeByName('H1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('I1').setText('Booking ID');
      sheet.getRangeByName('I1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('J1').setText('Sub Total');
      sheet.getRangeByName('J1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('K1').setText('Fee');
      sheet.getRangeByName('K1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('L1').setText('Total');
      sheet.getRangeByName('L1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('M1').setText('Screen');
      sheet.getRangeByName('M1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('N1').setText('Status');
      sheet.getRangeByName('N1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('O1').setText('Language');
      sheet.getRangeByName('O1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('P1').setText('Image Url');
      sheet.getRangeByName('P1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('Q1').setText('Payment Status');
      sheet.getRangeByName('Q1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('R1').setText('Created At');
      sheet.getRangeByName('R1').builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('S1').setText('Updated At');
      sheet.getRangeByName('S1').builtInStyle = BuiltInStyles.heading1;

      if (event.startDate == null || event.endDate == null) {
        for (int i = 0; i < event.allTransactions.length; i++) {
          sheet
              .getRangeByName('A${(i + 2).toString()}')
              .setText(event.allTransactions[i].id);
          sheet
              .getRangeByName('B${(i + 2).toString()}')
              .setText(event.allTransactions[i].userName);
          sheet
              .getRangeByName('C${(i + 2).toString()}')
              .setText(event.allTransactions[i].movieName);
          sheet
              .getRangeByName('D${(i + 2).toString()}')
              .setText(event.allTransactions[i].ownerName);
          sheet
              .getRangeByName('E${(i + 2).toString()}')
              .setText(event.allTransactions[i].location);
          sheet
              .getRangeByName('F${(i + 2).toString()}')
              .setText(event.allTransactions[i].showTime);
          sheet
              .getRangeByName('G${(i + 2).toString()}')
              .setDateTime(event.allTransactions[i].date);
          sheet
              .getRangeByName('H${(i + 2).toString()}')
              .setText(getSeatNumbers(event.allTransactions[i].selectedSeats));
          sheet
              .getRangeByName('I${(i + 2).toString()}')
              .setText(event.allTransactions[i].bookingId);
          sheet
              .getRangeByName('J${(i + 2).toString()}')
              .setValue(event.allTransactions[i].subtotal);
          sheet
              .getRangeByName('K${(i + 2).toString()}')
              .setValue(event.allTransactions[i].fee);
          sheet
              .getRangeByName('L${(i + 2).toString()}')
              .setValue(event.allTransactions[i].total);
          sheet
              .getRangeByName('M${(i + 2).toString()}')
              .setValue(event.allTransactions[i].screen);
          sheet
              .getRangeByName('N${(i + 2).toString()}')
              .setText(event.allTransactions[i].status);
          sheet
              .getRangeByName('O${(i + 2).toString()}')
              .setText(event.allTransactions[i].language);
          sheet
              .getRangeByName('P${(i + 2).toString()}')
              .setText(event.allTransactions[i].image);
          sheet
              .getRangeByName('Q${(i + 2).toString()}')
              .setText(event.allTransactions[i].paymentStatus);
          sheet
              .getRangeByName('R${(i + 2).toString()}')
              .setDateTime(event.allTransactions[i].createdAt);
          sheet
              .getRangeByName('S${(i + 2).toString()}')
              .setDateTime(event.allTransactions[i].updatedAt);
        }
      } else {
        List<MovieBookingModel> filteredList = [];
        filteredList.clear();
        for (MovieBookingModel model in event.allTransactions) {
          if (model.date.isAfter(event.startDate!) &&
              model.date.isBefore(event.endDate!)) {
            filteredList.add(model);
          }
        }
        for (int i = 0; i < filteredList.length; i++) {
          sheet
              .getRangeByName('A${(i + 2).toString()}')
              .setText(filteredList[i].id);
          sheet
              .getRangeByName('B${(i + 2).toString()}')
              .setText(filteredList[i].userName);
          sheet
              .getRangeByName('C${(i + 2).toString()}')
              .setText(filteredList[i].movieName);
          sheet
              .getRangeByName('D${(i + 2).toString()}')
              .setText(filteredList[i].ownerName);
          sheet
              .getRangeByName('E${(i + 2).toString()}')
              .setText(filteredList[i].location);
          sheet
              .getRangeByName('F${(i + 2).toString()}')
              .setText(filteredList[i].showTime);
          sheet
              .getRangeByName('G${(i + 2).toString()}')
              .setDateTime(filteredList[i].date);
          sheet
              .getRangeByName('H${(i + 2).toString()}')
              .setText(getSeatNumbers(filteredList[i].selectedSeats));
          sheet
              .getRangeByName('I${(i + 2).toString()}')
              .setText(filteredList[i].bookingId);
          sheet
              .getRangeByName('J${(i + 2).toString()}')
              .setValue(filteredList[i].subtotal);
          sheet
              .getRangeByName('K${(i + 2).toString()}')
              .setValue(filteredList[i].fee);
          sheet
              .getRangeByName('L${(i + 2).toString()}')
              .setValue(filteredList[i].total);
          sheet
              .getRangeByName('M${(i + 2).toString()}')
              .setValue(filteredList[i].screen);
          sheet
              .getRangeByName('N${(i + 2).toString()}')
              .setText(filteredList[i].status);
          sheet
              .getRangeByName('O${(i + 2).toString()}')
              .setText(filteredList[i].language);
          sheet
              .getRangeByName('P${(i + 2).toString()}')
              .setText(filteredList[i].image);
          sheet
              .getRangeByName('Q${(i + 2).toString()}')
              .setText(filteredList[i].paymentStatus);
          sheet
              .getRangeByName('R${(i + 2).toString()}')
              .setDateTime(filteredList[i].createdAt);
          sheet
              .getRangeByName('S${(i + 2).toString()}')
              .setDateTime(filteredList[i].updatedAt);
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = '$path/mycinepassreport.xlsx';

      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    } catch (e) {
      emit(SomethinhWentWrongState(error: e.toString()));
    }
  }

  String getSeatNumbers(List<Seat> seatsList) {
    String seats = '';
    for (Seat seat in seatsList) {
      seats = '$seats,${seat.id}';
    }
    return seats.substring(1);
  }
}
