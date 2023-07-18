import 'package:flutter/material.dart';

void errorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
      content: Text(message)));
}

void snackBarResendOTP(BuildContext context, String mail) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
      content: Text('New OTP has sent to $mail')));
}
