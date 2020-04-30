import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userName;
  DocumentReference reference;

  User({this.userName});

  User.fromMap(Map<String, dynamic> map, {this.reference}):
    userName = map["userName"];
  
  Map<String, dynamic> toMap(){
    return {
      "userName": userName
    };

  } 
    User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

    toJson(){
      return {'userName': userName};
    }

  

  

}
