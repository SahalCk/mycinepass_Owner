// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cinepass_owner/services/api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<GetAllValuesEvent>(getAllValuesEvent);
    on<PiChartIndexTouchedEvent>(piChartIndexTouchedEvent);
  }

  FutureOr<void> getAllValuesEvent(
      GetAllValuesEvent event, Emitter<HomeScreenState> emit) async {
    emit(LoadingState());
    try {
      const storage = FlutterSecureStorage();
      final _token = await storage.read(key: 'token');
      final _userID = await storage.read(key: 'userId');
      final _userName = await storage.read(key: 'theaterName');
      final int currentMonth = DateTime.now().month;

      final bookingResponse = await APIServices()
          .postAPIWithToken('get-status', {"_id": _userID}, _token!);
      final bookingStatus =
          jsonDecode(bookingResponse.body) as Map<String, dynamic>;

      final monthlyResponse = await APIServices()
          .postAPIWithToken('get-monthySails', {"_id": _userID}, _token);
      final monthlyStatus =
          jsonDecode(monthlyResponse.body) as Map<String, dynamic>;
      final dailyResponse = await APIServices()
          .postAPIWithToken('get-dailySails', {"_id": _userID}, _token);
      final dailyStatus =
          jsonDecode(dailyResponse.body) as Map<String, dynamic>;
      final bookedPercentage = (bookingStatus['data'][0] /
              (bookingStatus['data'][0] + bookingStatus['data'][1])) *
          100;

      final canceleldPercentage = (bookingStatus['data'][1] /
              (bookingStatus['data'][0] + bookingStatus['data'][1])) *
          100;
      emit(AllValuesFetchedState(
          userName: _userName!,
          dailySale: dailyStatus['data']['total'].toInt().toString(),
          monthlySale: monthlyStatus['data']['userCount'][currentMonth - 1]
              .toInt()
              .toString(),
          listOfMonths: monthlyStatus['data']['userCount'],
          yearlySale: monthlyStatus['data']['years'].toInt().toString(),
          booked: bookingStatus['data'][0].toString(),
          cancelled: bookingStatus['data'][1].toString(),
          totalRevenue: monthlyStatus['data']['years'].toInt().toString(),
          totalBookings: dailyStatus['data']['orderCount'].toString(),
          activeBookings: dailyStatus['data']['activeCount'].toString(),
          expiredBookings: dailyStatus['data']['expiredCount'].toString(),
          bookedPercentage: bookedPercentage,
          cancelledPercentage: canceleldPercentage));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  FutureOr<void> piChartIndexTouchedEvent(
      PiChartIndexTouchedEvent event, Emitter<HomeScreenState> emit) {
    emit(PiChartIndexIsTouched(index: event.index));
  }
}
