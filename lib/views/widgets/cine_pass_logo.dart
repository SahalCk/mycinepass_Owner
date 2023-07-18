import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassLogo extends StatelessWidget {
  const CinePassLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/cine_pass_logo.png',
        height: Adaptive.h(20), width: Adaptive.w(40));
  }
}
