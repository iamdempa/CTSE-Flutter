class News {
  final String headline;
  final String description;
  final String id;
  

  News({this.headline, this.id, this.description});

  News.fromMap(Map<String,dynamic> data, String id):
    headline=data['headline'], id=data['id'], description=data['description'];

  Map<String, dynamic> toMap(){
    return {
      "headline" : headline,
      "id": id,
      "description": description
    };
  }
}