

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';


class FireStoreService {
  static final FireStoreService _fireStoreService = FireStoreService._internal();
  Firestore _db = Firestore.instance;

  FireStoreService._internal();

  factory FireStoreService() {
    return _fireStoreService;
  }
  
  // get the news 
  Stream<List<News>> getNews(){
    return _db.collection("news") 
      .snapshots()
      .map((snapshot) => snapshot.documents.map((doc) => News.fromMap(doc.data, doc.documentID)).toList(),);
  }
}