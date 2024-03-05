import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class TimeOutScreen extends StatelessWidget {
  final ScreenDimensions dimensions;
  final TextStyles textStyles;
  final AppColors appColors;
  const TimeOutScreen({
    super.key,
    required this.dimensions,
    required this.textStyles,
    required this.appColors,
  });

  final String title = "Sajnáljuk, valami hiba történt!\nKérjük próbáld meg újra később!";
  final String subTitle = "Ha a hiba továbbra is fennáll, kérlek jelezd a következő telefonszámon:\n+36 20 435 8697";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: appColors.greenInputBorder,
              size: dimensions.screenHeight * 20,
            ),
            Text(
              title,
              style: textStyles.darkBrownTextMedium(dimensions),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: dimensions.screenHeight * 2,
            ),
            Text(
              subTitle,
              style: textStyles.darkBrownTextSmall(dimensions),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
