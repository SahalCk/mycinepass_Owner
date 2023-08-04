import 'package:cinepass_owner/firebase_options.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/view_models/dashboard_screen_bloc/dashboard_screen_bloc.dart';
import 'package:cinepass_owner/view_models/home_screen_bloc/home_screen_bloc.dart';
import 'package:cinepass_owner/view_models/manage_movies_bloc/manage_movies_bloc.dart';
import 'package:cinepass_owner/view_models/manage_screens/manage_screens_bloc.dart';
import 'package:cinepass_owner/view_models/sign_up_screen_bloc/signup_screen_bloc.dart';
import 'package:cinepass_owner/view_models/signin_screen_bloc/login_screen_bloc.dart';
import 'package:cinepass_owner/view_models/splash_screen_bloc/splash_screen_bloc.dart';
import 'package:cinepass_owner/view_models/view_bookings_bloc/view_bookings_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashboardScreenBloc()),
        BlocProvider(create: (context) => SplashScreenBloc()),
        BlocProvider(create: (context) => LoginScreenBloc()),
        BlocProvider(create: (context) => SignupScreenBloc()),
        BlocProvider(create: (context) => HomeScreenBloc()),
        BlocProvider(create: (context) => ManageScreensBloc()),
        BlocProvider(create: (context) => ManageMoviesBloc()),
        BlocProvider(create: (context) => ViewBookingsBloc())
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
