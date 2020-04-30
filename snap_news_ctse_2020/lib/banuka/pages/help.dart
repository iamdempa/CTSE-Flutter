
// import the packages necessary 
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button_bar.dart';
import 'package:getflutter/getflutter.dart';

class Help extends StatefulWidget {
  Help({Key key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

Widget _getCard() {
  return Center(
      child: GFCard(
    title: GFListTile(
      title: Text(
        'SnapNews - Help!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24.0),
      ),
    ),
    content: Text(
      "1.) Take a photo first to report a News\n\n2.) Provide a suitable description\n\n3.) Date and time will be added automatically\n\n4.) Click \"Add News\" button to Add the news",
      style: TextStyle(fontSize: 16.0, color: Colors.grey),
    ),
  ));
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help - SnapNews",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          child: _getCard(),
        ),
      ),
    );
  }
}
