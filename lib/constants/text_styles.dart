import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';

class TextStyles {
  AppColors appColors = AppColors();
  TextStyle darkBrownTextLarge(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 3.6);
  }

  TextStyle darkBrownTextMedium(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 2.7);
  }

  TextStyle darkBrownTextSmall(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText, fontSize: dimensions.screenHeight * 1.9);
  }

  TextStyle blackTextLarge(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenHeight * 2.7);
  }

  TextStyle blackTextMedium(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenHeight * 2.2);
  }

  TextStyle blackTextSmall(dimensions) {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText, fontSize: dimensions.screenHeight * 1.9);
  }

  TextStyle whiteTextLarge(dimensions) {
    return TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w900, color: appColors.greyBackground, fontSize: dimensions.screenHeight * 2.5);
  }

  TextStyle whiteTextMedium(dimensions) {
    return TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.w900, color: appColors.greyBackground, fontSize: dimensions.screenHeight * 2);
  }
}
