import 'package:flutter/material.dart';

import '../app_managers/assets_managers.dart';

class CustomEmptyScreen extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const CustomEmptyScreen({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                AssetManager.emptyBox,
              ),
              fit: BoxFit.cover,
            ),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF42526D),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
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