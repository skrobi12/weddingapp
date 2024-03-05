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
  final _location = "Szentpéterfa, Kossuth L. u. 52.";
  final _date = "2024.07.27.";
  final _invitation1 = "Kedves Családunk, Rokonaink és Barátaink!";
  final _invitation2 =
      "Örömmel tudatjuk, hogy nemsokára eljön a nagy nap, mikor mindazok előtt, akik fontosak az életünkben, örök hűséget fogadunk egymásnak.\n\nSzeretnénk, ha velünk együtt örülnétek és ünnepelnétek ezen a fontos napon, ezért szeretettel meghívunk";
  final _invitation3 = "2024. Július 27-én 17:00 órakor";
  final _invitation4 = "a szentpéterfai Szent István Király kápolnában tartandó esküvőnkre, az azt követő vacsorára, majd a hajnalig tartó mulatságra.";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appColors.lightGreenCard, // Adjust this color as per your requirement
      ),
      width: dimensions.screenWidth * 85,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 3.5, vertical: dimensions.screenHeight * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (textCardType == "names")
              Column(
                children: [
                  Text(
                    _name1,
                    style: textStyles.darkBrownTextLarge(dimensions),
                  ),
                  Text(
                    "&",
                    style: textStyles.darkBrownTextMedium(dimensions),
                  ),
                  Text(
                    _name2,
                    style: textStyles.darkBrownTextLarge(dimensions),
                  ),
                ],
              ),
            if (textCardType == "location")
              Column(
                children: [
                  Text(
                    _location,
                    style: textStyles.darkBrownTextMedium(dimensions),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: dimensions.screenHeight * 1.8),
                  Text(
                    _date,
                    style: textStyles.darkBrownTextMedium(dimensions),
                  ),
                ],
              ),
            if (textCardType == "invitation")
              Column(
                children: [
                  Text(
                    _invitation1,
                    textAlign: TextAlign.center,
                    style: textStyles.darkBrownTextSmall(dimensions).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: dimensions.screenHeight * 2),
                  Text(
                    _invitation2,
                    textAlign: TextAlign.center,
                    style: textStyles.darkBrownTextSmall(dimensions),
                  ),
                  SizedBox(height: dimensions.screenHeight * 2),
                  Text(
                    _invitation3,
                    textAlign: TextAlign.center,
                    style: textStyles.darkBrownTextSmall(dimensions).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: dimensions.screenHeight * 2),
                  Text(
                    _invitation4,
                    textAlign: TextAlign.center,
                    style: textStyles.darkBrownTextSmall(dimensions),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
