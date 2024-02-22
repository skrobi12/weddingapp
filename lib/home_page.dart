import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/classes/api_service.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/classes/person_class.dart';
import 'package:wedding/welcome_part/image_slider.dart';
import 'package:wedding/welcome_part/text_card.dart';

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
              // FutureBuilder<List<Person>>(
              //   future: futurePeople,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       _allPeople = snapshot.data!;
              //       return Container();
              //     } else if (snapshot.hasError) {
              //       return Text('${snapshot.error}');
              //     } else {
              //       return const CircularProgressIndicator();
              //     }
              //   },
              // ),
              SizedBox(height: dimensions.screenHeight * 2),
              ImageSlider(
                dimensions: dimensions,
              ),
              SizedBox(height: dimensions.screenHeight * 4),
              TextCard(textCardType: "names", textCardHeight: 32, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 2),
              TextCard(textCardType: "location", textCardHeight: 25, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 2),
              TextCard(textCardType: "invitation", textCardHeight: 85, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
              SizedBox(height: dimensions.screenHeight * 4),
              Column(
                children: [
                  searchInputField(dimensions.screenWidth),
                  (_searchInputFieldFocusNode.hasFocus && _suggestedPeople.isNotEmpty)
                      ? searchSuggestionList(dimensions.screenHeight, dimensions.screenWidth)
                      : Container()
                ],
              ),
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
                          familyMembers(dimensions.screenHeight, dimensions.screenWidth, appColors.greenInputBorder, appColors.greyBackground),
                          SizedBox(height: dimensions.screenHeight * 4),
                          familyComments(dimensions.screenHeight, dimensions.screenWidth, appColors.greenInputBorder, appColors.greyBackground),
                          SizedBox(height: dimensions.screenHeight * 2),
                          OutlinedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(appColors.greyBackground), // Text color
                                backgroundColor: MaterialStateProperty.all<Color>(appColors.darkGreenButton), // Fill color
                                side: MaterialStateProperty.all<BorderSide>(BorderSide(color: appColors.greyBackground)), // Border color
                              ),
                              onPressed: () {
                                _apiService.sendFamily(selectedFamily, closeModal(dimensions.screenHeight, dimensions.screenWidth));
                                // sendFamily(selectedFamily, dimensions.screenHeight, dimensions.screenWidth);
                              },
                              child: Text(
                                "Küldés",
                                style:
                                    textStyle().copyWith(fontWeight: FontWeight.w900, fontSize: dimensions.screenWidth * 4.5, color: appColors.greyBackground),
                              )),
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

  Widget searchInputField(screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 7.5, right: screenWidth * 7.5),
      child: FocusScope(
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ), // Outline border
          labelText: 'Írd be a nevedet (pl.: Temmel Péter)',
          labelStyle: textStyle2(),
          suffixIcon: _searchInputFieldController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchInputFieldController.clear();
                      // Clear any suggestions and related states
                      _suggestedPeople.clear();
                      isExactMatch = false;
                    });
                  },
                )
              : null, // If text is empty, don't show the icon),
        ),
      )),
    );
  }

  Widget searchSuggestionList(screenHeight, screenWidth) {
    return Container(
      width: screenWidth * 77,
      height: (_suggestedPeople.length > 3) ? 4 * screenWidth * 14 : _suggestedPeople.length * screenWidth * 14,
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
          height: screenHeight * 2,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: selectedFamily.members?.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: screenHeight * 2, left: screenWidth * 15, right: screenWidth * 15),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedFamily.members![index].hasAccepted ? appColors.lightGreenSelectedListTile : greyBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor, // specify the border color here
                    width: 2, // specify the border width here
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFamily.members![index].hasAccepted = !selectedFamily.members![index].hasAccepted;
                    });
                  },
                  child: ListTile(
                    title: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedFamily.members![index].name,
                            style: selectedFamily.members![index].hasAccepted
                                ? textStyle2().copyWith(color: greyBackground, fontWeight: FontWeight.w900)
                                : textStyle2(),
                          ),
                          if (selectedFamily.members![index].hasAccepted)
                            SizedBox(
                              width: screenWidth * 3,
                            ),
                          if (selectedFamily.members![index].hasAccepted)
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.5),
                              child: Icon(Icons.check,
                                  size: screenWidth * 5, // Adjust the size as needed
                                  color: greyBackground // Adjust the color as needed
                                  ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget familyComments(screenHeight, screenWidth, borderColor, greyBackground) {
    return Column(
      children: [
        Text(
          "Add meg a megjegyzéseidet",
          style: textStyle2().copyWith(fontSize: screenWidth * 4.8),
        ),
        SizedBox(
          height: screenHeight * 2,
        ),
        Container(
          decoration: BoxDecoration(color: greyBackground, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor, width: 2)),
          height: screenWidth * 42,
          width: screenWidth * 80,
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth * 4, right: screenWidth * 4),
            child: TextField(
              style: textStyle2(),
              onTap: () {
                // Add a delay before scrolling
                scrollToBottom();
              },
              onChanged: (value) {
                // Save the entered data when it changes
                selectedFamily.comment = value;
              },
              controller: _familyCommentsController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'pl.: laktózérzékeny vagyok, nem bírom a Petyát :(', hintMaxLines: 3, hintStyle: textStyle2()),
              maxLines: null, // Allows for multiline input
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

  void closeModal(screenHeight, screenWidth) {
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
                height: screenWidth * 61,
                width: screenWidth * 75,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      'Ha bármi kérdésed lenne hívj bátran a következő számon:\n+36 20 435 8697',
                      style: textStyle2().copyWith(fontSize: screenWidth * 4),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 2),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 10, right: screenWidth * 10),
                      child: Container(
                        child: OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(appColors.greyBackground), // Text color
                              backgroundColor: MaterialStateProperty.all<Color>(appColors.darkGreenButton), // Fill color
                              side: MaterialStateProperty.all<BorderSide>(BorderSide(color: appColors.greyBackground)), // Border color
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Close the modal when the button is pressed
                            },
                            child: Text("Bezár",
                                style: textStyle().copyWith(fontWeight: FontWeight.w900, fontSize: screenWidth * 4, color: appColors.greyBackground))),
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
