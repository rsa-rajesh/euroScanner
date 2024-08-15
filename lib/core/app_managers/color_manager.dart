import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex('#BC1313');
  static Color primaryLight = HexColor.fromHex('#F8E7E7');
  static Color white = Colors.white;
  static Color errorOpacity50 = Colors.red.withOpacity(0.5);

  //text

  static Color black = Colors.black;
  static Color gold = HexColor.fromHex('#DBA51D');
  static Color bodyB1 = HexColor.fromHex('#7A8699');
  static Color textDark = HexColor.fromHex('#212121');
  static Color stepTextColor = HexColor.fromHex('#9E9E9E');
  static Color notValidateTextColor = HexColor.fromHex('#A6AEBB');
  static Color profileDetailTitleColor = HexColor.fromHex('#091E42');
  static Color profileDetailColor = HexColor.fromHex('#505F79');
  static Color noItemTitleColor = HexColor.fromHex('#42526D');
  static Color noItemDescColor = HexColor.fromHex('#4A4A4A');
  static Color settingItemText = HexColor.fromHex('#6B788E');

  //form
  static Color hintColor = HexColor.fromHex('#999999');
  static Color inputBgColor = HexColor.fromHex('#FAFAFA');

  //button
  static Color buttonGrey = HexColor.fromHex('#DFE2E6');
  static Color buttonLightGrey = HexColor.fromHex('#F5F6F7');
  static Color facebookBlue = HexColor.fromHex('#3B5998');
  static Color lightBlue = HexColor.fromHex('#42A5F5');
  static Color activeGreen = HexColor.fromHex('#1B8500');

  //bottom navigation bar
  static Color navigationBarGreyIcon = HexColor.fromHex('#98A1B0');

  static MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
