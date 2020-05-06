// ====================================================================================
// IT17157124 - The very first screen the user will be seen once the app is launched.
// reference: https://api.flutter.dev/flutter/widgets/ListView-class.html
// ====================================================================================

// import the packages necessary
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:snap_news_ctse_2020/banuka/api/firestore_service_api.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import 'package:snap_news_ctse_2020/banuka/pages/view_a_particular_news.dart';
import './camera_screen.dart';
import '../pages/help.dart';


// The class defition
class FirstScreen extends StatefulWidget {

  // News object declaration
  News news;

  FirstScreen({
    Key key,
    this.news,
  }) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

// get the AppBar value of the Scaffold's
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


// return the progress indicator if any network issue found
Widget _progressIndicator() {
  return GFLoader(type: GFLoaderType.ios);
}


// show the retrieved data from firestore as a List view
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


  if (news.description.length <= 60) {
    subtitleNew = news.description;
  } else if(news.description.length > 60){
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


// return values from firestore and show them when typing on the search bar
Future<List> getNewsOnSearchBar() async {

  // collection name
  final String _collection = 'news';

  // firestore instance
  final Firestore _fireStore = Firestore.instance;
  var newsList = [];

  // retrieve data
  Future<QuerySnapshot> getData() async {
    return await _fireStore.collection(_collection).getDocuments();
  }

  // call the method
  QuerySnapshot val = await getData();
  if (val.documents.length > 0) {
    for (int i = 0; i < val.documents.length; i++) {
      // filter out the headline field
      newsList.add(val.documents[i].data["headline"]);
    }
  } else {
    print("Not Found");
  }

  // return as a list
  return newsList;
}


class _FirstScreenState extends State<FirstScreen> {

  // variables and controllers declaration
  List<String> items;
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 4));

    // for search bar filters
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    // dispose the controller 
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // call the appbar 
      appBar: _getAppBar(context, widget.news),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // show the search bar
          Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 5),
            child: new TextField(
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: "Search news",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    borderSide: BorderSide(color: Colors.blue, width: 5.0)),
              ),
              controller: controller,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FireStoreServiceApi().getNews(),
            builder:
                (BuildContext context, AsyncSnapshot<List<News>> snapshot) {

                  // if any erros occured
              if (snapshot.hasError || !snapshot.hasData) {
                // show the loading progress bar
                return _progressIndicator();
              } else { // otherwse show the result/s
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    News news = snapshot.data[index];
                    return (filter == null)
                        ? new Card(
                            child: _getTiles(context, news),
                          )
                        : news.headline.contains(filter)
                            ? new Card(
                                child: _getTiles(context, news),
                              )
                            : new Text("");
                    // return _getTiles(context, news);
                  },
                );
              }
            },
          )),
        ],
      ),

      // floating action button for snaping the news
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
