import 'package:flutter/material.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class TextTitle extends StatelessWidget {
  final ScreenDimensions dimensions;
  final TextStyles textStyles;

  const TextTitle({Key? key, required this.dimensions, required this.textStyles}) : super(key: key);

  final String _commentTitle = "Add meg a megjegyzéseidet!";

  @override
  Widget build(BuildContext context) {
    return Text(
      _commentTitle,
      style: textStyles.blackText5(dimensions),
    );
  }
}
