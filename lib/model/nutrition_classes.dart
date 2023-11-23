class NutritionClasses {
  String classification;

  String id;

  NutritionClasses({
    required this.classification,
    required this.id,
  });

  NutritionClasses.fromJson(Map<String, dynamic> json)
      : classification = json['classification'],
        id = json['id'];

  Map<String, dynamic> toJson() => {'classification': classification, 'id': id};
}
