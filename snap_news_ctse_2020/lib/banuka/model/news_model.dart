class News {
  final String headline;
  final String id;
  

  News({this.headline, this.id});

  News.fromMap(Map<String,dynamic> data, String id):
    headline=data['headline'], id=data['id'];

  Map<String, dynamic> toMap(){
    return {
      "headline" : headline,
      "id": id,
    };
  }
}