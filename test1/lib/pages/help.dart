import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  Help({Key key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help - SnapNews"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Column(
              children: [
                Center(
                  child: Text("Hi"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}