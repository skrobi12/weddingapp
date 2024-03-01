import 'package:flutter/material.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';

import '../classes/person_class.dart';

class AddMembers extends StatefulWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  final Family selectedFamily;
  bool isInputVisible;

  AddMembers(
      {Key? key, required this.dimensions, required this.isInputVisible, required this.selectedFamily, required this.appColors, required this.textStyles})
      : super(key: key);

  @override
  State<AddMembers> createState() => _AddMembersState();
}

String name = "";

class _AddMembersState extends State<AddMembers> {
  @override
  Widget build(BuildContext context) {
    return (widget.isInputVisible)
        ? Padding(
            padding: EdgeInsets.only(left: widget.dimensions.screenWidth * 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widget.dimensions.screenWidth * 60,
                  height: widget.dimensions.screenWidth * 12,
                  child: TextField(
                    onChanged: (value) {
                      // Update the name variable when text changes
                      setState(() {
                        name = value;
                      });
                    },
                    style: widget.textStyles.blackText3(widget.dimensions),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: widget.dimensions.screenWidth * 4, vertical: widget.dimensions.screenWidth * 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ), // Outline border
                        labelText: 'Plusz fő hozzáadása',
                        labelStyle: widget.textStyles.blackText3(widget.dimensions),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: widget.dimensions.screenWidth * 2),
                          child: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                widget.selectedFamily.members!.add(Person(name: name, hasAccepted: true, isNew: true));

                                name = "";
                                widget.isInputVisible = false;
                              });
                            },
                          ),
                        )
                        // If text is empty, don't show the icon),
                        ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: widget.dimensions.screenWidth * 2,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: widget.dimensions.screenWidth * 8, // Adjust the size as needed
                      color: Color.fromARGB(255, 116, 35, 30), // Adjust the color as needed
                      onPressed: () {
                        setState(() {
                          widget.isInputVisible = false;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        : SizedBox(
            height: widget.dimensions.screenWidth * 10,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  widget.isInputVisible = true;
                });
              },
              child: Icon(Icons.add),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Set borderRadius to zero
                ),
              ),
            ),
          );
  }
}
