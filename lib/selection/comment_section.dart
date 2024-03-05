import 'package:flutter/material.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class CommentSection extends StatelessWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  final Family selectedFamily;

  const CommentSection({Key? key, required this.dimensions, required this.appColors, required this.textStyles, required this.selectedFamily}) : super(key: key);

  final String _hintText = 'pl.: laktózérzékeny vagyok, stb...';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appColors.greyBackground, borderRadius: BorderRadius.circular(20), border: Border.all(color: appColors.greenInputBorder, width: 2)),
      height: dimensions.screenHeight * 25,
      width: dimensions.screenWidth * 80,
      child: Padding(
        padding: EdgeInsets.only(left: dimensions.screenWidth * 4, right: dimensions.screenWidth * 4),
        child: TextField(
          style: textStyles.blackTextSmall(dimensions),
          onTap: () {
            // Add a delay before scrolling
            // scrollToBottom();
          },
          onChanged: (value) {
            selectedFamily.comment = value;
          },
          //controller: _familyCommentsController,
          decoration: InputDecoration(border: InputBorder.none, hintText: _hintText, hintMaxLines: 3, hintStyle: textStyles.blackTextSmall(dimensions)),
        ),
      ),
    );
  }
}
