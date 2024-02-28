import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';

class TextStyles {
  AppColors appColors = AppColors();
  TextStyle darkBrownText6(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenWidth * 6.5);
  }

  TextStyle darkBrownText4(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenWidth * 4.5);
  }

  TextStyle darkBrownText3(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenWidth * 3.5);
  }

  TextStyle blackText3(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenWidth * 3.5);
  }

  TextStyle blackText5(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenWidth * 4.8);
  }

  TextStyle whiteText5(dimensions) {
    return TextStyle(
        fontFamily: "Kalam",
        fontWeight: FontWeight.w900,
        color: appColors.greyBackground,
        fontSize: dimensions.screenWidth * 4.8);
  }
}
