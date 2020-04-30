
// import the packages necessary 
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import 'package:snap_news_ctse_2020/banuka/api/firestore_service_api.dart';
import 'package:snap_news_ctse_2020/banuka/pages/add_news.dart';
import 'package:snap_news_ctse_2020/banuka/pages/first_screen.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:toast/toast.dart';

class ViewParticularNews extends StatefulWidget {
  final News news;

  ViewParticularNews({Key key, this.news}) : super(key: key);

  @override
  _ViewParticularNewsState createState() => _ViewParticularNewsState();
}

class _ViewParticularNewsState extends State<ViewParticularNews> {
  Widget _get_particular_news(News news) {
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

    String subtitleNew = news.description;

    Color priorityBadgeColor;
    String priorityNew;

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

    return SingleChildScrollView(
      child: GFCard(
        boxFit: BoxFit.cover,
        image: (news.imageUrl == null)
            ? Image.asset(
                "images/default_news_image.png",
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.network(news.imageUrl,
                height: 300.0, width: double.infinity, fit: BoxFit.cover),
        title: GFListTile(
          title: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200.0,
                    child: Text(
                      news.headline.toUpperCase(),
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                showDateAndTime,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Priority of the News: "),
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
            ],
          ),
        ),
      ),
    );
  }

  final SweetSheet showDeleteConfirmDialog = SweetSheet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.news.headline.toUpperCase()),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value.toLowerCase() == "edit") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddNews(news: widget.news)));
              } else if (value.toLowerCase() == "delete") {
                _deleteNews(widget.news.id, context, showDeleteConfirmDialog);
              } else {
                print("invalid value");
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text((choice == "Edit") ? "📋 Edit" : "❌ Delete"),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _get_particular_news(widget.news),
    );
  }
}

_deleteNews(String id, BuildContext context, SweetSheet showConfirmD) async {
  return await showConfirmD.show(
      context: context,
      description: Text("Are you sure you want to delete?"),
      color: SweetSheetColor.WARNING,
      positive: SweetSheetAction(title: "Confirm", onPressed: () async{
        await FireStoreServiceApi().delete_news(id);
        Toast.show("Successfully Deleted", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        Navigator.push(context, MaterialPageRoute(builder: (_) => FirstScreen()));
      }),
      negative: SweetSheetAction(
          title: "Cancel",
          onPressed: () {
            Navigator.of(context).pop();
          }));
}
