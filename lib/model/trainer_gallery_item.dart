import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerGalleryItem {
  String? before;
  String? after;
  Timestamp? createdAt;

  TrainerGalleryItem({
    required this.before,
    required this.after,
    this.createdAt,
  });

  TrainerGalleryItem.fromJson(Map<String, dynamic> json) {
    before = json['before'];
    after = json['after'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['before'] = before;
    data['after'] = after;
    data['createdAt'] = createdAt;
    return data;
  }
}
