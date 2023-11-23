class Payment {
  String? title;
  String? phoneNumber;
  bool? isActive;

  Payment({this.title, this.phoneNumber, this.isActive});

  Payment.fromJson(Map<String, dynamic> json) {
    // if (json['isActive'] == false) return;
    title = json['title'];
    phoneNumber = json['phone_number'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['phone_number'] = this.phoneNumber;
    data['is_active'] = this.isActive;
    return data;
  }
}

class Receipt {
  String? image;
  String? phoneNumber;
  Payment? payment;

  Receipt({this.image, this.phoneNumber, this.payment});

  Receipt.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    phoneNumber = json['phone_number'];
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    return data;
  }
}
