// ignore_for_file: prefer_const_constructors

import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/utils/text_styles.dart';
import 'package:cinepass_owner/view_models/signin_screen_bloc/login_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_owner_dashbord.dart';
import 'package:cinepass_owner/views/screens/screen_signup.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_logo.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OwnerLoginScreen extends StatelessWidget {
  OwnerLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emialController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(7)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxHeight90,
                Align(
                    alignment: Alignment.center,
                    child: Text('Welcome Back !', style: loginPageTextStyle)),
                sizedBoxHeight70,
                const CinePassLogo(),
                sizedBoxHeight50,
                BlocListener<LoginScreenBloc, LoginScreenState>(
                  listener: (context, state) {
                    if (state is LoadingState) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const CinePassLoading();
                        },
                      );
                    } else if (state is ErrorState) {
                      Navigator.of(context).pop();
                      errorSnackBar(context, state.message);
                    } else if (state is LoginSuccessState) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => OwnerDashBordScreeen()),
                          (route) => false);
                    }
                  },
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CinePassTextFormField(
                            hint: 'Enter Email',
                            prefixIcon:
                                const Icon(Icons.mail_rounded, size: 25),
                            fieldName: 'Email',
                            controller: emialController),
                        sizedBoxHeight20,
                        CinePassPasswordTextFormField(
                            hint: 'Enter Password',
                            prefixIcon: const Icon(Icons.lock, size: 25),
                            passwordController: passwordController),
                      ],
                    ),
                  ),
                ),
                sizedBoxHeight90,
                CinePassButton(
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<LoginScreenBloc>(context).add(
                            SigninButtonClickedEvent(
                                userName: emialController.text,
                                password: passwordController.text));
                      }
                    },
                    text: 'Sign In'),
                sizedBoxHeight110,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => OwnerSignUpScreen()));
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        child: const Text('Sign Up'))
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
