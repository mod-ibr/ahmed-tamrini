import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  late Timestamp date;
  late String name;
  late List<Answers> answers;
  late String askerUsername;
  late String askerProfileImageUrl;
  late String body;
  late String title;
  late String id;
  late int answerCount;

  Question({
    required this.date,
    required this.name,
    required this.answers,
    required this.askerUsername,
    required this.askerProfileImageUrl,
    required this.body,
    required this.title,
  }) {
    askerProfileImageUrl = askerProfileImageUrl ?? "";
  }

  Question.fromJson(Map<String, dynamic> json, this.id) {
    date = json['date'];
    name = json['name'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers.add(Answers.fromJson(v));
      });
    }
    askerUsername = json['askerUsername'];
    askerProfileImageUrl = json['askerProfileImageUrl'] ?? "";
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['name'] = name;
    data['answers'] = answers.map((v) => v.toJson()).toList();
    data['askerUsername'] = askerUsername;
    data['askerProfileImageUrl'] = askerProfileImageUrl;
    data['body'] = body;
    data['title'] = title;
    return data;
  }
}

class Answers {
  Timestamp? date;
  String? answer;
  String? name;
  String? username;
  String? profileImageUrl;

  Answers({
    this.date,
    this.answer,
    this.name,
    this.username,
    String? profileImageUrl,
  }) {
    this.profileImageUrl = profileImageUrl ?? "";
  }

  Answers.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    answer = json['answer'];
    name = json['name'];
    username = json['username'];
    profileImageUrl = json["profileImageUrl"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['answer'] = answer;
    data['name'] = name;
    data['username'] = username;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}
