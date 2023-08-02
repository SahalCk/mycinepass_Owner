import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/view_models/dashboard_screen_bloc/dashboard_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/home/screen_home.dart';
import 'package:cinepass_owner/views/screens/manage_movies/screen_manage_movies.dart';
import 'package:cinepass_owner/views/screens/manage_screens/screen_manage_screens.dart';
import 'package:cinepass_owner/views/screens/view_bookings/screen_view_bookings.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_bottom_navigation_bar_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OwnerDashBordScreeen extends StatelessWidget {
  const OwnerDashBordScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const ManageScreensScreen(),
      const ManageMoviesScreen(),
      const ViewBookingsScreen()
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: BlocConsumer<DashboardScreenBloc, DashboardScreenState>(
          listenWhen: (previous, current) =>
              current is DashboardScreenActionState,
          buildWhen: (previous, current) =>
              current is! DashboardScreenActionState,
          listener: (context, state) {},
          builder: (context, state) {
            int? selectedIndex;
            if (state is BottomNavigationItemSelectedState) {
              selectedIndex = state.index;
            }
            return Scaffold(
                body: screens[selectedIndex ?? 0],
                floatingActionButton: GlassmorphicContainer(
                  width: Adaptive.w(92),
                  height: Adaptive.h(9),
                  borderRadius: 30,
                  blur: 10,
                  alignment: Alignment.bottomCenter,
                  border: 0,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardColor.withOpacity(0.1),
                      cardColor.withOpacity(0.05),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.5),
                      const Color((0xFFFFFFFF)).withOpacity(0.5),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        CinePassBottomNavigationBarItem(
                            selectedIndex: selectedIndex ?? 0, itemIndex: 0),
                        CinePassBottomNavigationBarItem(
                            selectedIndex: selectedIndex ?? 0, itemIndex: 1),
                        CinePassBottomNavigationBarItem(
                            selectedIndex: selectedIndex ?? 0, itemIndex: 2),
                        CinePassBottomNavigationBarItem(
                            selectedIndex: selectedIndex ?? 0, itemIndex: 3),
                        const SizedBox()
                      ],
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat);
          },
        ));
  }
}
