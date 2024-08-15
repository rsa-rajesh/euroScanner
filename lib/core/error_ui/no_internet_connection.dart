import 'package:flutter/material.dart';

class NoInternetConnection extends StatefulWidget {
  NoInternetConnection({super.key});

  @override
  State<NoInternetConnection> createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                "assets/images/no_internet_connection.png",
              ),
              fit: BoxFit.cover,
            ),
            Text(
              'No internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF42526D),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please check your internet connection',
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
