import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? address;
  String? phoneNumber;
  String? notes;
  String? user;
  Product? product;
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
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    status = json['status'];
    createdAt = json['createdAt'];
    image = json['image'];
    paymentMethod = json['paymentMethod'];
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['notes'] = this.notes;
    data['user'] = this.user;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['image'] = this.image;
    data['paymentMethod'] = this.paymentMethod;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}
