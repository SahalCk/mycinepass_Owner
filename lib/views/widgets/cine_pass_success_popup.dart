import 'package:cinepass_owner/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountCreatedSuccessPopUp extends StatelessWidget {
  const AccountCreatedSuccessPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(Adaptive.w(5)),
        width: Adaptive.w(72),
        height: Adaptive.h(42),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Lottie.asset('animations/successfully_created.json', repeat: false),
            const Text(
              'Account has Created Successfull!\nPlease Login',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
