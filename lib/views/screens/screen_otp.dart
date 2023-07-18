import 'package:cinepass_owner/models/theater_owner_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/sign_up_screen_bloc/signup_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_signin.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_success_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OTPScreen extends StatelessWidget {
  final TheaterOwnerModel theaterOwnerModel;
  OTPScreen({super.key, required this.theaterOwnerModel});

  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sizedBoxHeight90,
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: Adaptive.h(40),
                    child: LottieBuilder.asset(
                        'animations/otpscreen_animation.json')),
              ),
              sizedBoxHeight80,
              const Text('Enter Your OTP',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text('OTP has sent to ${theaterOwnerModel.email}',
                  style: TextStyle(color: primaryColor)),
              sizedBoxHeight30,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: Pinput(
                  controller: pinController,
                  length: 6,
                  obscureText: true,
                  defaultPinTheme: defaultPinTheme,
                ),
              ),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<SignupScreenBloc>(context)
                        .add(ResedOtpEvenet(email: theaterOwnerModel.email));
                  },
                  child: const Text('Resend OTP')),
              sizedBoxHeight70,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: BlocListener<SignupScreenBloc, SignupScreenState>(
                  listenWhen: (previous, current) =>
                      current is SignUpActionState,
                  listener: (context, state) {
                    if (state is LoadingState) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const CinePassLoading();
                        },
                      );
                    } else if (state is OTPResentState) {
                      snackBarResendOTP(context, theaterOwnerModel.email);
                    } else if (state is IncorrectOTPState) {
                      Navigator.of(context).pop();
                      errorSnackBar(context, 'Incorrect OTP!');
                    } else if (state is SuccessPopupState) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const AccountCreatedSuccessPopUp();
                        },
                      );
                    } else if (state is AccountCreatedSuccessState) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OwnerLoginScreen()),
                          (route) => false);
                    }
                  },
                  child: CinePassButton(
                      function: () {
                        BlocProvider.of<SignupScreenBloc>(context).add(
                            OTPConfirmButtonPressedEvenet(
                                otp: pinController.text,
                                theaterOwnerModel: theaterOwnerModel));
                      },
                      text: 'Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ));
}
