import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  late Timestamp? date;
  late List<String>? image;
  late String? writer;
  late String? body;
  late String? title;
  late String? id;

  Article(
      {required this.date,
      required this.image,
      required this.writer,
      required this.body,
      required this.id,
      required this.title});

  factory Article.fromJson(Map<String, dynamic> data, String id) {
    return Article(
      date: data['date'],
      id: id,
      image: data['image'].cast<String>(),
      writer: data['writer'],
      body: data['body'],
      title: data['title'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['date'] = date;
    data['image'] = image;
    data['writer'] = writer;
    data['body'] = body;
    data['title'] = title;
    return data;
  }
}
