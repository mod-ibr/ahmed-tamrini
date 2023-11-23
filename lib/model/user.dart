class User {
  String name;
  String email;
  String phone;
  String username;
  String password;
  String token;
  String role;
  String uid;
  String gender;
  int age;
  String profileImgUrl;
  bool isSubscribedToTrainer = false;
  bool isBanned = false;
  bool isVerifiedPhoneNumber = false;
  bool notification = false;
  List notifications = [];
  bool isVerifiedEmail = false;
  String pendingEmail = "";
  //! Trainer Data
  String? description;
  int? price;
  List<String>? contacts;
  int? traineesCount;
  List<String>? questions;
  List<String>? gallery;
  List<String>? gymImage;
  //! Gym Data
  String? gymId;
  //! Publisher Data
  bool? isPublisher;
  String? publisherSummary;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.token,
    required this.role,
    required this.uid,
    required this.gender,
    required this.age,
    required this.profileImgUrl,
    required this.isSubscribedToTrainer,
    required this.isBanned,
    required this.isVerifiedPhoneNumber,
    required this.notification,
    required this.notifications,
    required this.isVerifiedEmail,
    required this.pendingEmail,
    //! Trainer Data
    this.description,
    this.contacts,
    this.price,
    this.traineesCount,
    this.questions,
    this.gallery,
    this.gymImage,
    //! Gym Data
    this.gymId,
    //! Publisher Data
    this.isPublisher,
    this.publisherSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'username': username,
      'phone': phone,
      'token': token,
      'password': password,
      'role': role,
      'gender': gender,
      'age': age,
      'profileImgurl': profileImgUrl,
      'isSubscribedToTrainer': isSubscribedToTrainer,
      'isBanned': isBanned,
      'isVerifiedPhoneNumber': isVerifiedPhoneNumber,
      'notification': notification,
      'notifications': notifications,
      //! Trainer Data

      'achievements': description ?? "",
      'contacts': contacts ?? [] as List<String>,
      'price': price ?? 0,
      'traineesCount': traineesCount ?? 0,
      'questions': questions ?? [] as List<String>,
      'gallery': gallery ?? [] as List<String>,
      'gymImage': gymImage ?? [] as List<String>,
      //! Gym Data
      'gymId': gymId ?? "",
      //! Publisher Data
      'isPublisher': isPublisher ?? false,
      'publisherSummary': publisherSummary ?? "",
    };
  }

  factory User.fromMap(Map<String, dynamic> map, id) {
    return User(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      username: map['username'],
      password: map['password'],
      token: map['token'],
      role: map['role'],
      gender: map['gender'],
      uid: id,
      age: map['age'],
      profileImgUrl: map['profileImgurl'] ?? "",
      isSubscribedToTrainer: map['isSubscribedToTrainer'],
      isBanned: map['isBanned'],
      isVerifiedPhoneNumber: map['isVerifiedPhoneNumber'],
      notification:
          map.containsKey('notification') ? map['notification'] : false,
      notifications:
          map.containsKey('notifications') ? map['notifications'] : [],
      isVerifiedEmail: map['isVerifiedEmail'] ?? false,
      pendingEmail: map['pendingEmail'] ?? "",
      //! Trainer Data
      description: (map['achievements'] != null &&
              map['achievements'].toString().isNotEmpty)
          ? map['achievements']
          : "",
      contacts: (map['contacts'] != null && map['contacts'] is List<dynamic>)
          ? List<String>.from(map['contacts'])
          : [],
      price: map['price'] ?? 0,
      traineesCount: map['traineesCount'] ?? 0,
      questions: (map['questions'] != null && map['questions'] is List<dynamic>)
          ? List<String>.from(map['questions'])
          : [],
      gallery: (map['gallery'] != null && map['gallery'] is List<dynamic>)
          ? List<String>.from(map['gallery'])
          : [],
      gymImage: (map['gymImage'] != null && map['gymImage'] is List<dynamic>)
          ? List<String>.from(map['gymImage'])
          : [],
      //! Gym Data
      gymId: (map['gymId'] != null && map['gymId'].toString().isNotEmpty)
          ? map['gymId']
          : "",
      //! Publisher Data
      isPublisher: (map['isPublisher'] != null) ? map['isPublisher'] : false,
      publisherSummary: (map['publisherSummary'] != null &&
              map['publisherSummary'].toString().isNotEmpty)
          ? map['publisherSummary']
          : "",
    );
  }

  User copyWith({bool? isEmail, String? email, String? pendingEmail}) {
    return User(
        name: name,
        email: email ?? this.email,
        phone: phone,
        username: username,
        password: password,
        token: token,
        role: role,
        uid: uid,
        gender: gender,
        age: age,
        profileImgUrl: profileImgUrl,
        isSubscribedToTrainer: isSubscribedToTrainer,
        isBanned: isBanned,
        isVerifiedPhoneNumber: isVerifiedPhoneNumber,
        notification: notification,
        notifications: notifications,
        isVerifiedEmail: isEmail ?? isVerifiedEmail,
        pendingEmail: pendingEmail ?? this.pendingEmail);
  }
}
