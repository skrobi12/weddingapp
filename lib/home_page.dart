import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/constants/button.dart';
import 'package:wedding/selection/add_members.dart';
import 'package:wedding/selection/closing_modal.dart';
import 'package:wedding/selection/comment_section.dart';
import 'package:wedding/selection/list_of_members.dart';
import 'package:wedding/selection/text_title.dart';
import 'package:wedding/services/api_service.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/classes/person_class.dart';
import 'package:wedding/landing_page/image_slider.dart';
import 'package:wedding/landing_page/text_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppColors appColors = AppColors();
  TextStyles textStyles = TextStyles();
  ClosingModal closingModal = ClosingModal();

  final TextEditingController _searchInputFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _columnKey = GlobalKey();

  List<Person> _allPeople = [];
  List<Person> _suggestedPeople = [];
  Family selectedFamily = Family();
  String name = "";

  bool isExactMatch = false;
  bool isNotEmpty = true;
  bool isInputVisible = false;

  late Future<List<Person>> futurePeople;
  late Family futureFamily;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    super.dispose();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void scrollToElement(dimension) {
    _scrollController.animateTo(
      dimension.screenHeight * 140,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void fechPeopleFunction() async {
    _allPeople = await _apiService.fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions(context);
    fechPeopleFunction();
    return Scaffold(
      backgroundColor: appColors.greyBackground,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(height: dimensions.screenHeight * 2),
            ImageSlider(
              dimensions: dimensions,
            ),
            SizedBox(height: dimensions.screenHeight * 4),
            TextCard(textCardType: "names", textCardHeight: 18, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
            SizedBox(height: dimensions.screenHeight * 2),
            TextCard(textCardType: "location", textCardHeight: 14, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
            SizedBox(height: dimensions.screenHeight * 2),
            TextCard(textCardType: "invitation", textCardHeight: 45, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
            SizedBox(height: dimensions.screenHeight * 4),
            searchInputField(dimensions),
            //(_searchInputFieldFocusNode.hasFocus && _suggestedPeople.isNotEmpty)
            if (_suggestedPeople.isNotEmpty) searchSuggestionList(dimensions),
            SizedBox(height: dimensions.screenHeight * 2),
            Container(
              width: dimensions.screenWidth * 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: appColors.greyCard,
              ),
              child: isExactMatch
                  ? Column(
                      children: [
                        familyMembers(dimensions, appColors.greenInputBorder, appColors.greyBackground),
                        SizedBox(height: dimensions.screenWidth * 8),
                        TextTitle(
                          dimensions: dimensions,
                          textStyles: textStyles,
                        ),
                        SizedBox(
                          height: dimensions.screenWidth * 4,
                        ),
                        CommentSection(
                          dimensions: dimensions,
                          appColors: appColors,
                          textStyles: textStyles,
                          selectedFamily: selectedFamily,
                        ),
                        SizedBox(height: dimensions.screenWidth * 4),
                        Button(
                          onPressedFunction: () {
                            _apiService.sendFamily(selectedFamily, closingModal.showClosingModal(context, dimensions, appColors, textStyles));
                          },
                          buttonTitle: 'Küldés',
                          dimensions: dimensions,
                          appColors: appColors,
                          textStyles: textStyles,
                        ),
                        SizedBox(
                          height: dimensions.screenHeight * 3,
                        )
                      ],
                    )
                  : isNotEmpty
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.all(dimensions.screenWidth * 3),
                          child: const Text(
                            "Úgy látsztik téged nem hívtak meg, vagy rossz névvel próbálkozol :(",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Kalam",
                            ),
                          ),
                        ),
            ),
            SizedBox(height: dimensions.screenHeight * 2)
          ],
        ),
      ),
    );
  }

  Widget searchInputField(dimensions) {
    return Padding(
      padding: EdgeInsets.only(left: dimensions.screenWidth * 7.5, right: dimensions.screenWidth * 7.5),
      child: SizedBox(
        width: dimensions.screenWidth * 85,
        child: TextField(
          key: _columnKey,
          controller: _searchInputFieldController,
          onTap: () async {},
          onSubmitted: (value) {
            setState(() {
              // Check if the entered value is in the options list
              isExactMatch = _allPeople.contains(value);
            });
          },
          onChanged: (String value) {
            setState(() {
              // Check if the entered value is in the suggestions list
              _suggestedPeople = _allPeople.where((option) {
                return removeDiacritics(option.name.toLowerCase()).contains(removeDiacritics(value.toLowerCase()));
              }).toList();
              isNotEmpty = _suggestedPeople.isNotEmpty;
            });
            scrollToBottom();
          },
          style: textStyles.blackText3(dimensions),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight * 2, vertical: dimensions.screenHeight * 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ), // Outline border
            labelText: 'Írd be a nevedet (pl.: Temmel Péter)',
            labelStyle: textStyles.blackText3(dimensions),
            suffixIcon: _searchInputFieldController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: dimensions.screenWidth * 2),
                    child: IconButton(
                      iconSize: dimensions.screenHeight * 2.5,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchInputFieldController.clear();
                          _suggestedPeople.clear();
                          isExactMatch = false;
                          isNotEmpty = true;
                        });
                      },
                    ),
                  )
                : null, // If text is empty, don't show the icon),
          ),
        ),
      ),
    );
  }

  Widget searchSuggestionList(dimensions) {
    return Container(
      width: dimensions.screenWidth * 77,
      height: (_suggestedPeople.length > 3) ? 4 * dimensions.screenHeight * 5.5 : _suggestedPeople.length * dimensions.screenHeight * 5.5,
      decoration: BoxDecoration(
        color: appColors.darkGreenDropDownList,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), // Radius for bottom left corner
          bottomRight: Radius.circular(20), // Radius for bottom right corner
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _suggestedPeople.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(
              child: Text(
                _suggestedPeople[index].name,
                style: textStyles.blackText3(dimensions),
              ),
            ),
            onTap: () async {
              // Maybe here?
              selectedFamily = await _apiService.fetchFamily(_suggestedPeople[index].familyId);
              setState(() {
                _searchInputFieldController.text = _suggestedPeople[index].name;
                _suggestedPeople = [];
                isExactMatch = true;
              });
              scrollToElement(dimensions);
            },
          );
        },
      ),
    );
  }

  Widget familyMembers(dimensions, borderColor, greyBackground) {
    return Column(
      children: [
        SizedBox(
          height: dimensions.screenHeight * 3,
        ),
        Padding(
          padding: EdgeInsets.only(right: dimensions.screenWidth * 3, left: dimensions.screenWidth * 3),
          child: Text(
            "Jelöld be, melyik családtagod tud részt venni az esküvőn",
            textAlign: TextAlign.center,
            style: textStyles.blackText5(dimensions),
          ),
        ),
        SizedBox(
          height: dimensions.screenWidth * 5,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: selectedFamily.members?.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: dimensions.screenHeight * 2, left: dimensions.screenWidth * 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFamily.members![index].hasAccepted = !selectedFamily.members![index].hasAccepted;
                      });
                    },
                    child: Container(
                      width: dimensions.screenWidth * 60,
                      height: dimensions.screenWidth * 12,
                      decoration: BoxDecoration(
                        color: selectedFamily.members![index].hasAccepted ? appColors.lightGreenSelectedListTile : greyBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: borderColor, // specify the border color here
                          width: 2, // specify the border width here
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedFamily.members![index].name,
                            style: selectedFamily.members![index].hasAccepted ? textStyles.whiteText3(dimensions) : textStyles.blackText3(dimensions),
                          ),
                          if (selectedFamily.members![index].hasAccepted)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: dimensions.screenWidth * 2),
                                Padding(
                                  padding: EdgeInsets.only(bottom: dimensions.screenHeight * 0.5),
                                  child: Icon(Icons.check,
                                      size: dimensions.screenWidth * 5, // Adjust the size as needed
                                      color: greyBackground // Adjust the color as needed
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (selectedFamily.members![index].isNew)
                  Padding(
                    padding: EdgeInsets.only(left: dimensions.screenWidth * 2, top: dimensions.screenHeight * 2),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: dimensions.screenWidth * 8, // Adjust the size as needed
                      color: Color.fromARGB(255, 116, 35, 30),
                      onPressed: () {
                        setState(() {
                          selectedFamily.members!.removeAt(index);
                        });
                      }, // Adjust the color as needed
                    ),
                  )
              ],
            );
          },
        ),
        SizedBox(
          height: dimensions.screenWidth * 4,
        ),
        (isInputVisible)
            ? Padding(
                padding: EdgeInsets.only(left: dimensions.screenWidth * 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: dimensions.screenWidth * 60,
                      height: dimensions.screenWidth * 12,
                      child: TextField(
                        onChanged: (value) {
                          // Update the name variable when text changes
                          setState(() {
                            name = value;
                          });
                        },
                        style: textStyles.blackText3(dimensions),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 4, vertical: dimensions.screenWidth * 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ), // Outline border
                            labelText: 'Plusz fő hozzáadása',
                            labelStyle: textStyles.blackText3(dimensions),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: dimensions.screenWidth * 2),
                              child: IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    selectedFamily.members!.add(Person(name: name, hasAccepted: true, isNew: true));

                                    name = "";
                                    isInputVisible = false;
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
                          width: dimensions.screenWidth * 2,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: dimensions.screenWidth * 8, // Adjust the size as needed
                          color: Color.fromARGB(255, 116, 35, 30), // Adjust the color as needed
                          onPressed: () {
                            setState(() {
                              isInputVisible = false;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            : SizedBox(
                height: dimensions.screenWidth * 10,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isInputVisible = true;
                    });
                  },
                  child: Icon(Icons.add),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Set borderRadius to zero
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
