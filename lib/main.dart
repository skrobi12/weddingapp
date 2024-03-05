import 'package:flutter/material.dart';
import 'package:wedding/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'B&P Wedding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffa3b19a)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
