import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:wedding/constants/colors.dart';
import 'package:wedding/constants/generic_parameters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wedding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffa3b19a)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<Person>> fetchPeople() async {
  final responsePeople = await http.get(Uri.parse('http://192.168.1.196:8080/api/people'));

  if (responsePeople.statusCode == 200) {
    // If the server did return a 200 OK responsePeople,

    // Get the encoding from the response headers
    //final encoding = Encoding.getByName(responsePeople.headers['content-type']);

    // Decode the response body using the determined encoding
    final decodedBody = utf8.decode(responsePeople.bodyBytes, allowMalformed: true);

    // then parse the JSON.
    List<dynamic> jsonResponse = jsonDecode(decodedBody);
    List<Person> people = jsonResponse.map((jsonPerson) => Person.fromJson(jsonPerson)).toList();
    return people;
  } else {
    // If the server did not return a 200 OK responsePeople,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Family> fetchFamily(selectedFamilyId) async {
  final responseFamily = await http.get(Uri.parse('http://192.168.1.196:8080/api/families/$selectedFamilyId'));

  if (responseFamily.statusCode == 200) {
    // If the server did return a 200 OK responsePeople,
    final decodedBody = utf8.decode(responseFamily.bodyBytes, allowMalformed: true);
    // then parse the JSON.
    return Family.fromJson(jsonDecode(decodedBody) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK responsePeople,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Family {
  int? id;
  List<Person>? members;
  String? comment;

  Family({this.id, this.members, this.comment});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] as int?,
      members: (json['members'] as List<dynamic>)
          .map((jsonPerson) => Person.fromJson(jsonPerson as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String?,
    );
  }
}

class Person {
  int? id;
  int? familyId;
  final String name;
  bool hasAccepted;

  Person({
    this.id,
    this.familyId,
    required this.name,
    required this.hasAccepted,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'familyId': int familyId,
        'name': String name,
        'hasAccepted': bool hasAccepted,
      } =>
        Person(
          id: id,
          familyId: familyId,
          name: name,
          hasAccepted: hasAccepted,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class _MyHomePageState extends State<MyHomePage> {
  AppColors appColors = AppColors();
//
//
//
//
//

  // TO BE REFACTORED
  // strings
  String invitationText =
      "Nem tudhatom, hogy másnak e tájék mit jelent, nekem szülőhazám itt e lángoktól öleltkis ország, messzeringó gyerekkorom világa. Belőle nőttem én, mint fatörzsből gyönge ágas remélem, testem is majd e földbe süpped el. Itthon vagyok";
  String nameWife = "Blanka";
  String nameHusband = "Petya";
  // colors

  late PageController _pageController;
  int _currentPageIndex = 0;
  final List<String> _imagePaths2 = [
    "assets/images/Image1.jpg",
    "assets/images/Image2.jpg",
    "assets/images/Image3.jpg",
    "assets/images/Image1.jpg",
  ];

  final List<String> _imagePaths = List.generate(5, (index) => "assets/images/Image${(index % 4) + 1}.jpg");

  final TextEditingController _searchInputFieldController = TextEditingController();
  final TextEditingController _familyCommentsController = TextEditingController();
  final FocusNode _searchInputFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _columnKey = GlobalKey();
  Family selectedFamily = Family();

  late List<Person> _allPeople = [];
  List<Person> _suggestedPeople = [];
  //List<String> _selectedFamily = [];
  bool isInvited = false;
  bool isNameInList = true;
  List<int> _selectedIndices = [];

  late Future<List<Person>> futurePeople;
  late Family futureFamily;

  @override
  void initState() async {
    super.initState();
    _allPeople = await fetchPeople();
    _pageController = PageController(initialPage: 0);
    // Start a timer to change images with individual durations
    for (int i = 0; i < 2; i++) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentPageIndex < _imagePaths.length - 1) {
          _pageController.animateToPage(_currentPageIndex + 1, duration: const Duration(seconds: 2), curve: Curves.ease);
        } else {
          // Jump from the last image to the first image
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
              SizedBox(height: dimensions.screenHeight * 2),
              movingPictures(dimensions.screenHeight, dimensions.screenWidth),
              SizedBox(height: dimensions.screenHeight * 4),
              names(dimensions.screenHeight, dimensions.screenWidth, nameWife, nameHusband, appColors.lightGreenCard),
              SizedBox(height: dimensions.screenHeight * 2),
              locationAndTime(
                dimensions.screenHeight,
                dimensions.screenWidth,
              ),
              SizedBox(height: dimensions.screenHeight * 2),
              invitation(dimensions.screenHeight, dimensions.screenWidth, invitationText, appColors.lightGreenCard),
              SizedBox(height: dimensions.screenHeight * 4),
              // OutlinedButton(
              //     onPressed: () {
              //       setState(() {
              //         request();
              //       });
              //     },
              //     child: Text("Működjé")),
              // const Text("Melyik családhoz tartozol?"),
              // sizedbox(),
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
                child: isInvited
                    ? Column(
                        children: [
                          familyMembers(dimensions.screenHeight, dimensions.screenWidth, appColors.greenInputBorder,
                              appColors.greyBackground),
                          SizedBox(height: dimensions.screenHeight * 4),
                          familyComments(dimensions.screenHeight, dimensions.screenWidth, appColors.greenInputBorder,
                              appColors.greyBackground),
                          SizedBox(height: dimensions.screenHeight * 2),
                          OutlinedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(appColors.greyBackground), // Text color
                                backgroundColor: MaterialStateProperty.all<Color>(appColors.darkGreenButton), // Fill color
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: appColors.greyBackground)), // Border color
                              ),
                              onPressed: () {
                                sendFamily(selectedFamily, dimensions.screenHeight, dimensions.screenWidth);
                              },
                              child: Text(
                                "Küldés",
                                style: textStyle().copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: dimensions.screenWidth * 4.5,
                                    color: appColors.greyBackground),
                              )),
                          SizedBox(
                            height: dimensions.screenHeight * 3,
                          )
                        ],
                      )
                    : isNameInList
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

  Widget movingPictures(screenHeight, screenWidth) {
    return SizedBox(
      height: screenWidth * 62,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: screenWidth * 2, right: screenWidth * 2),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: Image.asset(
                _imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget names(screenHeight, screenWidth, name1, name2, lightGreenCard) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: lightGreenCard, // Adjust this color as per your requirement
      ),
      height: screenWidth * 28,
      width: screenWidth * 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name1,
            style: textStyle().copyWith(fontSize: screenWidth * 6.5),
          ),
          Text("&",
              style: textStyle().copyWith(
                fontSize: screenWidth * 3.5,
              )),
          Text(
            name2,
            style: textStyle().copyWith(fontSize: screenWidth * 6.5),
          ),
        ],
      ),
    );
  }

  Widget locationAndTime(screenHeight, screenWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appColors.lightGreenCard, // Adjust this color as per your requirement
      ),
      height: screenWidth * 20,
      width: screenWidth * 80,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 4),
        child: Text(
          "Szentpéterfa\n2024.07.27",
          textAlign: TextAlign.center,
          style: textStyle().copyWith(fontSize: screenWidth * 4.5),
        ),
      ),
    );
  }

  Widget invitation(screenHeight, screenWidth, invitationText, color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color, // Adjust this color as per your requirement
      ),
      height: screenWidth * 42,
      width: screenWidth * 80,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 5),
        child: Text(
          invitationText,
          textAlign: TextAlign.center,
          style: textStyle().copyWith(fontSize: screenWidth * 3.8),
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
        onSubmitted: (value) {
          setState(() {
            // Check if the entered value is in the options list
            isInvited = _allPeople.contains(value);
          });
        },
        onChanged: (String value) {
          _suggestedPeople = _allPeople;
          setState(() {
            // Check if the entered value is in the suggestions list

            _suggestedPeople = _allPeople.where((option) {
              return removeDiacritics(option.name.toLowerCase()).contains(removeDiacritics(value.toLowerCase()));
            }).toList();
            isNameInList = _suggestedPeople.isNotEmpty;
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
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchInputFieldController.clear();
                      // Clear any suggestions and related states
                      _suggestedPeople.clear();
                      isInvited = false;
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
              selectedFamily = await fetchFamily(_suggestedPeople[index].familyId);
              setState(() {
                isInvited = true;

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
          decoration: BoxDecoration(
              color: greyBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2)),
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
                  border: InputBorder.none,
                  hintText: 'pl.: laktózérzékeny vagyok, nem bírom a Petyát :(',
                  hintMaxLines: 3,
                  hintStyle: textStyle2()),
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
                padding: EdgeInsets.all(16.0),
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

  void sendFamily(Family selectedFamily, screenHeight, screenWidth) async {
    final responsePeople = await http.put(Uri.parse('http://192.168.1.196:8080/api/families/${selectedFamily.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Specify JSON content type
        },
        body: jsonEncode(<String, dynamic>{
          'id': selectedFamily.id,
          'members': selectedFamily.members!
              .map((member) =>
                  {'id': member.id, 'name': member.name, 'hasAccepted': member.hasAccepted, 'familyId': member.familyId})
              .toList(),
          'comment': selectedFamily.comment
        }));

    if (responsePeople.statusCode == 204) {
      // If the server did return a 200 OK responsePeople,
      // then parse the JSON.

      closeModal(screenHeight, screenWidth);
    } else {
      // If the server did not return a 200 OK responsePeople,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
