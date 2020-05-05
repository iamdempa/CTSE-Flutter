import 'package:flutter/material.dart';
import '../../Controller/API.dart';
import '../../Model/news.dart';
import 'ReporterNewsList.dart';


class AddNews extends StatefulWidget {
      AddNews({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _AddNewsState createState() => _AddNewsState();
}


class _AddNewsState extends State<AddNews> {
      TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);

      //Controllers are defined to assign the values of TextFormfields
      static TextEditingController categoryController = TextEditingController();
	  static TextEditingController headlineController = TextEditingController();
      static TextEditingController descriptionController = TextEditingController();
      static TextEditingController dateController = TextEditingController();
      FirestoreService api = FirestoreService();

      final newsCategory = TextFormField(
        controller: categoryController,
        decoration: InputDecoration(
          labelText: "Category", hintText: "Select category"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please select category';
          }
          return null;
        },
      );

		
		
	  final newsHeadline = TextFormField(
        controller: headlineController,
        //keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Headline", hintText: "Enter headline"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter headline';
          }
          return null;
        },
      );	


      final newsDescription = TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: "Description", hintText: "Enter description"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter description for news';
          }
          return null;
        },
      );

      

      final newsDate = TextFormField(
        controller: dateController,
        //keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Date", hintText: "Enter date"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter date of news';
          }
          return null;
        },
      );

      //_formKey is used to validate the textFormfields
      final _formKey = GlobalKey<FormState>();
    
      getUsers(){
        return api.getUsers();
      }

      addNews(){
        News news = News(category: newsCategory.controller.text, headline: newsHeadline.controller.text, description: newsDescription.controller.text,date: newsDate.controller.text);
        api.addNews(news);
		Navigator.push(
		context,
		MaterialPageRoute(builder: (context) => ReporterNewsList(title: 'News List')),
		);
      }
	  
	  	  
      button() {
        return SizedBox(
          width: double.infinity,
          child: OutlineButton(
            child: Text("Add"),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                addNews();	
				
              }			  	
            }),
          );
      }
	  
	  buttonCancel() {
        return SizedBox(
          width: double.infinity,
          child: OutlineButton(
            child: Text("Cancel"),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                addNews();
              }              
            }),
          );
      }
	  
	  
	  
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
          ),
          body: Container(
            padding: EdgeInsets.all(20.0),
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
                                height: 50,
                              ),
                              button(),
                              SizedBox(
                                height: 20
                              ),
							  buttonCancel(),
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