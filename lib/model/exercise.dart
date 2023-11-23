import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? image;
  List<ExerciseData>? data = [];
  String? title;
  int? order;
  late String id;

  Exercise({
    this.image,
    this.data,
    this.title,
    required this.id,
    this.order,
  });

  Exercise.fromJson(Map<String, dynamic> json, String id) {
    image = json['image'];
    if (json['data'] != null) {
      data = <ExerciseData>[];
      json['data'].forEach((v) {
        data!.add(new ExerciseData.fromJson(v));
      });
    }
    title = json['title'];
    order = json['order'] ?? 99;
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['order'] = order ?? 99;
    return data;
  }
}

class ExerciseData {
  List<String>? assets;
  String? description;
  String? title;
  String? id;
  Timestamp? createdAt;
  String? notes;
  String? duration;

  ExerciseData({
    this.assets,
    this.description,
    this.title,
    required this.id,
    this.createdAt,
    this.notes,
    this.duration,
  });

  ExerciseData.fromJson(Map<String, dynamic> json) {
    assets = json['image'].cast<String>();
    description = json['description'];
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.assets;
    data['description'] = this.description;
    data['title'] = this.title;
    data['id'] = this.id;
    return data;
  }
}
