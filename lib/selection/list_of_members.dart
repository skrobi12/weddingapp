import 'package:flutter/material.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

// ignore: must_be_immutable
class ListOfMembers extends StatefulWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  Family selectedFamily;
  Function onFamilyRecieved;
  ListOfMembers(
      {Key? key, required this.dimensions, required this.onFamilyRecieved, required this.selectedFamily, required this.appColors, required this.textStyles})
      : super(key: key);

  @override
  State<ListOfMembers> createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.selectedFamily.members?.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: widget.dimensions.screenHeight * 2, left: widget.dimensions.screenWidth * 15),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedFamily.members![index].hasAccepted = !widget.selectedFamily.members![index].hasAccepted;
                    widget.onFamilyRecieved(widget.selectedFamily);
                  });
                },
                child: Container(
                  width: widget.dimensions.screenWidth * 60,
                  height: widget.dimensions.screenHeight * 6,
                  decoration: BoxDecoration(
                    color: widget.selectedFamily.members![index].hasAccepted ? widget.appColors.lightGreenSelectedListTile : widget.appColors.greyBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.appColors.greenInputBorder, // specify the border color here
                      width: 2, // specify the border width here
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.selectedFamily.members![index].name,
                        style: widget.selectedFamily.members![index].hasAccepted
                            ? widget.textStyles.whiteTextMedium(widget.dimensions)
                            : widget.textStyles.blackTextSmall(widget.dimensions),
                      ),
                      if (widget.selectedFamily.members![index].hasAccepted)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: widget.dimensions.screenWidth * 2),
                            Padding(
                              padding: EdgeInsets.only(bottom: widget.dimensions.screenHeight * 0.5),
                              child: Icon(Icons.check,
                                  size: widget.dimensions.screenHeight * 3, // Adjust the size as needed
                                  color: widget.appColors.greyBackground // Adjust the color as needed
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.selectedFamily.members![index].isNew)
              Padding(
                padding: EdgeInsets.only(left: widget.dimensions.screenWidth * 2, top: widget.dimensions.screenHeight * 2),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: widget.dimensions.screenHeight * 4.5, // Adjust the size as needed
                  color: widget.appColors.redDeleteIcon,
                  onPressed: () {
                    setState(() {
                      widget.selectedFamily.members!.removeAt(index);
                      widget.onFamilyRecieved(widget.selectedFamily);
                    });
                  }, // Adjust the color as needed
                ),
              )
          ],
        );
      },
    );
  }
}
