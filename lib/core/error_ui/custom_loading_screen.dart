import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class CustomLoadingScreen extends StatelessWidget {
  final String? title;

  const CustomLoadingScreen({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitPumpingHeart(
              color: Colors.grey,
              size: 50,
            ),
            const Gap(30),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF42526D),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}