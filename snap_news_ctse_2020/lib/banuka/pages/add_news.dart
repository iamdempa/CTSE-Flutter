import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class AddNews extends StatefulWidget {
  final String imgPath;

  AddNews({this.imgPath});

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add News"),
        backgroundColor: Colors.black,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      
                      child:Image.file(
                      File(widget.imgPath),                      
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: 200.0,
                    ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
