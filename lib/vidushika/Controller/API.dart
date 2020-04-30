import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user.dart';
import '../Model/news.dart';

class FirestoreService {
  static final FirestoreService _firestoreService = FirestoreService._internal();
  final String collectionName = 'users';
  final String newsCollection = 'news';
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService(){
    return _firestoreService;
  }

  /* User service methods
	*/
  //POST methods
  addUser(User user){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await _db.collection(collectionName).document().setData(user.toJson());
          //await _db.collection(collectionName).add(user.toJson());
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET methods
  getUsers(){
    return _db.collection(collectionName).snapshots();
  }

  //UPDATE methods
  update(User user, String newName){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await transaction.update(user.reference, {'userName': newName}); 
        }
      );
    }catch(e){
      print(e.toString());
    }
  } 

  //DELETE methods
  delete(User user){
    _db.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(user.reference);
      }
    );
  } 

  
  /* News service methods
	*/

  //POST methods
  addNews(News news){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await _db.collection(newsCollection).document().setData(news.toJson());
          
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET methods
  getNews(){
    return _db.collection(newsCollection).snapshots();
  }

  //UPDATE methods
  updateNews(News existingNews, News newNews){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await transaction.update(existingNews.reference, newNews.toMap()); 
        }
      );
    }catch(e){
      print(e.toString());
    }
  }

  //DELETE methods
  deleteNews(News news){
    _db.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(news.reference);
      }
    );
  } 
 	
}