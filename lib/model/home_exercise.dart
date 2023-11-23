import 'package:flutter/material.dart';

class HomeExercise {
  String? image;
  List<Data>? data;
  String? title;
  String? id;
  int? order;

  HomeExercise(
      {this.image, this.data, this.title, required this.id, this.order});

  HomeExercise.fromJson(Map<String, dynamic> json, String this.id) {
    image = json['image'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    title = json['title'];
    order = json['order'] ?? 99;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['order'] = order ?? 99;
    return data;
  }
}

class Data {
  List<String>? assets;
  String? description;
  String? title;
  String? id;

  Data({
    this.assets,
    this.description,
    this.title,
    required this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    assets = json['image'].cast<String>();
    description = json['description'];
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = assets;
    data['description'] = description;
    data['title'] = title;
    data['id'] = id;
    return data;
  }

  print() {
    debugPrint('id: $id, title: $title, assets: $assets\n\n');
  }
}
