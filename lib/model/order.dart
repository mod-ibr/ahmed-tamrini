import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? address;
  String? phoneNumber;
  String? notes;
  String? user;
  Product? product;
  GymData? gymData;
  String? status;
  Timestamp? createdAt;
  String? id;
  String? image;
  String? paymentMethod;

  Order(
      {this.address,
      this.phoneNumber,
      this.notes,
      this.user,
      this.product,
      this.gymData,
      this.status,
      this.createdAt,
      this.id,
      this.image,
      this.paymentMethod});

  Order.fromJson(Map<String, dynamic> json, String id) {
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    notes = json['notes'];
    user = json['user'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    gymData =
        json['gymData'] != null ? GymData.fromJson(json['gymData']) : null;
    status = json['status'];
    createdAt = json['createdAt'];
    image = json['image'];
    paymentMethod = json['paymentMethod'];
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['notes'] = notes;
    data['user'] = user;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (gymData != null) {
      data['gymData'] = gymData!.toJson();
    }
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['image'] = image;
    data['paymentMethod'] = paymentMethod;

    return data;
  }
}

class Product {
  String? title;
  int? price;
  int? quantity;

  Product({this.title, this.price, this.quantity});

  Product.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
}

class GymData {
  String? gymId, gymName, gymAssets, subscriberId;
  int? price;

  GymData(
      {this.gymId,
      this.gymName,
      this.gymAssets,
      this.subscriberId,
      this.price});

  GymData.fromJson(Map<String, dynamic> json) {
    gymId = json['gymId'];
    gymName = json['gymName'];
    gymAssets = json['gymAssets'];
    subscriberId = json['subscriberId'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gymId'] = gymId;
    data['gymName'] = gymName;
    data['gymAssets'] = gymAssets;
    data['price'] = price;
    data['subscriberId'] = subscriberId;

    return data;
  }
}
