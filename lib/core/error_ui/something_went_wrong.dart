import 'package:flutter/material.dart';

class SomethingWentWrong extends StatefulWidget {
  const SomethingWentWrong({super.key});

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                "assets/images/something_went_wrong.png",
              ),
              fit: BoxFit.cover,
            ),
            Text(
              'Oops!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF42526D),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Something went wrong,\nplease try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4A4A4A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
