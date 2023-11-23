import 'package:cloud_firestore/cloud_firestore.dart';

class DietFood {
  late List<String> assets;
  late String description;
  late String title;
  late String id;
  late Timestamp? date;
  late String? writer;

  DietFood(
      {required this.assets,
      required this.description,
      required this.title,
      required this.date,
      required this.writer,
      required this.id});

  factory DietFood.fromJson(Map<String, dynamic> json, String id) {
    return DietFood(
      assets: json['assets'].cast<String>(),
      description: json['description'],
      title: json['title'],
      date: json['date'],
      id: id,
      writer: json['writer'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['assets'] = assets;
    data['description'] = description;
    data['title'] = title;
    data['date'] = date;

    data['writer'] = writer;

    return data;
  }
}
