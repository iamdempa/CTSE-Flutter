import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Model/user.dart';
import 'Model/news.dart';
import 'Model/approvedNews.dart';
import 'Widgets/Admin/AdminNewsList.dart';
import 'Widgets/Admin/EditApprovedNews.dart';
import 'Widgets/Reporter/AddNews.dart';
import 'Widgets/Reporter/ReporterNewsList.dart';
import 'Widgets/Reporter/ReporterEditNews.dart';
import 'Widgets/Authenticate/SignIn.dart';
import 'Widgets/Authenticate/SignUp.dart';
import 'Controller/API.dart';
import 'SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(       
        //primarySwatch: Colors.grey, accentColor: Colors.yellowAccent
      ),
	  debugShowCheckedModeBanner: false,  
      home: SplashScreen(),
    );
  }
}

