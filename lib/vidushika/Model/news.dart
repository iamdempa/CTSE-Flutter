import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String category;
  String headline;
  String description;
  String date;
  DocumentReference reference;

  News({this.category, this.headline, this.description , this.date});

  News.fromMap(Map<String, dynamic> map, {this.reference}):
    category = map["category"],
	headline = map["headline"],
	description = map["description"],
	date = map["date"];
  
  Map<String, dynamic> toMap(){
    return {
      "category": category,
	  "headline": headline,
	  "description": description,
	  "date": date,
    };

  } 
    News.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

    toJson(){
      return {
	  'category': category,
	  'headline': headline,
	  'description': description,
	  'date': date
	  
	  };
    }

  

  

}
