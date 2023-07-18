import 'dart:io';
import 'package:cinepass_owner/models/theater_owner_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/utils/text_styles.dart';
import 'package:cinepass_owner/view_models/sign_up_screen_bloc/signup_screen_bloc.dart';
import 'package:cinepass_owner/views/screens/screen_select_location.dart';
import 'package:cinepass_owner/views/screens/screen_signin.dart';
import 'package:cinepass_owner/views/screens/screen_otp.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_button.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_loading.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:cinepass_owner/views/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OwnerSignUpScreen extends StatelessWidget {
  OwnerSignUpScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final licenseController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  final adharController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? imagePath;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(7)),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxHeight60,
                Align(
                  alignment: Alignment.center,
                  child: Text('Create Your\nAccount',
                      style: loginPageTextStyle, textAlign: TextAlign.center),
                ),
                sizedBoxHeight30,
                CinePassTextFormField(
                    hint: 'Enter Theater Name',
                    prefixIcon: const Icon(Icons.home_work_rounded, size: 25),
                    fieldName: 'Theater Name',
                    controller: nameController),
                sizedBoxHeight20,
                CinePassTextFormField(
                    hint: 'Enter Email',
                    prefixIcon: const Icon(Icons.mail_rounded, size: 25),
                    fieldName: 'Email',
                    controller: emailController),
                sizedBoxHeight20,
                CinePassTextFormField(
                    hint: 'Enter License ID',
                    prefixIcon:
                        const Icon(Icons.insert_drive_file_rounded, size: 25),
                    fieldName: 'License',
                    controller: licenseController),
                sizedBoxHeight20,
                CinePassTextFormField(
                    hint: 'Enter Phone Number',
                    prefixIcon:
                        const Icon(Icons.phone_iphone_rounded, size: 25),
                    fieldName: 'Phone',
                    isDigitsOnly: true,
                    limit: 10,
                    controller: phoneController),
                sizedBoxHeight20,
                BlocBuilder<SignupScreenBloc, SignupScreenState>(
                  buildWhen: (previous, current) =>
                      current is! SignUpActionState,
                  builder: (context, state) {
                    if (state is LocationFoundState) {
                      placeController.text = state.location;
                    }
                    return CinePassTextFormField(
                        hint: 'Select Your Location',
                        prefixIcon: const Icon(Icons.place, size: 25),
                        fieldName: 'Location',
                        function: () {
                          BlocProvider.of<SignupScreenBloc>(context)
                              .add(SelectLocationFromGoogleMap());
                        },
                        controller: placeController);
                  },
                ),
                sizedBoxHeight20,
                CinePassTextFormField(
                    hint: 'Enter Adhar Number (ID Proof)',
                    prefixIcon:
                        const Icon(Icons.assignment_ind_rounded, size: 25),
                    fieldName: 'Adhar Number',
                    isDigitsOnly: true,
                    limit: 12,
                    controller: adharController),
                sizedBoxHeight20,
                InkWell(
                  onTap: () {
                    BlocProvider.of<SignupScreenBloc>(context)
                        .add(IDProofUploadEvent());
                  },
                  child: BlocConsumer<SignupScreenBloc, SignupScreenState>(
                    listenWhen: (previous, current) =>
                        current is SignUpActionState,
                    listener: (context, state) {
                      if (state is PhotoUplaodErrorState) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Something went wrong');
                      } else if (state is SelectLocationState) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SelectLocation()));
                      } else if (state is InvalidEmailState) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Invalid Email');
                      } else if (state is InvalidMobileNumberState) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Invalid Mobile Number');
                      } else if (state is InvalidAdharNumber) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Invalid Adhar Number');
                      } else if (state is AdharPhotoNotAddedState) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Adhar Photo is not Uploaded');
                      } else if (state is PasswordMismatchesState) {
                        Navigator.of(context).pop();
                        errorSnackBar(context, 'Password Mismatches!');
                      } else if (state is LoadingState) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const CinePassLoading();
                          },
                        );
                      } else if (state is OwnerAlreadyExistState) {
                        Navigator.of(context).pop();
                        errorSnackBar(
                            context, 'Account Already Exist! Please Login');
                      } else if (state is SomethingWentWrongState) {
                        Navigator.of(context).pop();
                        errorSnackBar(
                            context, state.message ?? 'Something Went Wrong');
                      } else if (state is NavigateToOtpScreen) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => OTPScreen(
                                  theaterOwnerModel: state.ownerModel,
                                )));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AdharPhotoUplaodedState,
                    builder: (context, state) {
                      if (state is AdharPhotoUplaodedState) {
                        imagePath = state.imagePath;
                      }
                      return Container(
                        height: Adaptive.h(25),
                        width: Adaptive.w(100),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color: primaryColor,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8)),
                        child: state is AdharPhotoUplaodedState
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(File(imagePath!),
                                    fit: BoxFit.fill))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: Adaptive.h(13),
                                      child: Image.asset('assets/upload.png')),
                                  const Text(
                                      "Tap to Upload Adhar's front side photo*",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                      );
                    },
                  ),
                ),
                sizedBoxHeight20,
                CinePassPasswordTextFormField(
                    hint: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock, size: 25),
                    passwordController: passwordController),
                sizedBoxHeight20,
                CinePassTextFormField(
                    hint: 'Enter Confirm Password',
                    prefixIcon: const Icon(Icons.lock, size: 25),
                    fieldName: 'Confirm Password',
                    controller: confirmController),
                sizedBoxHeight80,
                CinePassButton(
                    function: () {
                      if (_key.currentState!.validate()) {
                        final TheaterOwnerModel theaterOwnerModel =
                            TheaterOwnerModel(
                                ownerName: nameController.text,
                                email: emailController.text,
                                licenseID: licenseController.text,
                                phoneNumber: phoneController.text,
                                location: placeController.text,
                                adharNumber: adharController.text,
                                adharPhotoPath: imagePath ?? '',
                                password: passwordController.text,
                                confrimPassword: confirmController.text);

                        BlocProvider.of<SignupScreenBloc>(context).add(
                            ValidateSignUp(
                                theaterOwnerModel: theaterOwnerModel));
                      }
                    },
                    text: 'Sign Up'),
                sizedBoxHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => OwnerLoginScreen()));
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        child: const Text('Sign In'))
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
