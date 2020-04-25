import 'package:flutter/material.dart';
import '../Controller/API.dart';
import '../Model/news.dart';
//import 'package:uuid/uuid.dart';
import 'ReporterNewsList.dart';



class ReporterEditNews extends StatefulWidget {
  ReporterEditNews({Key key, this.news}) : super(key: key);
  final News news;
  @override
  _ReporterEditNewsState createState() => _ReporterEditNewsState();
}


class _ReporterEditNewsState extends State<ReporterEditNews> {
  static News _news;
  FirestoreService api = FirestoreService();
  TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);
  static TextEditingController categoryController = TextEditingController();
  static TextEditingController headlineController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  
  

  @override
  void initState() {
    _news= widget.news;
    newsCategory.controller.text = _news.category;
	newsHeadline.controller.text = _news.headline.toString();
    newsDescription.controller.text = _news.description;
    newsDate.controller.text = _news.date.toString();
    super.initState();
  }

  static final newsCategory = TextFormField(
    controller: categoryController,
    //initialValue: _news.category.toString(),
    decoration: InputDecoration(
      labelText: "Category", hintText: "Select the news Category"
    ),
    validator: (value){
      if (value.isEmpty && newsCategory.controller.text == ""){
        return 'Please select the news category';
      }
      return null;
    },
  );
  

  static final newsHeadline = TextFormField(
    controller: headlineController,
    //initialValue: _news.headline.toString(),
    //keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "Headline", hintText: "Enter headline"
    ),
    validator: (value){
      if (value.isEmpty && newsHeadline.controller.text == ""){
        return 'Please enter headline of news';
      }
      return null;
    },
  );	


  static final newsDescription = TextFormField(
    controller: descriptionController,
    //initialValue: _news.description.toString(),
    decoration: InputDecoration(
      labelText: "Description", hintText: "Enter description"
    ),
    validator: (value){
      if (value.isEmpty && newsDescription.controller.text == ""){
        return 'Please enter description for news';
      }
      return null;
    },
  );

  

  static final newsDate = TextFormField(
    controller: dateController,
    //initialValue: _news.date.toString(),
    //keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "Date", hintText: "Enter date"
    ),
    validator: (value){
      if (value.isEmpty && newsDate.controller.text == ""){
        return 'Please enter date of news';
      }
      return null;
    },
  );

  final _formKey = GlobalKey<FormState>();

  updateNews(){
    News newNews = News(category: newsCategory.controller.text, headline: newsHeadline.controller.text, description: newsDescription.controller.text, date: newsDate.controller.text);
    api.updateNews(_news, newNews);
    Navigator.pop(
    context,
    MaterialPageRoute(builder: (context) => ReporterNewsList(title: 'News Edit Console')),
    );
  }

  deleteNews(){
    api.deleteNews(_news);
    Navigator.pop(
    context,
    MaterialPageRoute(builder: (context) => ReporterNewsList(title: 'News Edit Console')),
    );
  }

  saveChangesbutton() {
    TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 15.0, color: Colors.white);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        highlightColor: Colors.green[200],
        color: Colors.green[400],
        child: Text("Save Changes", style: style,),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            updateNews();
          }              
        }),
      );
  }

  deleteNewsbutton() {
    TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 15.0, color: Colors.white);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        highlightColor: Colors.red[200],
        color: Colors.red[400],
        child: Text("Delete",style: style,),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            deleteNews();
          }              
        }),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mall'),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Padding(              
          padding: const EdgeInsets.all(36.0),
          child: Column(                
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          newsCategory,
                          SizedBox(
                            height: 10,
                          ),
						  newsHeadline,
                          SizedBox(
                            height: 10,
                          ),
                          newsDescription,
                          SizedBox(
                            height: 10,
                          ),
                          newsDate,
                          SizedBox(
                            height: 10,
                          ),
                          saveChangesbutton(),
                          deleteNewsbutton(),
                          SizedBox(
                            height: 20
                          ),
                        ],
                      ))
                    ],
                )
            ],
          ),
        ),
      ),
    );
  }
}