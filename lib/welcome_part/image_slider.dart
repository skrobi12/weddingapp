import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wedding/constants/dimensions.dart';

class ImageSlider extends StatefulWidget {
  final ScreenDimensions dimensions;

  const ImageSlider({
    Key? key,
    required this.dimensions,
  }) : super(key: key);
  @override
  State<ImageSlider> createState() => _MyWidgetState();
}

int _currentPageIndex = 0;
late PageController _pageController;
final List<String> _imagePaths = List.generate(6, (index) => "assets/images/Image${(index % 5) + 1}.jpg");

class _MyWidgetState extends State<ImageSlider> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.dimensions.screenWidth * 62,
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
            padding: EdgeInsets.only(left: widget.dimensions.screenWidth * 2, right: widget.dimensions.screenWidth * 2),
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
}
