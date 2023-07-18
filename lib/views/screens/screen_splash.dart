import 'package:cinepass_owner/view_models/splash_screen_bloc/splash_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_owner_dashbord.dart';
import 'package:cinepass_owner/views/screens/screen_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashScreenBloc>(context).add(NavigateToEvenet());
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is NavigateToHomeScreen) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const OwnerDashBordScreeen()));
        } else if (state is NavigateToLoginScreen) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OwnerLoginScreen()));
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GifView.asset(
                'animations/splash_screen_animation.gif',
                loop: false,
                height: Adaptive.h(25),
                width: Adaptive.w(65),
              ),
            )
          ],
        ),
      ),
    );
  }
}
