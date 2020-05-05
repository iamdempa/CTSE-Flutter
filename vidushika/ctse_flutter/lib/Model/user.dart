import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String fullName;
  String userType;
  String userName;
  String email;
  String password;
  
  DocumentReference reference;

  User({this.userId, this.fullName, this.userType, this.userName, this.email, this.password});

  User.fromMap(Map<String, dynamic> map, {this.reference}):
    userId = map["userId"],
	fullName = map["fullName"],
	userType = map["userType"],
	userName = map["userName"],
	email = map["email"],
	password = map["password"];
  
  Map<String, dynamic> toMap(){
    return {
	  "userId": userId,
	  "fullName": fullName,
	  "userType": userType,
      "userName": userName,
	  "email": email,
	  "password": password,
    };

  } 
    User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

    toJson(){
      return {
	  'userId': userId,
	  'fullName': fullName,
	  'userType': userType,
	  'userName': userName,
	  'email': email,
	  'password': password
	  };
    }

  

  

}
