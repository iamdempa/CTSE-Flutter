import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedNews {
  String userId;
  String newsId;
  String category;
  String headline;
  String description;
  String date;
  DocumentReference reference;

  ApprovedNews({this.userId, this.newsId, this.category, this.headline, this.description , this.date});

  ApprovedNews.fromMap(Map<String, dynamic> map, {this.reference}):
    userId = map["userId"],
	newsId = map["newsId"],
	category = map["category"],
	headline = map["headline"],
	description = map["description"],
	date = map["date"];
  
  Map<String, dynamic> toMap(){
    return {
      "userId": userId,
	  "newsId": newsId,
	  "category": category,
	  "headline": headline,
	  "description": description,
	  "date": date,
    };

  } 
    ApprovedNews.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

    toJson(){
      return {
	  'userId': userId,
	  'newsId': newsId,
	  'category': category,
	  'headline': headline,
	  'description': description,
	  'date': date
	  
	  };
    }

  

  

}
