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
        title: Text("Help - SnapNews",textAlign: TextAlign.center,),
        
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.orange,
                child: FlutterLogo(
                  size: 60.0,
                ),
              ),
              Container(
                color: Colors.blue,
                child: FlutterLogo(
                  size: 60.0,
                ),
              ),
              Container(
                color: Colors.purple,
                child: FlutterLogo(
                  size: 60.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
