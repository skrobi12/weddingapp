import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class TextCard extends StatelessWidget {
  final String textCardType;
  final int textCardHeight;
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;

  const TextCard(
      {Key? key, required this.textCardType, required this.textCardHeight, required this.dimensions, required this.appColors, required this.textStyles})
      : super(key: key);

  final _name1 = "Blanka";
  final _name2 = "Petya";
  final _location = "Szentpéterfa";
  final _date = "2024.07.27.";
  final _invitation =
      "Kedves Családunk, Rokonaink és Barátaink!\nÖrömmel tudatjuk, hogy nemsokára eljön a nagy nap,\nmikor mindazok előtt, akik fontosak az életünkben,\nörök hűséget fogadunk egymásnak.\n\nSzeretnénk, ha velünk együtt örülnétek és\nünnepelnétek ezen a fontos napon,\nezért szeretettel meghívunk\n2024. Július 27-én 17:00 órakor a\nszentpéterfai Szent István Király kápolnában tartandó\nesküvőnkre, az azt követő vacsorára,\nmajd a hajnalig tartó mulatságra.";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appColors.lightGreenCard, // Adjust this color as per your requirement
      ),
      height: dimensions.screenHeight * textCardHeight,
      width: dimensions.screenWidth * 85,
      child: Padding(
        padding: EdgeInsets.only(
            left: dimensions.screenWidth * 3.5, right: dimensions.screenWidth * 3.5, top: dimensions.screenHeight * 1.8, bottom: dimensions.screenHeight * 1.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (textCardType == "names")
              Column(
                children: [
                  Text(
                    _name1,
                    style: textStyles.darkBrownText6(dimensions),
                  ),
                  Text(
                    "&",
                    style: textStyles.darkBrownText4(dimensions),
                  ),
                  Text(
                    _name2,
                    style: textStyles.darkBrownText6(dimensions),
                  ),
                ],
              ),
            if (textCardType == "location")
              Column(
                children: [
                  Text(
                    _location,
                    style: textStyles.darkBrownText4(dimensions),
                  ),
                  SizedBox(height: dimensions.screenHeight * 2),
                  Text(
                    _date,
                    style: textStyles.darkBrownText4(dimensions),
                  ),
                ],
              ),
            if (textCardType == "invitation")
              Text(
                _invitation,
                textAlign: TextAlign.center,
                style: textStyles.darkBrownText3(dimensions),
              ),
          ],
        ),
      ),
    );
  }
}
