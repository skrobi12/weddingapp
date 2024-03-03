import 'package:flutter/material.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class TextTitle extends StatelessWidget {
  final ScreenDimensions dimensions;
  final TextStyles textStyles;
  final String title;

  const TextTitle({Key? key, required this.dimensions, required this.title, required this.textStyles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyles.blackTextLarge(dimensions),
      textAlign: TextAlign.center,
    );
  }
}
