import 'package:flutter/material.dart';

class OwnerDashBordScreeen extends StatelessWidget {
  const OwnerDashBordScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
