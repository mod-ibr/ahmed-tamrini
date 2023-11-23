// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tamrini/model/exercise.dart';

class TraineeExercise {
  ExerciseData? exercise;
  int? setsNo;
  int? repeatNo;
  ExerciseData? superSetExercise;
  TraineeExercise({
    required this.exercise,
    required this.setsNo,
    required this.repeatNo,
    this.superSetExercise,
  });

  TraineeExercise.fromJson(
      Map<String, dynamic> json, List<ExerciseData> allExercises) {
    if (json['exercise'] != null) {
      exercise =
          allExercises.firstWhere((element) => element.id == json['exercise']);
    }
    setsNo = json['setsNo'];
    repeatNo = json['repeatNo'];
    if (json['superSetExercise'] != null) {
      superSetExercise = allExercises
          .firstWhere((element) => element.id == json['superSetExercise']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['exercise'] = exercise?.id;
    data['setsNo'] = setsNo;
    data['repeatNo'] = repeatNo;
    data['superSetExercise'] = superSetExercise?.id;
    return data;
  }
}
