import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class Button extends StatelessWidget {
  final String buttonTitle;
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  final VoidCallback onPressedFunction;

  const Button(
      {Key? key, required this.buttonTitle, required this.onPressedFunction, required this.dimensions, required this.appColors, required this.textStyles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimensions.screenWidth * 10,
      width: dimensions.screenWidth * 38,
      child: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(appColors.greyBackground), // Text color
            backgroundColor: MaterialStateProperty.all<Color>(appColors.darkGreenButton), // Fill color
            side: MaterialStateProperty.all<BorderSide>(BorderSide(color: appColors.greyBackground)), // Border color
          ),
          onPressed: () {
            onPressedFunction();
          },
          child: Text(buttonTitle, style: textStyles.whiteTextLarge(dimensions))),
    );
  }
}
