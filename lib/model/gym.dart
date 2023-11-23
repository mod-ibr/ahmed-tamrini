import 'package:cloud_firestore/cloud_firestore.dart';

class Gym {
  List<String> assets;
  String name;
  String gymOwnerId;
  GeoPoint location;
  int price;
  String id;
  String description;
  double distance;
  bool isPendingGym;

  Gym({
    required this.assets,
    required this.name,
    required this.location,
    required this.price,
    required this.id,
    required this.description,
    required this.distance,
    required this.gymOwnerId,
    required this.isPendingGym,
  });

  factory Gym.fromJson(Map<String, dynamic> json, String id, double distance) {
    return Gym(
      assets: List<String>.from(json['assets']),
      name: json['name'],
      gymOwnerId: json['gymOwnerId'] ?? "",
      location: json['location'],
      price: json['price'],
      id: id,
      description: json['description'],
      distance: distance,
      isPendingGym: json['isPendingGym'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assets': assets,
      'name': name,
      'gymOwnerId': gymOwnerId,
      'location': location,
      'price': price,
      'description': description,
      'isPendingGym': isPendingGym,
    };
  }
}
