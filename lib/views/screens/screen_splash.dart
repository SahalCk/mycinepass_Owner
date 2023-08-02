// ignore_for_file: prefer_const_constructors

import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/splash_screen_bloc/splash_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_owner_dashbord.dart';
import 'package:cinepass_owner/views/screens/screen_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashScreenBloc>(context).add(SetUpOneSignal());
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is OneSignalSetupCompleatedState) {
          BlocProvider.of<SplashScreenBloc>(context).add(NavigateToEvenet());
        }
        if (state is NavigateToHomeScreen) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OwnerDashBordScreeen()));
        } else if (state is NavigateToLoginScreen) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OwnerLoginScreen()));
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
          body: Container(
            width: Adaptive.w(100),
            height: Adaptive.h(100),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  backgroundColor,
                  backgroundColor,
                  const Color.fromARGB(255, 29, 35, 46)
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                GifView.asset(
                  'animations/splash_screen_animation.gif',
                  loop: false,
                  height: Adaptive.h(25),
                  width: Adaptive.w(65),
                ),
                Column(
                  children: [
                    Text('Theater Owner App',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    sizedBoxHeight10
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
