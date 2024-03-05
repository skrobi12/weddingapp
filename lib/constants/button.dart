import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class Button extends StatelessWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  final String buttonTitle;
  final VoidCallback onPressedFunction;
  final int width;
  final bool isPrimary;

  const Button(
      {Key? key,
      required this.buttonTitle,
      required this.isPrimary,
      required this.width,
      required this.onPressedFunction,
      required this.dimensions,
      required this.appColors,
      required this.textStyles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimensions.screenHeight * 5,
      width: dimensions.screenWidth * width,
      child: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(isPrimary ? appColors.greyBackground : appColors.darkGreenButton), // Text color
            backgroundColor: MaterialStateProperty.all<Color>(isPrimary ? appColors.darkGreenButton : appColors.greyBackground), // Fill color
            side: MaterialStateProperty.all<BorderSide>(BorderSide(color: isPrimary ? appColors.greyBackground : appColors.darkGreenButton)), // Border color
          ),
          onPressed: () {
            onPressedFunction();
          },
          child: Text(buttonTitle, style: isPrimary ? textStyles.whiteTextLarge(dimensions) : textStyles.greenTextLarge(dimensions))),
    );
  }
}
