import 'package:flutter/material.dart';

class ScreenDimensions {
  final double screenWidth;
  final double screenHeight;

  ScreenDimensions(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width / 100,
        screenHeight = MediaQuery.of(context).size.height / 100;
}
