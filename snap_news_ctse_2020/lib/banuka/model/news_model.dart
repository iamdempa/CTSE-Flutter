
// IT17157124 - News model class 
class News {
  final String headline;
  final String description;
  final String imageUrl;
  final String timeNews;
  final String timeDate;
  final String priority;
  String id;
  String timestamp;
  

  // initiate the constructor 
  News({this.headline,this.description, this.imageUrl, this.timeNews, this.timeDate, this.priority, this.id, this.timestamp});


  // from map to save purposes of the data 
  News.fromMap(Map<String,dynamic> data, String id):
    headline=data['headline'], 
    description=data['description'], 
    imageUrl=data['imageUrl'],
    timeNews=data['timeNews'],
    timeDate=data['timeDate'],
    priority=data['priority'],
    id=id,
    timestamp=data["timestamp"];

  
  // to map to get the data 
  Map<String, dynamic> toMap(){
    return {
      "headline" : headline,
      "description": description,
      "imageUrl": imageUrl,
      "timeNews": timeNews,
      "timeDate": timeDate,
      "priority": priority,
      "id": id,
      "timestamp": timestamp
    };
  }
}