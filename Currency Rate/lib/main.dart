// ignore_for_file: prefer_const_constructors

import 'package:currency_rate/BottomNavBar.dart';
import 'package:currency_rate/Calender.dart';
import 'package:currency_rate/CurrencyRate.dart';
import 'package:currency_rate/Graph.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //Theme Color for Top Navigation Bar
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black), 
        scaffoldBackgroundColor: Colors.grey[200], // Set the background color of the page
      ),

      //Switch Tabs
      home: Scaffold(
        body: _getBody(currentTabIndex),
        bottomNavigationBar: BottomNavBar(
          onTabChange: (value) {
            setState(() {
              currentTabIndex = value;
            });
          },
        ),
      ),
    );
  }

  //Page Switching Function
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return CurrencyRate();
      case 1:
        return Calender();
      case 2:
        return Graph();
      default:
        return CurrencyRate();
    }
  }
}
