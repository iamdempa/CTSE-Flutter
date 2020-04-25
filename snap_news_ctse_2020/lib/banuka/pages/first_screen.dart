import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:snap_news_ctse_2020/banuka/api/firestore_service_api.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import './camera_screen.dart';
import '../pages/help.dart';

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

Widget _getAppBar(BuildContext context) {
  return GFAppBar(
    centerTitle: true,
    backgroundColor: Colors.red,
    leading: GFIconButton(
      icon: Icon(
        Icons.live_tv,
        color: Colors.white,
        size: 25.0,
      ),
      onPressed: () {},
      type: GFButtonType.transparent,
    ),
    title: Text("Add a News"),
    actions: <Widget>[
      GFIconButton(
        icon: Icon(
          Icons.help_outline,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Help()));
        },
        type: GFButtonType.transparent,
      ),
    ],
  );
}

Widget _progressIndicator() {
  return GFLoader(type: GFLoaderType.ios);
}

Widget _getTiles(String title, String subtitle) {
  return GFListTile(
      titleText: title,
      subtitleText: subtitle,
      icon: Icon(Icons.favorite));
}

Widget _showSearchBar(BuildContext context) {
  List list = [
    "Banuka",
    "Banuka",
    "Banuka",
  ];

  return GFSearchBar(
    // overlaySearchListHeight: 160.0,
    searchList: list,
    searchQueryBuilder: (query, list) {
      return list
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    },
    overlaySearchListItemBuilder: (item) {
      return Container(
        padding: const EdgeInsets.all(3),
        child: Text(
          item,
          style: const TextStyle(fontSize: 18),
        ),
      );
    },
    onItemSelected: (item) {},
  );
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _getAppBar(context),
      body: Column(
        children: <Widget>[
          _showSearchBar(context),
          Expanded(
              child: StreamBuilder(
            stream: FireStoreService().getNews(),
            builder:
                (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return _progressIndicator();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    News news = snapshot.data[index];
                    return _getTiles(news.headline, news.description);
                  },
                );
              }
            },
          ))
        ],
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
