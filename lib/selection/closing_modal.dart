import 'package:flutter/material.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

class ClosingModal extends StatelessWidget {
  final String textCardType;
  final int textCardHeight;
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;

  const ClosingModal(
      {Key? key,
      required this.textCardType,
      required this.textCardHeight,
      required this.dimensions,
      required this.appColors,
      required this.textStyles})
      : super(key: key);

  final _name1 = "Blanka";
  final _name2 = "Petya";
  final _location = "Szentpéterfa";
  final _date = "2024.07.27";
  final _invitation =
      "Kedves Családunk, Rokonaink és Barátaink!\nÖrömmel tudatjuk, hogy nemsokára eljön a nagy nap,\nmikor mindazok előtt, akik fontosak az életünkben,\nörök hűséget fogadunk egymásnak.\n\nSzeretnénk, ha velünk együtt örülnétek és\nünnepelnétek ezen a fontos napon,\nezért szeretettel meghívunk\n2024. Július 27-én 17:00 órakor a\nszentpéterfai Szent István Király kápolnában tartandó\nesküvőnkre, az azt követő vacsorára,\nmajd a hajnalig tartó mulatságra.";

  @override
  Widget build(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 5),
            child: Center(
              child: Container(
                decoration: BoxDecoration(color: appColors.greyBackground, borderRadius: BorderRadius.circular(20)),
                height: screenWidth * 68,
                width: screenWidth * 75,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Köszönjük, hogy kitöltötted!',
                      style: textStyle2().copyWith(fontSize: screenWidth * 5, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 2),
                    Text(
                      'Az esküvőn találkozunk! 🤟',
                      style: textStyle2().copyWith(fontSize: screenWidth * 4),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight),
                    Text(
                      'Ha bármi kérdésed lenne, hívj bátran:',
                      style: textStyle2().copyWith(fontSize: screenWidth * 4),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight),
                    Text(
                      'Blanka: +36 30 258 4048',
                      style: textStyle2().copyWith(fontSize: screenWidth * 4),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Petya: +36 30 011 8743',
                      style: textStyle2().copyWith(fontSize: screenWidth * 4),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 2),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 10, right: screenWidth * 10),
                      child: Container(
                        height: screenWidth * 10,
                        width: screenWidth * 20,
                        child: OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(appColors.greyBackground), // Text color
                              backgroundColor: MaterialStateProperty.all<Color>(appColors.darkGreenButton), // Fill color
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: appColors.greyBackground)), // Border color
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Close the modal when the button is pressed
                            },
                            child: Text("Bezár",
                                style: textStyle().copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: screenWidth * 4,
                                    color: appColors.greyBackground))),
                      ),
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
