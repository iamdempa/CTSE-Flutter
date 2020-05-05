import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user.dart';
import '../Model/news.dart';
import '../Model/approvedNews.dart';

class FirestoreService {
  static final FirestoreService _firestoreService = FirestoreService._internal();
  final String userCollection = 'users';
  final String newsCollection = 'news';
  final String apprNewsCollection = 'approvedNews';
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
          await _db.collection(userCollection).document().setData(user.toJson());          
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET methods
  getUsers(){
    return _db.collection(userCollection).snapshots();
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


  /*SignUpService methods
  */
  //PUT METHODS
  Future<String> signUp(User user) async{
    final isesixt = await isUserExists(user.email);

    if(isesixt){      
      return "EXISTS";
    }
    else{
      addUser(user); 
      return "CREATED"; 
    }

  }

  //GET METHODS
  isUserExists(String email) async{
    final QuerySnapshot result = await _db.collection(userCollection).where('email', isEqualTo: email).limit(1).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    
    if (documents.length == 1){
      return true;
    }else{
      return false;
    }
  } 
  
  
  signIn(String email, String password) async{
    final QuerySnapshot result = await _db.collection(userCollection).where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
        
    if (documents.length == 1){
      User usr =User.fromSnapshot(documents[0]);
      return usr;
    }else{
      return null;
    }    
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
  
  
  getNewsByNewsHeadline(String newsHeadline){
    return _db.collection(newsCollection).where('headline', isEqualTo: newsHeadline).snapshots();
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

  /*ApprovedNewsService methods
  */
  //POST METHODS
  addApprovedNews(ApprovedNews approvedNews){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await _db.collection(apprNewsCollection).document().setData(approvedNews.toJson());
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET METHODS
  getApprovedNews(){
    return _db.collection(apprNewsCollection).snapshots();
  }
  
  //UPDATE methods
  updateApprovedNews(ApprovedNews existingApprovedNews, ApprovedNews newApprovedNews){
    try{
      _db.runTransaction(
        (Transaction transaction) async {
          await transaction.update(existingApprovedNews.reference, newApprovedNews.toMap()); 
        }
      );
    }catch(e){
      print(e.toString());
    }
  }

  //DELETE methods
  deleteApprovedNews(ApprovedNews apprNews){
    _db.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(apprNews.reference);
      }
    );
  }
 	
}