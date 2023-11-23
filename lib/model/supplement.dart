class Supplement {
  String? image;
  List<SupplementData>? data;
  String? title;
  String? id;

  Supplement({this.image, this.data, this.title, required this.id});

  Supplement.fromJson(Map<String, dynamic> json, String id) {
    image = json['image'];
    if (json['data'] != null) {
      data = <SupplementData>[];
      json['data'].forEach((v) {
        data!.add(SupplementData.fromJson(v));
      });
    }
    title = json['title'];
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    return data;
  }
}

class SupplementData {
  List<String>? images;
  String? description;
  String? title;
  String? id;

  SupplementData({this.images, this.description, this.title, required this.id});

  SupplementData.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    description = json['description'];
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['description'] = this.description;
    data['title'] = this.title;
    data['id'] = this.id;
    return data;
  }
}
