import 'package:cinepass_owner/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassButton extends StatelessWidget {
  final Function() function;
  final String text;
  const CinePassButton({super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adaptive.w(100),
      height: Adaptive.h(6.7),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13))),
          onPressed: function,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          )),
    );
  }
}
