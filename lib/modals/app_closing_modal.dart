import 'package:flutter/material.dart';
import 'package:wedding/constants/button.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ClosingModal {
  final String _title = "Köszönjük, hogy kitöltötted!";
  final String _subTitle = "Az esküvőn találkozunk! 🤟🥂";
  final String _infoText = "Ha bármi kérdésed lenne, hívj bátran:";
  final String _mobileNumber1 = "Blanka: +36 30 258 4048";
  final String _mobileNumber2 = "Petya: +36 30 011 8743";

  void showClosingModal(BuildContext context, ScreenDimensions dimensions, AppColors appColors, TextStyles textStyles) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: appColors.greyBackground, borderRadius: BorderRadius.circular(20)),
              width: dimensions.screenWidth * 75,
              //padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(dimensions.screenWidth * 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _title,
                      style: textStyles.blackTextLarge(dimensions).copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight * 2),
                    Text(
                      _subTitle,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight),
                    Text(
                      _infoText,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight),
                    Text(
                      _mobileNumber1,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _mobileNumber2,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight * 2),
                    Padding(
                      padding: EdgeInsets.only(left: dimensions.screenWidth * 15, right: dimensions.screenWidth * 15),
                      child: Button(
                          isPrimary: true,
                          width: 38,
                          buttonTitle: "Bezár",
                          onPressedFunction: () {
                            Navigator.pop(context);
                            html.window.location.reload();
                          },
                          dimensions: dimensions,
                          appColors: appColors,
                          textStyles: textStyles),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
