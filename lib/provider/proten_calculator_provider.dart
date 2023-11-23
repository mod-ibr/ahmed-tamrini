import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Target { purpose, increaseWeight, loseWeight, maintainWeight }

enum ActivityLevel {
  // rate,
  light,
  moderate,
  very,
  extra
}

enum Gender { Male, Female }

class ProteinCalculatorProvider extends ChangeNotifier {
  double protein = 0.0;
  double fat = 0.0;
  double carbs = 0.0;
  double calories = 0.0;
  List<String> names = [
    tr('purpose_of_exercise'),
    // "الغرض من التمرين",
    tr('increase_in_weight'),
    // "زيادة في الوزن",
    tr('weight_loss'),
    // "خسارة الوزن",
    tr('maintain_weight'),
    // "الحفاظ على الوزن",
  ];
  List<String> activities = [
    // "معدل النشاط",
    tr('low_activity'),
    // "نشاط منخفض في العمل والنادي",
    tr('mid_activity'),
    // "نشاط معتدل في العمل والنادي",
    tr('high_activity'),
    // "نشاط عالي في العمل والنادي",
    tr('very_intense_activity'),
    // "نشاط مكثف جدا في العمل والنادي",
  ];

  // calculate(
  //     {required int weight,
  //     required int height,
  //     required int age,
  //     required bool isMale,
  //     required Target target}) {
  //   if (target == Target.increaseWeight) {
  //     calories = weight * 2 * 18;
  //     protein = calories * 0.4 / 4; // 40% of calories
  //     carbs = calories * 0.4 / 4; // 40% of calories
  //     fat = calories * 0.2 / 9; // 20% of calories
  //   } else if (target == Target.loseWeight) {
  //     calories = weight * 2.2 * 15;
  //     protein = calories * 0.4 / 4; // 40% of calories
  //     carbs = calories * 0.4 / 4; // 40% of calories
  //     fat = calories * 0.2 / 9; // 20% of calories
  //   } else if (target == Target.maintainWeight) {
  //     calories = weight * 2.2 * 15;
  //     protein = calories * 0.375 / 4; // 35% of calories
  //     carbs = calories * 0.375 / 4; // 35% of calories
  //     fat = calories * 0.25 / 9; // 25% of calories
  //   }
  //   notifyListeners();
  // }

  calculate({
    required int wight,
    required int height,
    required int age,
    required Gender sex,
    required Target target,
    required ActivityLevel activityLevel,
  }) {
    calories = Gender.Male == sex
        ? (10 * wight + 6.25 * height - 5 * age + 5)
        : (10 * wight + 6.25 * height - 5 * age - 161);

    switch (activityLevel) {
      case ActivityLevel.light:
        calories = (1.1 * calories);
        break;
      case ActivityLevel.moderate:
        calories = (1.3 * calories);
        break;
      case ActivityLevel.very:
        calories = (1.5 * calories);
        break;
      case ActivityLevel.extra:
        calories = (1.7 * calories);
        break;
      // case ActivityLevel.rate:
      //   break;
    }

    switch (target) {
      case Target.loseWeight:
        if (calories <= 2000) {
          calories = (0.9 * calories);
        } else {
          calories = (0.8 * calories);
        }
        protein = (0.4 * calories / 4);
        carbs = (0.4 * calories / 4);
        fat = (0.2 * calories / 9);
        break;
      case Target.maintainWeight:
        protein = (0.3 * calories / 4);
        carbs = (0.45 * calories / 4);
        fat = (0.25 * calories / 9);
        break;
      case Target.increaseWeight:
        calories += 500;
        protein = (0.3 * calories / 4);
        carbs = (0.45 * calories / 4);
        fat = (0.25 * calories / 9);
        break;
      case Target.purpose:
        break;
    }
    notifyListeners();
  }

  reset() {
    protein = 0.0;
    fat = 0.0;
    carbs = 0.0;
    calories = 0.0;
    notifyListeners();
  }
}
