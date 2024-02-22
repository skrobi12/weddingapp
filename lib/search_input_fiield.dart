import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/classes/person_class.dart';

class SearchInputField extends StatefulWidget {
  final ScreenDimensions dimensions;
  final AppColors appColors;
  final TextStyles textStyles;
  final TextEditingController searchInputFieldController;
  final FocusNode searchInputFieldFocusNode;
  final ScrollController scrollController;
  final GlobalKey columnKey;
  List<Person> allPeople;
  final Family selectedFamily;
  List<Person> suggestedPeople;
  bool isExactMatch;
  bool isNotEmpty;

  SearchInputField({
    Key? key,
    required this.dimensions,
    required this.textStyles,
    required this.appColors,
    required this.searchInputFieldController,
    required this.searchInputFieldFocusNode,
    required this.scrollController,
    required this.columnKey,
    required this.allPeople,
    required this.selectedFamily,
    required this.suggestedPeople,
    required this.isExactMatch,
    required this.isNotEmpty,
  }) : super(key: key);

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  String _inputLabel = 'Írd be a nevedet (pl.: Temmel Péter)';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.dimensions.screenWidth * 7.5, right: widget.dimensions.screenWidth * 7.5),
      child: FocusScope(
        child: TextField(
          key: widget.columnKey,
          controller: widget.searchInputFieldController,
          focusNode: widget.searchInputFieldFocusNode,
          onSubmitted: (value) {
            setState(() {
              // Check if the suggestion list is empty, but we have a match (whole name is entered)
              widget.isExactMatch = widget.allPeople.contains(value);
            });
          },
          onChanged: (String value) {
            widget.suggestedPeople = widget.allPeople;
            setState(() {
              // Check if the entered value is in the suggestions list
              widget.suggestedPeople = widget.allPeople.where((option) {
                return removeDiacritics(option.name.toLowerCase()).contains(removeDiacritics(value.toLowerCase()));
              }).toList();
              widget.isNotEmpty = widget.suggestedPeople.isNotEmpty;
            });

            // Add a delay before scrolling
            scrollToBottom();
          },
          style: widget.textStyles.blackText1(widget.dimensions),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: _inputLabel,
            labelStyle: widget.textStyles.blackText1(widget.dimensions),
            suffixIcon: widget.searchInputFieldController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        widget.searchInputFieldController.clear();
                        // Clear any suggestions and related states
                        widget.suggestedPeople.clear();
                        widget.isExactMatch = false;
                      });
                    },
                  )
                : null, // If text is empty, don't show the icon,
          ),
        ),
      ),
    );
  }
}
