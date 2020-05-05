import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/news.dart';
import '../../Model/approvedNews.dart';
import '../../Controller/API.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'EditApprovedNews.dart';

class AdminNewsList extends StatefulWidget {
      AdminNewsList({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _AdminNewsListState createState() => _AdminNewsListState();
}

class _AdminNewsListState extends State<AdminNewsList> {
  FirestoreService api = FirestoreService();
  TextStyle newsHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  String _title; 
  static TextEditingController searchBarController = TextEditingController(); 
  static Stream<QuerySnapshot> newsList;

  final String typeNews = "news";
  final String typeAppNews = "apprNews";

  @override
  void initState() {
    _title= widget.title;
	  newsList = getNews(typeNews);
    super.initState();
  }
  
  //Search function --methods
  void filterNewsByHeadline(String newsHeadline) async{    
    if(newsHeadline == "ALL"){
      setState(() {
        newsList = null;
        newsList = api.getNews();
        searchBarController.text = "";
      });
      
    }else{
      setState(() {
        newsList = null;
        newsList = api.getNewsByNewsHeadline(newsHeadline);        
      });      
    }    
  }

  Widget buildSearchBar(BuildContext context){
    return TextField(
      onEditingComplete: (){
        setState(() {
          newsList = null;
          filterNewsByHeadline(searchBarController.text);
        });
      },
      textInputAction: TextInputAction.search,
      controller: searchBarController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search News Here",        
        prefixIcon: IconButton(
          splashColor: Colors.blue,      
          iconSize: 20.0,
          icon: Icon(Icons.search), 
          onPressed: () {
            filterNewsByHeadline(searchBarController.text);
            },
        ),
        suffixIcon: IconButton(
          tooltip: "Clear Search",
          splashColor: Colors.blue,      
          iconSize: 20.0,
          icon: Icon(Icons.clear), 
          onPressed: () {
            filterNewsByHeadline("ALL");
            },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        )
      ),
    );
  }

  //build body of general news
  //buildList is used
  Widget buildNewsBodyWithSearch(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: newsList,
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          return buildList(context, snapshot.data.documents);
        }
      },
    );
  }
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data, "NEWS")).toList(),
    );
  }
  //Search function --methods -- end

  //db methods
  getNews(String newsType){
    if (newsType == "news"){
      return api.getNews();
    }
    else{
      return api.getApprovedNews();
    }    
  }

  addtoApproves(News news){
    ApprovedNews approvedNews = ApprovedNews(category: news.category, headline:news.headline, description: news.description, date: news.date, userId: "hiru", newsId: news.reference.documentID);
    api.addApprovedNews(approvedNews);
  }
  
  deleteNews(News news){
	api.deleteNews(news);
  }   
  
  deleteApprovedNews(ApprovedNews apprNews){
	api.deleteApprovedNews(apprNews);
  }	
  
  //build tab body based on newstype: news or approvedNews
  //buildApprovedList isused
  Widget buildApprovedNewsBody(BuildContext context, String newsType){
    return StreamBuilder<QuerySnapshot>(
      stream: getNews(newsType),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){          
          return buildApprovedList(context, snapshot.data.documents);
        }
      },
    );
  }
  //build list of body
  Widget buildApprovedList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data, "APPROVED")).toList(),
    );
  }
  //build list of body  

  //build list item of list
  Widget buildListItem(BuildContext context, DocumentSnapshot data, String type){
    var news;
	if(type == 'NEWS'){
		news = News.fromSnapshot(data);
	}
	else{
		news = ApprovedNews.fromSnapshot(data);
	}	
	//final news = News.fromSnapshot(data);    
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
            Image.asset('assets/profile.jpg',  
              width: 300.0,
              height: 100.0,
              fit: BoxFit.fill,),
            (type == "NEWS") ? newsSlidable(context, news) : approveNewsSlidable(context, news),
          ]
        )
      ),
    );
  }

  //Slidables for seperate news and approved
  //create a slidable tile for list item
  Widget newsSlidable(BuildContext context, News news) {
    return Slidable(
      actionPane: new SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: new ListTile(              
        title: Text(news.headline, style: newsHeadingStyle),
        subtitle: Text(news.description, style: newsHeadingStyle),
        
        onLongPress: (){
          //_showDialog(news);
        },
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Approve',
          color: Colors.green,
          icon: Icons.done,
          onTap: () {
            addtoApproves(news);
          } 
        ),
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_outline,
          onTap: (){
            deleteNews(news);
          }
        ),
      ],
    );
  }
  Widget approveNewsSlidable(BuildContext context, ApprovedNews apprNews) {
    return Slidable(
      actionPane: new SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: new ListTile(              
        title: Text(apprNews.headline, style: newsHeadingStyle),
        subtitle: Text(apprNews.description, style: newsHeadingStyle),        
        onLongPress: (){
          //_showDialog(news);
        },
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Edit',
          color: Colors.orange[300],
          icon: Icons.edit,
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditApprovedNews(approvedNews: apprNews)),
            );
          } 
        ),
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_outline,
          onTap: (){
            //delete approved news
            deleteApprovedNews(apprNews);
          }
        ),
      ],
    );
  }

  //create AddToFavourite and RemoveFromFavourites
  //TODO: create a add to favourite button while checking whether user has added this mall to their favourites 

  //tab of news
  Widget buildNewsTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.5),
      child: Padding(              
        padding: const EdgeInsets.all(5.0),
        child: Column(                
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
			    buildSearchBar(context),
				    Flexible(
              child: buildNewsBodyWithSearch(context)
            ),			    
          ],
        ),
      ),
    );
  }

  //tab of approved news
  Widget buildApprovedNewsTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Padding(              
        padding: const EdgeInsets.all(5.0),
        child: Column(                
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
                  child: buildApprovedNewsBody(context, typeAppNews)
            )
          ],
        ),
      ),
    );
  }

  //build screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
		    bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.store)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
            title: Text('News'),
          ),
          body: TabBarView(
            children: [
			        buildNewsTab(context),
              buildApprovedNewsTab(context)
            ],
			
          ),
        ),
      )
    ); 
  }  
}