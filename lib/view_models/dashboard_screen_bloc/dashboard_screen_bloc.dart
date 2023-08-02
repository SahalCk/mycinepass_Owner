import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_screen_event.dart';
part 'dashboard_screen_state.dart';

class DashboardScreenBloc
    extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc() : super(DashboardScreenInitial()) {
    on<BottomNavigationBarOptionSelectedEvenet>(
        bottomNavigationBarOptionSelectedEvenet);
  }

  FutureOr<void> bottomNavigationBarOptionSelectedEvenet(
      BottomNavigationBarOptionSelectedEvenet event,
      Emitter<DashboardScreenState> emit) {
    emit(BottomNavigationItemSelectedState(index: event.index));
  }
}
