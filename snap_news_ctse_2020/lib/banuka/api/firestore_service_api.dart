// ====================================================================================
// IT17157124 - FireStore API
// This is the API that perform CRUD operations
// Reference: https://www.youtube.com/watch?v=-blxq_RLybQ
// ====================================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';


// firestore class to hold the API 
class FireStoreServiceApi {
  static final FireStoreServiceApi _fireStoreService =
      FireStoreServiceApi._internal();
  Firestore _db = Firestore.instance;

  FireStoreServiceApi._internal();

  factory FireStoreServiceApi() {
    return _fireStoreService;
  }

  // get the news from the firestore
  Stream<List<News>> getNews() {
    return _db.collection("news").orderBy("timestamp", descending: true).snapshots().map(
          (snapshot) => snapshot.documents
              .map((doc) => News.fromMap(doc.data, doc.documentID))
              .toList(),
        ) ;
  }

  // add a new news to the firestore
  Future<void> add_news(News news) {
    return _db.collection("news").add(news.toMap());
  }

  // update a selected news already in the firestore
  Future<void> update_news(News news){
    return _db.collection("news").document(news.id).updateData(news.toMap());
  }

  // delete a selected news in the firestore
  Future<void> delete_news(String id){
    return _db.collection("news").document(id).delete();
  }
}
