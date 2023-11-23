class Nutritious {
  final String classification;
  final String title;
  final double calories;
  final double proteins;
  final double fats;
  final double carbs;
  String id;

  Nutritious({
    required this.title,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.classification,
    required this.id,
  });

  Nutritious.fromJson(
    Map<String, dynamic> json,
    ID,
  )   : title = json['title'],
        calories = json['calories'],
        proteins = json['proteins'],
        fats = json['fats'],
        carbs = json['carbs'],
        classification = json['classification'],
        id = ID;

  Map<String, dynamic> toJson() => {
        'title': title,
        'calories': calories,
        'proteins': proteins,
        'fats': fats,
        'carbs': carbs,
        'classification': classification,
      };
}
