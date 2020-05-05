import 'package:flutter/material.dart';
import '../../Model/user.dart';
import '../../Controller/API.dart';
import '../../Model/news.dart';
import '../../Model/approvedNews.dart';
import 'AdminNewsList.dart';



class EditApprovedNews extends StatefulWidget {
  EditApprovedNews({Key key, this.approvedNews}) : super(key: key);
  final ApprovedNews approvedNews;
  @override
  _EditApprovedNewsState createState() => _EditApprovedNewsState();
}


class _EditApprovedNewsState extends State<EditApprovedNews> {
  static ApprovedNews _approvedNews;
  FirestoreService api = FirestoreService();
  static TextEditingController categoryController = TextEditingController();
  static TextEditingController headlineController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController(); 
  static TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  
  @override
  void initState() {
    _approvedNews= widget.approvedNews;
    newsCategory.controller.text = _approvedNews.category;
    newsHeadline.controller.text = _approvedNews.headline;
    newsDescription.controller.text = _approvedNews.description;
	newsDate.controller.text = _approvedNews.date;
    super.initState();
  }

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
        decoration: InputDecoration(
          labelText: "Date", hintText: "Click the button to pick a date"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please pick a date ';
          }
          return null;
        },
      );
	  
	  
	  
   Future<Null> _selectPublishDate(BuildContext context) async {
        final DateTime picked = await showDatePicker(
            context: context,
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light(),
                child: child,
              );
            },
            initialDate: selectedDate,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != selectedDate)
          setState(() {
            selectedDate = picked;
            newsDate.controller.text = selectedDate.toString().substring(0,10);
        });
   }

      pickDateForNewsButton(BuildContext context) {
        return RaisedButton(          
          color: Colors.purple[100],
          child: Text("Pick Date for News"),
          onPressed: (){
            _selectPublishDate(context);
          },
        );
      }	  
	  
  final _formKey = GlobalKey<FormState>();

  updateApprovedNews(){
    ApprovedNews newApprovedNews = ApprovedNews(category: newsCategory.controller.text, headline: newsHeadline.controller.text, description: newsDescription.controller.text, date: _approvedNews.date, userId: _approvedNews.userId, newsId: _approvedNews.newsId);
    api.updateApprovedNews(_approvedNews, newApprovedNews);
     Navigator.pop(
     context,
     MaterialPageRoute(builder: (context) => AdminNewsList()),
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
            updateApprovedNews();
          }              
        }),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Approve News'),
		backgroundColor: Colors.blue[300],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
		decoration: new BoxDecoration(
				//color: Colors.blue,
				image: new DecorationImage(
					image: new AssetImage("assets/imge.jpg"),
					fit: BoxFit.fill,)
			),	
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
                          newsHeadline,
                          newsDescription,
                          newsCategory,
						  newsDate,
						  pickDateForNewsButton(context),
                          saveChangesbutton(),
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