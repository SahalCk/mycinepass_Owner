import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassLoading extends StatelessWidget {
  const CinePassLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Adaptive.w(65),
        height: Adaptive.h(17),
        child: Lottie.asset('animations/loading.json'),
      ),
    );
  }
}
