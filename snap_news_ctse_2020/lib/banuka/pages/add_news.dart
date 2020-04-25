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
        title: Text("Report a News",),
        backgroundColor: Colors.blueGrey,
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
                      child: GFImageOverlay(
                        height: 200,
                        width: 200,
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxFit: BoxFit.fill,
                        image: FileImage(File(widget.imgPath)),
                      )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
