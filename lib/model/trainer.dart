// import 'package:flutter/cupertino.dart';

// class Trainer {
//   String? name;
//   String? image;
//   String? description;
//   String? gender;
//   int? price;
//   List<String>? contacts;
//   int? traineesCount;
//   String? uid;
//   List<String>? questions;
//   List<dynamic>? gallery;

//   Trainer({
//     this.name,
//     this.image =
//         "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
//     this.description,
//     this.contacts,
//     this.uid,
//     this.price,
//     this.traineesCount,
//     this.gender,
//     this.questions,
//     this.gallery,
//   });

//   Trainer.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     if (json['image'] == null || json['image'] == "") {
//       image =
//           "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
//     } else {
//       image = json['image'];
//     }
//     description = json['achievements'];
//     contacts = json['contacts'].cast<String>();

//     price = json['price'];
//     gender = json['gender'];
//     traineesCount = json['traineesCount'];
//     uid = json['uid'];
//     questions = json['questions'].cast<String>();

//     debugPrint('gallery: ${json['gallery']}');

//     // if (json['gallery'] != null && json['gallery']?.isNotEmpty) {
//     //   gallery = json['gallery']?.map((galleryItem) => TrainerGalleryItem.fromJson(galleryItem)).toList();
//     // }
//     gallery = json['gallery'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['image'] = image;
//     data['achievements'] = description;
//     data['contacts'] = contacts;

//     data['uid'] = uid;
//     data['price'] = price;
//     data['gender'] = gender;
//     data['traineesCount'] = traineesCount;
//     data['questions'] = questions;
//     data['gallery'] = gallery;
//     return data;
//   }
// }
