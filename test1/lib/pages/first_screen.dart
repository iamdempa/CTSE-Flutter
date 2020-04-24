import 'package:flutter/material.dart';
import 'package:test1/camera/camera_screen.dart';
import 'package:test1/pages/help.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: new Icon(Icons.live_tv),
        title: const Text('SnapNews'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Help()));
            },
          ),
        ],
      ),
      body: new ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return new GestureDetector(
            onTap: () {
              print("tapped");
            },
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                color: Colors.grey,
                height: 100.0,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.camera_enhance),
        label: const Text('Snap'),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CameraScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(null),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(null),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
