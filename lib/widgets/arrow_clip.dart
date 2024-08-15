import 'package:flutter/material.dart';

/// Clipper to Cut widget at the side

class ArrowClipReversed extends CustomClipper<Path> {

  int cutLength= 20;
  ArrowClipReversed(int i) {
    cutLength = i;
  }

  /// Play with scals to get more clear versions
  @override
  Path getClip(Size size) {
    // double xFactor = 18, yFactor = 15;
    double height = size.height;
    double width = size.width;

    // double startY = (height - height / 3) - yFactor;
    // double xVal = size.width;
    // double yVal = 0;
    final path = Path();
    // path.lineTo(width, height/2);
    // path.lineTo(0,width);

    // path.moveTo(width, 0);
    path.lineTo(width, 0);
    path.lineTo(width - cutLength, height / 2);
    path.lineTo(width, height);
    path.lineTo(0, height);
    // path.lineTo(100 / 2, 50 / 2);
    // path.lineTo(50, 100);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
