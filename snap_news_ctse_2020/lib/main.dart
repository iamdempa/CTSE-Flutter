import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Model/user.dart';
import 'Model/news.dart';
import 'Widgets/AddNews.dart';
import 'Widgets/ReporterNewsList.dart';
import 'Widgets/ReporterEditNews.dart';
import 'Controller/API.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(       
        //primarySwatch: Colors.grey,
        
      ),
      home: AddNews(title: 'News'),
    );
  }
}

