import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/view_models/sign_up_screen_bloc/signup_screen_bloc.dart';
import 'package:cinepass_owner/view_models/signin_screen_bloc/login_screen_bloc.dart';
import 'package:cinepass_owner/view_models/splash_screen_bloc/splash_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashScreenBloc()),
        BlocProvider(create: (context) => LoginScreenBloc()),
        BlocProvider(create: (context) => SignupScreenBloc())
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'My CinePass',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: primaryColor,
                      primary: primaryColor,
                      background: backgroundColor),
                  useMaterial3: true,
                  fontFamily: 'Poppins'),
              home: const SplashScreen());
        },
      ),
    );
  }
}
