import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/model/supplement.dart' as supplement;
import 'package:tamrini/model/trainee_exercise.dart';

class Trainee {
  String? name;
  String? number;
  String? username;
  Timestamp? dateOfSubscription;
  List<Course>? courses = [];
  List<supplement.SupplementData>? supplements = [];
  String? uid;
  String? trainerId;
  List<Food>? food = [];
  int? age;
  String? gender;

  List<ExerciseData>? allExercises = [];
  List<FollowUpData>? followUpList = [];

  Trainee({
    this.name,
    this.number,
    this.username,
    this.dateOfSubscription,
    this.courses,
    this.uid,
    this.trainerId,
    this.food,
    this.age,
    this.gender,
    this.allExercises,
    this.followUpList,
    this.supplements,
  });

  Trainee.fromJson(Map<String, dynamic> json, List<ExerciseData> allExercises,
      List<supplement.SupplementData> allSupplements) {
    name = json['name'];
    number = json['phone'];
    username = json['username'];
    dateOfSubscription = json['dateOfSubscription'];
    age = json['age'];
    gender = json['gender'];
    uid = json['uid'];
    trainerId = json['trainerID'] ?? "";
    if (json['food'] != null) {
      food = <Food>[];
      json['food'].forEach((v) {
        food!.add(Food.fromJson(v));
      });
    } else {
      food = <Food>[];
    }

    if (json['courses'] != null) {
      courses = <Course>[];
      json['courses'].forEach((v) {
        courses!.add(Course.fromJson(v, allExercises));
      });
    } else {
      courses = <Course>[];
    }
    if (json['followUpList'] != null) {
      followUpList = <FollowUpData>[];
      json['followUpList'].cast<Map>().forEach((v) {
        followUpList!.add(FollowUpData.fromJson(v));
      });
    } else {
      followUpList = <FollowUpData>[];
    }

    if (json['supplements'] != null) {
      supplements = <supplement.SupplementData>[];
      json['supplements'].forEach((supplement) {
        supplements!
            .add(allSupplements.firstWhere((sup) => sup.id == supplement));
      });
    } else {
      supplements = <supplement.SupplementData>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.number;
    data['username'] = this.username;
    data['dateOfSubscription'] = this.dateOfSubscription;
    data['uid'] = this.uid;
    data['trainerID'] = this.trainerId;
    data['food'] = this.food?.map((v) => v.toJson()).toList();
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['courses'] = this.courses?.map((v) => v.toJson()).toList();
    data['followUpList'] = this.followUpList?.map((v) => v.toJson()).toList();
    data['supplements'] = supplements?.map((v) => v.id).toList();

    return data;
  }
}

class Course {
  DayWeekExercises? dayWeekExercises;
  String? duration;
  String? notes;
  String? title;
  Timestamp? createdAt;

  Course(
      {this.dayWeekExercises,
      this.duration,
      this.notes,
      this.title,
      this.createdAt});

  Course.fromJson(Map<String, dynamic> json, List<ExerciseData> allExercises) {
    dayWeekExercises = json['dayWeekExercises'] != null
        ? DayWeekExercises.fromJson(json['dayWeekExercises'], allExercises)
        : null;
    duration = json['duration'];
    notes = json['notes'];
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dayWeekExercises != null) {
      data['dayWeekExercises'] = this.dayWeekExercises?.toJson();
    }
    data['duration'] = this.duration;
    data['notes'] = this.notes;
    data['title'] = this.title;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class DayWeekExercises {
  List<TraineeExercise>? sat = [];
  List<TraineeExercise>? sun = [];
  List<TraineeExercise>? mon = [];
  List<TraineeExercise>? tue = [];
  List<TraineeExercise>? wed = [];
  List<TraineeExercise>? thurs = [];
  List<TraineeExercise>? fri = [];

  DayWeekExercises(
      {this.sat, this.sun, this.mon, this.tue, this.wed, this.thurs, this.fri});

  DayWeekExercises.fromJson(
      Map<String, dynamic> json, List<ExerciseData> allExercises) {
    try {} catch (e) {}
    sat = json['sat'] != null
        ? (json['sat'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    sun = json['sun'] != null
        ? (json['sun'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    mon = json['mon'] != null
        ? (json['mon'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    tue = json['tue'] != null
        ? (json['tue'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    wed = json['wed'] != null
        ? (json['wed'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    thurs = json['thurs'] != null
        ? (json['thurs'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
    fri = json['fri'] != null
        ? (json['fri'] as List)
            .map((i) => TraineeExercise.fromJson(i, allExercises))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sat'] = this.sat?.map((e) => e.toJson()).toList();
    data['sun'] = this.sun?.map((e) => e.toJson()).toList();
    data['mon'] = this.mon?.map((e) => e.toJson()).toList();
    data['tue'] = this.tue?.map((e) => e.toJson()).toList();
    data['wed'] = this.wed?.map((e) => e.toJson()).toList();
    data['thurs'] = this.thurs?.map((e) => e.toJson()).toList();
    data['fri'] = this.fri?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Food {
  String? duration;
  String? foodData;
  String? title;
  Timestamp? createdAt;

  Food({this.duration, this.foodData, this.title, this.createdAt});

  Food.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    foodData = json['foodData'];
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['foodData'] = this.foodData;
    data['title'] = this.title;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class FollowUpData {
  Timestamp? createdAt;
  List<Map>? followUpData;
  List<String>? images;

  FollowUpData({this.images, this.createdAt, this.followUpData});

  FollowUpData.fromJson(Map<String, dynamic> json) {
    images = json['images'] != null ? json['images'].cast<String>() : [];
    createdAt = json['createdAt'];
    followUpData = json['followUpData'].cast<Map>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['followUpData'] = this.followUpData;

    data['images'] = this.images;
    return data;
  }
}
