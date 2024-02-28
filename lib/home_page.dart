import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/constants/button.dart';
import 'package:wedding/selection/comment_section.dart';
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

  final TextEditingController _searchInputFieldController = TextEditingController();
  final TextEditingController _familyCommentsController = TextEditingController();
  final FocusNode _searchInputFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _columnKey = GlobalKey();

  List<Person> _allPeople = [];
  String name = "";
  Family selectedFamily = Family();
  List<Person> _suggestedPeople = [];
  bool isExactMatch = false;
  bool isNotEmpty = true;

  late Future<List<Person>> futurePeople;
  late Family futureFamily;
  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePeople = _apiService.fetchPeople();
  }

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

  void scrollToElement(screenWidth) {
    _scrollController.animateTo(
      screenWidth * 200, //180
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool isInputVisible = false;
  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions(context);

    return Scaffold(
      backgroundColor: appColors.greyBackground,
      body: GestureDetector(
        onTap: () {
          _searchInputFieldFocusNode.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: dimensions.screenHeight * 2),
              ImageSlider(
                dimensions: dimensions,
              ),
              Container(
                height: 400,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // Outline border
                    labelText: 'Írd be a nevedet (pl.: Temmel Péter)',

                    // If text is empty, don't show the icon),
                  ),
                ),
              ),
              SizedBox(height: dimensions.screenHeight * 4),
              TextCard(
                  textCardType: "names",
                  textCardHeight: 33,
                  dimensions: dimensions,
                  appColors: appColors,
                  textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 2),
              TextCard(
                  textCardType: "location",
                  textCardHeight: 25,
                  dimensions: dimensions,
                  appColors: appColors,
                  textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 2),
              TextCard(
                  textCardType: "invitation",
                  textCardHeight: 85,
                  dimensions: dimensions,
                  appColors: appColors,
                  textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 4),
              searchInputField(dimensions),
              (_searchInputFieldFocusNode.hasFocus && _suggestedPeople.isNotEmpty)
                  ? searchSuggestionList(dimensions.screenHeight, dimensions.screenWidth)
                  : Container(),
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
                          familyMembers(dimensions.screenHeight, dimensions.screenWidth, appColors.greenInputBorder,
                              appColors.greyBackground),
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
                              selectedFamily: selectedFamily),
                          SizedBox(height: dimensions.screenWidth * 4),
                          Button(
                            onPressedFunction: () {
                              _apiService.sendFamily(
                                  selectedFamily, closingModal(dimensions.screenHeight, dimensions.screenWidth));
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
      ),
    );
  }

  Widget searchInputField(dimensions) {
    return Padding(
      padding: EdgeInsets.only(left: dimensions.screenWidth * 7.5, right: dimensions.screenWidth * 7.5),
      child: FocusScope(
          child: Container(
        height: dimensions.screenWidth * 12,
        child: TextField(
          key: _columnKey,
          controller: _searchInputFieldController,
          focusNode: _searchInputFieldFocusNode,
          onTap: () async {
            _allPeople = await _apiService.fetchPeople();
          },
          onSubmitted: (value) {
            setState(() {
              // Check if the entered value is in the options list
              isExactMatch = _allPeople.contains(value);
            });
          },
          onChanged: (String value) {
            _suggestedPeople = _allPeople;
            setState(() {
              // Check if the entered value is in the suggestions list

              _suggestedPeople = _allPeople.where((option) {
                return removeDiacritics(option.name.toLowerCase()).contains(removeDiacritics(value.toLowerCase()));
              }).toList();
              isNotEmpty = _suggestedPeople.isNotEmpty;
            });

            // Add a delay before scrolling
            scrollToBottom();
          },
          style: textStyle2(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ), // Outline border
            labelText: 'Írd be a nevedet (pl.: Temmel Péter)',
            labelStyle: textStyles.blackText3(dimensions),
            suffixIcon: _searchInputFieldController.text.isNotEmpty
                ? IconButton(
                    iconSize: dimensions.screenWidth * 5,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchInputFieldController.clear();
                        // Clear any suggestions and related states
                        _suggestedPeople.clear();
                        isExactMatch = false;
                        isInputVisible = false;
                      });
                    },
                  )
                : null, // If text is empty, don't show the icon),
          ),
        ),
      )),
    );
  }

  Widget searchSuggestionList(screenHeight, screenWidth) {
    return Container(
      width: screenWidth * 77,
      height: (_suggestedPeople.length > 3) ? 4 * screenWidth * 14 : _suggestedPeople.length * screenWidth * 12,
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
                style: textStyle2(),
              ),
            ),
            onTap: () async {
              selectedFamily = await _apiService.fetchFamily(_suggestedPeople[index].familyId);
              setState(() {
                isExactMatch = true;

                _searchInputFieldController.text = _suggestedPeople[index].name;
                _suggestedPeople = [];
              });
              scrollToElement(screenWidth);
              FocusManager.instance.primaryFocus?.unfocus();
            },
          );
        },
      ),
    );
  }

  Widget familyMembers(screenHeight, screenWidth, borderColor, greyBackground) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 3,
        ),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 3, left: screenWidth * 3),
          child: Text(
            "Jelöld be, melyik családtagod tud részt venni az esküvőn",
            textAlign: TextAlign.center,
            style: textStyle2().copyWith(fontSize: screenWidth * 4.8),
          ),
        ),
        SizedBox(
          height: screenWidth * 5,
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
                  padding: EdgeInsets.only(top: screenHeight * 2, left: screenWidth * 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFamily.members![index].hasAccepted = !selectedFamily.members![index].hasAccepted;
                      });
                    },
                    child: Container(
                      width: screenWidth * 60,
                      height: screenWidth * 12,
                      decoration: BoxDecoration(
                        color: selectedFamily.members![index].hasAccepted
                            ? appColors.lightGreenSelectedListTile
                            : greyBackground,
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
                            style: selectedFamily.members![index].hasAccepted
                                ? textStyle2().copyWith(
                                    fontSize: screenWidth * 3.5, color: greyBackground, fontWeight: FontWeight.w900)
                                : textStyle2().copyWith(fontSize: screenWidth * 3.5),
                          ),
                          if (selectedFamily.members![index].hasAccepted)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: screenWidth * 2),
                                Padding(
                                  padding: EdgeInsets.only(bottom: screenHeight * 0.5),
                                  child: Icon(Icons.check,
                                      size: screenWidth * 5, // Adjust the size as needed
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
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 2),
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: screenWidth * 8, // Adjust the size as needed
                          color: Color.fromARGB(255, 116, 35, 30),
                          onPressed: () {
                            setState(() {
                              selectedFamily.members!.removeAt(index);
                            });
                          }, // Adjust the color as needed
                        ),
                      ),
                    ],
                  )
              ],
            );
          },
        ),
        SizedBox(
          height: screenWidth * 4,
        ),
        (isInputVisible)
            ? Padding(
                padding: EdgeInsets.only(left: screenWidth * 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 60,
                      height: screenWidth * 12,
                      child: TextField(
                        style: textStyle2(),
                        onChanged: (value) {
                          // Update the name variable when text changes
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ), // Outline border
                            labelText: 'Plusz fő hozzáadása',
                            labelStyle: textStyle2(),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: screenWidth * 2),
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
                          width: screenWidth * 2,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: screenWidth * 8, // Adjust the size as needed
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
                height: screenWidth * 10,
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

  TextStyle textStyle() {
    return TextStyle(fontFamily: "Kalam", color: appColors.darkBrownText);
  }

  TextStyle textStyle2() {
    return TextStyle(fontFamily: "Kalam", color: appColors.blackText);
  }

  void closingModal(screenHeight, screenWidth) {
    showDialog(
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
