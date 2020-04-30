
// import the packages necessary 
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:snap_news_ctse_2020/banuka/api/firestore_service_api.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import 'package:snap_news_ctse_2020/banuka/pages/view_a_particular_news.dart';
import './camera_screen.dart';
import '../pages/help.dart';
import 'package:splashscreen/splashscreen.dart';

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

class FirstScreen extends StatefulWidget {
  News news;

  FirstScreen({Key key, this.news}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

Widget _getAppBar(BuildContext context, News news) {
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
    title: Text("SnapNews"),
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

Widget _getTiles(BuildContext context, News news) {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);

  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  String dateNew;
  String timeNew;
  String showDateAndTime;

  if (news.timeDate == null) {
    dateNew = formattedDate;
  } else {
    dateNew = news.timeDate;
  }

  if (news.timeNews == null) {
    timeNew = currentTime;
  } else {
    timeNew = news.timeNews;
  }

  showDateAndTime = dateNew + " - " + timeNew;

  String subtitleNew = "";

  if (news.description.length <= 20) {
    subtitleNew = news.description;
  } else {
    subtitleNew = news.description.substring(0, 60) + "...";
  }

  Color priorityBadgeColor;
  String priorityNew;
  String headlineNew;

  if (news.headline.length <= 20) {
    headlineNew = news.headline;
  } else {
    headlineNew = news.headline.substring(0, 20) + "...";
  }

  if (news.priority != null) {
    priorityNew = news.priority;
    if (news.priority.toLowerCase() == "high") {
      priorityBadgeColor = Colors.red;
      priorityNew = "H";
    } else if (news.priority.toLowerCase() == "medium") {
      priorityBadgeColor = Colors.orange;
      priorityNew = "M";
    } else if (news.priority.toLowerCase() == "low") {
      priorityBadgeColor = Colors.green;
      priorityNew = "L";
    }
  } else {
    priorityBadgeColor = Colors.grey;
    priorityNew = "N/A";
  }

  return GFCard(
    boxFit: BoxFit.cover,
    image:
        (news.imageUrl == null || news.imageUrl.isEmpty || news.imageUrl == "")
            ? Image.asset(
                "images/default_news_image.png",
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.network(news.imageUrl,
                height: 200.0, width: double.infinity, fit: BoxFit.cover),
    title: GFListTile(
      title: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              headlineNew.toUpperCase(),
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
      subTitle: Align(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            "\n" + subtitleNew,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    content: Align(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            showDateAndTime,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 10.0,
          ),
          GFBadge(
            color: priorityBadgeColor,
            text: priorityNew,
            size: GFSize.SMALL,
          ),
        ],
      ),
    ),
    buttonBar: GFButtonBar(
      alignment: WrapAlignment.center,
      children: <Widget>[
        GFButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewParticularNews(news: news)));
          },
          icon: Icon(
            Icons.more,
            color: Colors.white,
            size: 14.0,
          ),
          text: 'Read More',
        )
      ],
    ),
  );
}

Widget _showSearchBar(BuildContext context) {
  var banuka = [];

  return GFSearchBar(
    // overlaySearchListHeight: 160.0,
    searchList: banuka,
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
      appBar: _getAppBar(context, widget.news),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showSearchBar(context),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FireStoreServiceApi().getNews(),
            builder:
                (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return _progressIndicator();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    News news = snapshot.data[index];
                    return _getTiles(context, news);
                  },
                );
              }
            },
          )),
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
