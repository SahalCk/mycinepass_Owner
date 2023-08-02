import 'package:cinepass_owner/models/bottom_navigation_bar_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/view_models/dashboard_screen_bloc/dashboard_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassBottomNavigationBarItem extends StatelessWidget {
  final int selectedIndex;
  final int itemIndex;
  CinePassBottomNavigationBarItem(
      {super.key, required this.selectedIndex, required this.itemIndex});

  final List<BottomNavigationBarItemModel> items = [
    BottomNavigationBarItemModel(
        title: 'Home',
        selectedImage: 'assets/bottom_navigation_bar/home_selected.png',
        unSelectedImage: 'assets/bottom_navigation_bar/home.png'),
    BottomNavigationBarItemModel(
        title: 'Screens',
        selectedImage:
            'assets/bottom_navigation_bar/manage_screen_selected.png',
        unSelectedImage: 'assets/bottom_navigation_bar/manage_screen.png'),
    BottomNavigationBarItemModel(
        title: 'Movies',
        selectedImage:
            'assets/bottom_navigation_bar/manage_movies_selected.png',
        unSelectedImage: 'assets/bottom_navigation_bar/manage_movies.png'),
    BottomNavigationBarItemModel(
        title: 'Bookings',
        selectedImage:
            'assets/bottom_navigation_bar/view_bookings_selected.png',
        unSelectedImage: 'assets/bottom_navigation_bar/view_bookings.png')
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: backgroundColor,
      onTap: () {
        BlocProvider.of<DashboardScreenBloc>(context)
            .add(BottomNavigationBarOptionSelectedEvenet(index: itemIndex));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: selectedIndex == itemIndex,
            child: Container(
                width: Adaptive.w(9),
                height: Adaptive.h(0.6),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(40))),
          ),
          Column(
            children: [
              Image.asset(
                selectedIndex == itemIndex
                    ? items[itemIndex].selectedImage
                    : items[itemIndex].unSelectedImage,
                height: Adaptive.h(5),
                width: Adaptive.w(8.5),
              ),
              selectedIndex == itemIndex
                  ? Text(items[itemIndex].title,
                      style: const TextStyle(color: Colors.white, fontSize: 11))
                  : const SizedBox()
            ],
          ),
          const SizedBox()
        ],
      ),
    );
  }
}
