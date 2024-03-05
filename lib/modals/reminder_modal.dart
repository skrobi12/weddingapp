import 'package:flutter/material.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/constants/button.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
import 'package:wedding/modals/app_closing_modal.dart';
import 'package:wedding/services/api_service.dart';

class ReminderModal {
  final String _title = "Figyelem!";
  final String _infoText1 = "Úgy látszik a következő személy / személyek nem tudnak rész venni az esküvőn:";
  final String _infoText2 = "Szeretnéd elküldeni így a listát?";

  void showReminderModal(BuildContext context, ScreenDimensions dimensions, AppColors appColors, TextStyles textStyles, ClosingModal closingModal,
      Family selectedFamily, ApiService apiService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: appColors.greyBackground, borderRadius: BorderRadius.circular(20)),
              width: dimensions.screenWidth * 75,
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
                      _infoText1,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: selectedFamily.members?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (!selectedFamily.members![index].hasAccepted) {
                            return Center(
                              child: Text(
                                selectedFamily.members![index].name,
                                style: textStyles.blackTextMedium(dimensions),
                              ),
                            );
                          }
                          return null;
                        }),
                    SizedBox(height: dimensions.screenHeight * 2),
                    Text(
                      _infoText2,
                      style: textStyles.blackTextMedium(dimensions),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dimensions.screenHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(
                            isPrimary: false,
                            width: 27,
                            buttonTitle: "Mégse",
                            onPressedFunction: () {
                              Navigator.pop(context);
                            },
                            dimensions: dimensions,
                            appColors: appColors,
                            textStyles: textStyles),
                        Button(
                            isPrimary: true,
                            width: 27,
                            buttonTitle: "Igen",
                            onPressedFunction: () {
                              Navigator.pop(context);
                              apiService.sendFamily(selectedFamily, closingModal.showClosingModal(context, dimensions, appColors, textStyles));
                            },
                            dimensions: dimensions,
                            appColors: appColors,
                            textStyles: textStyles),
                      ],
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
