import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';

class TextStyles {
  AppColors appColors = AppColors();
  TextStyle darkBrownText6(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 3.6);
  }

  TextStyle darkBrownText4(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 2.7);
  }

  TextStyle darkBrownText3(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 1.9);
  }

  TextStyle blackText3(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenHeight * 1.9);
  }

  TextStyle blackText4(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenWidth * 4);
  }

  TextStyle blackText5(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenWidth * 4.8);
  }

  TextStyle whiteText5(dimensions) {
    return TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w900, color: appColors.greyBackground, fontSize: dimensions.screenWidth * 4.8);
  }

  TextStyle whiteText3(dimensions) {
    return TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w900, color: appColors.greyBackground, fontSize: dimensions.screenWidth * 3.5);
  }
}
