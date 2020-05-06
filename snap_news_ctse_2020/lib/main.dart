// ====================================================================================
// IT17157124 - This is the main.dart that calls the "FirstScreen" screen. 
// ====================================================================================


// import the material and other necessary packages
import 'package:flutter/material.dart';
import 'package:snap_news_ctse_2020/banuka/pages/first_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapNews',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // call the class 
      home: FirstScreen(),
    );
  }
}
