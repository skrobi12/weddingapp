import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';

class Loader extends StatelessWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  const Loader({
    super.key,
    required this.dimensions,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.greyBackground,
      body: Center(
        child: SizedBox(
            height: dimensions.screenHeight * 12,
            width: dimensions.screenHeight * 12,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            )),
      ),
    );
  }
}
