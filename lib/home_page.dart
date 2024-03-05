import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/constants/button.dart';
import 'package:wedding/selection/add_members.dart';
import 'package:wedding/modals/app_closing_modal.dart';
import 'package:wedding/selection/comment_section.dart';
import 'package:wedding/selection/list_of_members.dart';
import 'package:wedding/selection/text_title.dart';
import 'package:wedding/modals/reminder_modal.dart';
import 'package:wedding/services/api_service.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/dimensions.dart';
import 'package:wedding/constants/text_styles.dart';
import 'package:wedding/classes/family_class.dart';
import 'package:wedding/classes/person_class.dart';
import 'package:wedding/landing_page/image_slider.dart';
import 'package:wedding/landing_page/text_card.dart';
import 'package:wedding/services/loader.dart';
import 'package:wedding/services/time_out_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppColors appColors = AppColors();
  TextStyles textStyles = TextStyles();
  ClosingModal closingModal = ClosingModal();
  ReminderModal reminderModal = ReminderModal();

  late TextEditingController _searchInputFieldController;
  late ScrollController _scrollController;
  final GlobalKey _columnKey = GlobalKey();
  late FocusNode _searchInputFieldfocusNode;

  List<Person> _allPeople = [];
  List<Person> _suggestedPeople = [];
  Family selectedFamily = Family();

  String searchFieldLabelText = "Írd be a nevedet (pl.: Szabó Blanka)";
  String noPeopleFoundText = "Úgy látsztik rossz névvel próbálkozol...";
  String checkPeopleTitle = "Jelöld be, melyik családtagod tud részt venni az esküvőn";
  String addCommentTitle = "Add meg a megjegyzéseidet";
  String poweredByText = "Az appot készítette: Vujčić Luka, Skrapits Róbert\nAlias: Zsíros Deszkások (zsirosdeszkasok@gmail.com)";
  String name = "";
  String searchName = "";

  bool isExactMatch = false;
  bool isNotEmpty = true;
  bool isInputVisible = false;
  bool isLoaded = false;

  late Future<List<Person>> futurePeople;
  late Family futureFamily;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    _searchInputFieldController = TextEditingController();
    _scrollController = ScrollController();
    _searchInputFieldfocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchInputFieldfocusNode.dispose();
    _scrollController.dispose();
    _searchInputFieldController.dispose();
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

  onFamilyRecieved(updatedFamily) {
    setState(() {
      selectedFamily = updatedFamily;
    });
  }

  onBooleansRecieved(isNotEmpty, suggestedPeople, isExactMatch) {
    setState(() {
      isNotEmpty = isNotEmpty;
      _suggestedPeople = suggestedPeople;
      isExactMatch = isExactMatch;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions(context);
    return FutureBuilder<List<Person>>(
        future: _apiService.fetchPeople().timeout(const Duration(seconds: 15)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _allPeople = snapshot.data!;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: appColors.greyBackground,
              body: Center(
                child: SingleChildScrollView(
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
                      TextCard(textCardType: "invitation", textCardHeight: 30, dimensions: dimensions, appColors: appColors, textStyles: textStyles),
                      SizedBox(height: dimensions.screenHeight * 4),
                      searchField(dimensions),
                      if (_suggestedPeople.isNotEmpty || (_allPeople.isEmpty && _searchInputFieldfocusNode.hasFocus)) suggestionList(dimensions),
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
                                    SizedBox(
                                      height: dimensions.screenHeight * 2.5,
                                    ),
                                    TextTitle(
                                      title: checkPeopleTitle,
                                      dimensions: dimensions,
                                      textStyles: textStyles,
                                    ),
                                    SizedBox(
                                      height: dimensions.screenHeight * 2.5,
                                    ),
                                    ListOfMembers(
                                        dimensions: dimensions,
                                        selectedFamily: selectedFamily,
                                        appColors: appColors,
                                        textStyles: textStyles,
                                        onFamilyRecieved: onFamilyRecieved),
                                    SizedBox(
                                      height: dimensions.screenHeight * 2,
                                    ),
                                    AddMembers(
                                        dimensions: dimensions,
                                        isInputVisible: isInputVisible,
                                        selectedFamily: selectedFamily,
                                        appColors: appColors,
                                        textStyles: textStyles,
                                        onFamilyRecieved: onFamilyRecieved),
                                    SizedBox(height: dimensions.screenHeight * 4),
                                    TextTitle(
                                      title: addCommentTitle,
                                      dimensions: dimensions,
                                      textStyles: textStyles,
                                    ),
                                    SizedBox(
                                      height: dimensions.screenHeight * 2,
                                    ),
                                    CommentSection(
                                      dimensions: dimensions,
                                      appColors: appColors,
                                      textStyles: textStyles,
                                      selectedFamily: selectedFamily,
                                    ),
                                    SizedBox(height: dimensions.screenHeight * 2),
                                    Button(
                                      isPrimary: true,
                                      width: 38,
                                      onPressedFunction: () {
                                        if (selectedFamily.members!.every((member) => member.hasAccepted)) {
                                          _apiService.sendFamily(selectedFamily, closingModal.showClosingModal(context, dimensions, appColors, textStyles));
                                        } else {
                                          reminderModal.showReminderModal(
                                            context,
                                            dimensions,
                                            appColors,
                                            textStyles,
                                            closingModal,
                                            selectedFamily,
                                            _apiService,
                                          );
                                        }
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
                              : (isNotEmpty)
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 3.5, vertical: dimensions.screenHeight * 1.8),
                                      child: Text(noPeopleFoundText, textAlign: TextAlign.center, style: textStyles.darkBrownTextSmall(dimensions)),
                                    )),
                      SizedBox(height: dimensions.screenHeight * 1.5),
                      Text(
                        poweredByText,
                        style: textStyles.greenTextSmall(dimensions),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: dimensions.screenHeight * 2)
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle error case
            return TimeOutScreen(dimensions: dimensions, textStyles: textStyles, appColors: appColors);
          } else {
            return Loader(dimensions: dimensions, appColors: appColors);
          }
        });
  }

  Widget searchField(dimensions) {
    return Padding(
      padding: EdgeInsets.only(left: dimensions.screenWidth * 7.5, right: dimensions.screenWidth * 7.5),
      child: SizedBox(
        width: dimensions.screenWidth * 85,
        child: TextField(
          key: _columnKey,
          focusNode: _searchInputFieldfocusNode,
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
            if (!isLoaded) {
              searchName = value;
            }
            scrollToBottom();
          },
          style: textStyles.blackTextSmall(dimensions),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 4, vertical: dimensions.screenHeight * 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ), // Outline border
            labelText: searchFieldLabelText,
            labelStyle: textStyles.blackTextSmall(dimensions),
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

  Widget suggestionList(dimensions) {
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
                style: textStyles.blackTextSmall(dimensions),
              ),
            ),
            onTap: () async {
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
}
