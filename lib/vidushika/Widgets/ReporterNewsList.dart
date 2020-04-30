import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/news.dart';
import '../Controller/API.dart';
import 'ReporterEditNews.dart';
import 'AddNews.dart';


class ReporterNewsList extends StatefulWidget {
      ReporterNewsList({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _ReporterNewsListState createState() => _ReporterNewsListState();
}

class _ReporterNewsListState extends State<ReporterNewsList> {
  FirestoreService api = FirestoreService();
  TextStyle newsHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  String _title;  

  @override
  void initState() {
    _title= widget.title;
    super.initState();
  }

  getNews(){
    return api.getNews();
  }

  deleteNews(News news){
    api.deleteNews(news);
  }

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: getNews(),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          //print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  void _showDialog(News news) {
    // flutter defined function
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Manage News"),
          content: new Text("You are going to edit or delete this News! "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Edit"),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReporterEditNews(news: news)),
                );
                
              },
            ),
            new FlatButton(              
              child: new Text("Delete"),
              onPressed: () {
                deleteNews(news);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data){
    final news = News.fromSnapshot(data);
    return Padding (
      key: ValueKey(news.reference.documentID),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/location.jpg',  
              width: 300.0,
              height: 100.0,
              fit: BoxFit.fill,),
            
            ListTile(              
              title: Text(news.headline, style: newsHeadingStyle),
              subtitle: Text(news.description, style: newsHeadingStyle),  
			  trailing: IconButton(
                icon: Icon(Icons.delete), 
                onPressed: () {
                  deleteNews(news);
                },
                ),
              
              onLongPress: (){
                _showDialog(news);
              },
            ),
          ]
        )
        
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Padding(              
          padding: const EdgeInsets.all(5.0),
          child: Column(                
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Flexible(
                      child: buildBody(context)
                    )
            ],
          ),
        ),
      ),
    );
  }



}