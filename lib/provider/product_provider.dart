import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/model/product.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/products_screens/products_screens.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/order.dart' as ord;
import '../model/payment.dart';
import '../model/user.dart';
import '../utils/helper_functions.dart';
import 'Upload_Image_provider.dart';
import 'gym_provider.dart';

enum PaymentMethod { cashOnDelivery, moneyTransfer }

class ProductProvider with ChangeNotifier {
  List<Product> products = [], _OriginalProducts = [];
  Product allProducts = Product(data: [], id: ''),
      _OriginalAllProducts = Product(data: [], id: '');
  String? selectedSortBy;
  List<Data> selectedProductCat = [], _selectedProductCat = [];
  UserProvider userProvider = UserProvider();
  List<Payment> digitalPaymentMethods = [];
  List<ord.Order> orders = [];
  TextEditingController searchController = TextEditingController();

  initiate(UserProvider userProvider) {
    this.userProvider = userProvider;
    fetchAndSetProducts();
  }

  bool isLoading = false;

  changeSelectedSortBy(String? query) {
    selectedSortBy = query;
    print('selectedSortBy $selectedSortBy');
    List sortBy = [
      tr('lowest_price'),
      // 'الأقل سعراً',
      tr('highest_price'),
      // 'الأعلى سعراً',
    ];
    int index = sortBy.indexWhere((element) => element == query);
    index = index == -1 ? 0 : index;
    switch (index) {
      case 1:
        // case 'الأعلى سعراً':
        selectedProductCat.sort((a, b) => b.price!.compareTo(a.price!));
        break;
      case 0:
        // case 'الأقل سعراً':
        selectedProductCat.sort((a, b) => a.price!.compareTo(b.price!));
        break;
      default:
        // sortByDistance();
        selectedProductCat.sort((a, b) => a.price!.compareTo(b.price!));
        break;
    }
    notifyListeners();
  }

  chooseProductCat(Product product, bool isAll) {
    if (!isAll) {
      selectedProductCat =
          products.where((element) => product.id == element.id).first.data!;
      notifyListeners();
    } else {
      selectedProductCat = allProducts.data!;
      notifyListeners();
    }
    ;
    To(ProductsScreen(
      product: product,
      isAll: isAll,
    ));
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        products = event.docs
            .map(
                (e) => Product.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        print('products fetched ${products.length}');
        notifyListeners();
        _OriginalProducts = products;

        allProducts.data = [];
        for (var element in products) {
          allProducts.data!.addAll(element.data!);
        }
        _OriginalAllProducts = allProducts;
        // print('allProducts fetched ${allProducts.data.length}');
        isLoading = false;
        notifyListeners();
      });

      // pop();
    } catch (error) {
      isLoading = false;
      print(error);
      //TODO show error screen
    }
  }

  fetchAndSetPaymentMethods() {
    try {
      isLoading = true;
      Dio()
          .get(
              'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/payment/.json')
          .then((value) {
        digitalPaymentMethods = (value.data as List)
            .map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList();

        notifyListeners();
        print(
            'digitalPaymentMethods fetched ${digitalPaymentMethods[0].title}');
      });
      isLoading = false;
    } catch (error) {
      isLoading = false;
      print(error);
    }
  }

  addPaymentMethod(Payment payment) async {
    try {
      payment.isActive = false;
      digitalPaymentMethods.add(payment);

      await Dio().put(
          'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/payment/.json',
          data: [
            ...digitalPaymentMethods.map((e) => e.toJson()).toList(),
          ]);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('added_payment_method'),
        btnOkOnPress: () {},
      ).show();

      notifyListeners();
    } catch (error) {
      digitalPaymentMethods.remove(payment);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_adding_new_payment'),
        btnOkOnPress: () {},
      ).show();
      print(error);
    }
  }

  deletePaymentMethod(Payment payment) async {
    try {
      digitalPaymentMethods.removeWhere((element) =>
          element.phoneNumber == payment.phoneNumber &&
          element.title == payment.title);

      await Dio().put(
          'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/payment/.json',
          data: [
            ...digitalPaymentMethods.map((e) => e.toJson()).toList(),
          ]);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('removed_payment_method'),
        btnOkOnPress: () {},
      ).show();

      notifyListeners();
    } catch (error) {
      digitalPaymentMethods.add(payment);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('error_while_adding_payment'),
        btnOkOnPress: () {},
      ).show();
      print(error);
    }
  }

  updatePaymentMethod(Payment payment) async {
    var data = digitalPaymentMethods
        .firstWhere((element) =>
            element.title == payment.title &&
            element.phoneNumber == payment.phoneNumber)
        .isActive;

    try {
      digitalPaymentMethods
          .firstWhere((element) =>
              element.title == payment.title &&
              element.phoneNumber == payment.phoneNumber)
          .isActive = payment.isActive;

      await Dio().put(
          'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/payment/.json',
          data: [
            ...digitalPaymentMethods.map((e) => e.toJson()).toList(),
          ]).then((value) {
        log(payment.toJson().toString());
        if (value.statusCode == 200) {
          notifyListeners();

          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('accomplished_successfully'),
            desc: tr('modified_payment'),
            btnOkOnPress: () {},
          ).show();
        } else {
          digitalPaymentMethods
              .firstWhere((element) =>
                  element.title == payment.title &&
                  element.phoneNumber == payment.phoneNumber)
              .isActive = data;

          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: tr('wrong'),
            desc: tr('modified_payment'),
            btnOkOnPress: () {},
          ).show();
        }
      });
    } catch (error) {
      digitalPaymentMethods
          .firstWhere((element) =>
              element.title == payment.title &&
              element.phoneNumber == payment.phoneNumber)
          .isActive = data;

      print(error);
    }
  }

  search(Product product) {
    print("Search" + searchController.text);
    if (searchController.text.isEmpty ||
        searchController.text == "" ||
        searchController.text == " ") {
      selectedProductCat =
          _OriginalProducts.where((element) => element.id == product.id)
              .first
              .data!;
      notifyListeners();
      return;
    }
    selectedProductCat =
        _OriginalProducts.where((element) => element.id == product.id)
            .first
            .data!
            .where(
              (element) => HelperFunctions.matchesSearch(
                searchController.text.toLowerCase().split(" "),
                element.title!,
              ),
            )
            .toList();
    notifyListeners();
  }

  searchAll() {
    print("Search" + searchController.text);
    if (searchController.text.isEmpty ||
        searchController.text == "" ||
        searchController.text == " ") {
      selectedProductCat = _OriginalAllProducts.data!;
      notifyListeners();
      return;
    }
    selectedProductCat = _OriginalAllProducts.data!
        .where(
          (element) => HelperFunctions.matchesSearch(
            searchController.text.toLowerCase().split(" "),
            element.title!,
          ),
        )
        .toList();
    notifyListeners();
  }

  clearSearch() {
    searchController.clear();
    selectedProductCat = _OriginalAllProducts.data!;
  }

  Future<void> addCategory(
      {required String title, required String image}) async {
    try {
      FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .add({
        'title': title,
        'image': image,
        'data': [],
      }).then((value) {
        products.add(Product(
          title: title,
          image: image,
          data: [],
          id: value.id,
        ));
        notifyListeners();
        _OriginalProducts = products;
        pop();
      });
    } catch (error) {
      print(error);
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_adding_section'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> addProduct(
      {required String title,
      required List<String> images,
      required int price,
      required String description,
      required Product category,
      required bool isAvailable}) async {
    try {
      var id = category.id! + DateTime.now().millisecondsSinceEpoch.toString();

      FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        'data': FieldValue.arrayUnion([
          {
            'title': title,
            'image': images,
            'price': price,
            'description': description,
            'available': isAvailable,
            'id': id
          }
        ])
      });

      products
          .where((element) => element.id == category.id)
          .first
          .data!
          .add(Data(
            title: title,
            assets: images,
            price: price,
            description: description,
            available: isAvailable,
            id: id,
          ));
      allProducts.data!.add(Data(
        title: title,
        assets: images,
        price: price,
        description: description,
        available: isAvailable,
        id: id,
      ));
      pop();

      notifyListeners();
      _OriginalProducts = products;
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteCategory({required String id}) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .doc(id)
          .delete();

      await FirebaseStorage.instance
          .ref(products
              .where((element) => element.id == id)
              .first
              .image!
              .split('tamrini-app.appspot.com/')[1])
          .delete();

      products
          .where((element) => element.id == id)
          .first
          .data!
          .forEach((element) async {
        await UploadProvider().deleteAllAssets(element.assets!);
      });

      products.removeWhere((element) => element.id == id);
      allProducts.data = [];
      for (var element in products) {
        allProducts.data!.addAll(element.data!);
      }

      notifyListeners();
      _OriginalProducts = products;
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteProduct(
      {required Data product, required Product category}) async {
    try {
      products
          .where((element) => element.id == category.id)
          .first
          .data!
          .removeWhere((element) => element.id == product.id);

      await FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        'data': products
            .where((element) => element.id == category.id)
            .first
            .data!
            .map((e) => e.toJson())
            .toList()
      });

      var data = products
          .where((element) => category.id == element.id)
          .first
          .data!
          .where((element) => element.id == product.id)
          .first
          .assets!;

      data.forEach((element) async {
        await FirebaseStorage.instance
            .ref(element.split('tamrini-app.appspot.com/')[1])
            .delete();
      });

      allProducts.data!.removeWhere((element) => element.id == product.id);

      notifyListeners();
      _OriginalProducts = products;
    } catch (error) {
      print(error);
    }
  }

  Future<void> editCategory(
      {required String title,
      required String image,
      required String id}) async {
    try {
      var data = products.where((element) => element.id == id).first.image!;
      await FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .doc(id)
          .update({
        'title': title,
        'image': image,
      }).then((value) async {
        if (data != image) {
          await UploadProvider().deleteAllAssets([data]);
        }
        products.where((element) => element.id == id).first.title = title;
        products.where((element) => element.id == id).first.image = image;
        _OriginalProducts = products;
      });
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('modified_successfully'),
        desc: tr('section_modified_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();

      _OriginalProducts = products;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> editProduct(
      {required String title,
      required List<String> images,
      required int price,
      required String description,
      required Product category,
      required bool isAvailable,
      required Data oldProduct}) async {
    showLoaderDialog(navigationKey.currentContext!);

    var oldImages = oldProduct.assets!;

    products
        .where((element) => element.id == category.id)
        .first
        .data!
        .removeWhere((element) => element.id == oldProduct.id);

    products.where((element) => element.id == category.id).first.data!.add(Data(
          title: title,
          assets: images,
          price: price,
          description: description,
          available: isAvailable,
          id: oldProduct.id,
        ));

    try {
      FirebaseFirestore.instance
          .collection('products')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        'data': products
            .where((element) => element.id == category.id)
            .first
            .data!
            .map((e) => e.toJson())
            .toList()
      }).then((value) async {
        await UploadProvider()
            .deleteOldImages(oldImages: oldImages, newImages: images);

        products
            .where((element) => element.id == category.id)
            .first
            .data!
            .removeWhere((element) => element.id == oldProduct.id);

        products
            .where((element) => element.id == category.id)
            .first
            .data!
            .add(Data(
              title: title,
              assets: images,
              price: price,
              description: description,
              available: isAvailable,
              id: oldProduct.id,
            ));
        allProducts.data!.removeWhere((element) => element.id == oldProduct.id);
        allProducts.data!.add(Data(
          title: title,
          assets: images,
          price: price,
          description: description,
          available: isAvailable,
          id: oldProduct.id,
        ));

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('modified_successfully'),
          desc: tr('modified_product'),
          btnOkOnPress: () {},
        ).show().then((value) {
          pop();
          pop();
          pop();
        });
        notifyListeners();
        _OriginalProducts = products;
      });
    } catch (error) {
      print(error);
    }
  }

  buyProduct({
    required String address,
    required String notes,
    required Data product,
    required int quantity,
    String? image,
    required PaymentMethod paymentMethod,
  }) async {
    showLoaderDialog(navigationKey.currentContext!);
    var data;

    try {
      if (paymentMethod == PaymentMethod.cashOnDelivery) {
        data = ord.Order(
          address: address,
          notes: notes,
          product: ord.Product(
            title: product.title,
            price: product.price,
            quantity: quantity,
          ),
          phoneNumber: userProvider.user.phone,
          user: userProvider.user.name,
          status: 'pending',
          createdAt: Timestamp.now(),
          paymentMethod: 'cashOnDelivery',
        );
      } else {
        data = ord.Order(
          address: address,
          notes: notes,
          product: ord.Product(
            title: product.title,
            price: product.price,
            quantity: quantity,
          ),
          phoneNumber: userProvider.user.phone,
          user: userProvider.user.name,
          status: 'pending',
          createdAt: Timestamp.now(),
          paymentMethod: 'online',
          image: image,
        );
      }

      FirebaseFirestore.instance
          .collection('orders')
          .doc('data')
          .collection('data')
          .add(data.toJson());

      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('completed_request'),
        desc: tr('contact_soon'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      print(error);
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_request'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future gymSubscription({
    required String address,
    required String notes,
    required Gym gym,
    required PaymentMethod paymentMethod,
    String? image,
  }) async {
    GymProvider gymProvider =
        Provider.of<GymProvider>(navigationKey.currentContext!, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false);
    showLoaderDialog(navigationKey.currentContext!);
    var data;

    try {
      if (paymentMethod == PaymentMethod.cashOnDelivery) {
        data = ord.Order(
          address: address,
          notes: notes,
          gymData: ord.GymData(
              gymId: gym.id,
              gymName: gym.name,
              gymAssets: gym.assets[0],
              price: gym.price,
              subscriberId: userProvider.user.uid),
          phoneNumber: userProvider.user.phone,
          user: userProvider.user.name,
          status: 'pending',
          createdAt: Timestamp.now(),
          paymentMethod: 'cashOnDelivery',
        );
      } else {
        data = ord.Order(
          address: address,
          notes: notes,
          gymData: ord.GymData(
              gymId: gym.id,
              gymName: gym.name,
              gymAssets: gym.assets[0],
              price: gym.price,
              subscriberId: userProvider.user.uid),
          phoneNumber: userProvider.user.phone,
          user: userProvider.user.name,
          status: 'pending',
          createdAt: Timestamp.now(),
          paymentMethod: 'online',
          image: image,
        );
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc('data')
          .collection('data')
          .add(data.toJson());
      await gymProvider.subscribeToGym(
          // To Subscribe to Gym Owner And send Notification to him
          user: userProvider.user,
          gym: gym);

      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('completed_request'),
        desc: tr('contact_soon'),
        btnOkOnPress: () {
          pop();
          pop();
        },
      ).show();
    } catch (error) {
      print(error);
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_request'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<User?> getUserById(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        final Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          User user = User.fromMap(userData, userId);
          log("**************************************************************** Trainer Name :${user.name}");
          isLoading = false;
          notifyListeners();
          return user;
        } else {
          log('No data found in the Trainer document for ID: $userId');
          isLoading = false;
          notifyListeners();
          AwesomeDialog(
                  context: navigationKey.currentContext!,
                  dialogType: DialogType.error,
                  animType: AnimType.BOTTOMSLIDE,
                  title:
                      navigationKey.currentContext!.locale.languageCode == 'ar'
                          ? "خطاء"
                          : "Error",
                  desc:
                      navigationKey.currentContext!.locale.languageCode == 'ar'
                          ? "حاول مجددا في وقت لاحق"
                          : "Try again later",
                  btnOkOnPress: () {
                    // navigationKey.currentState!.pop();
                  })
              .show();
          return null;
        }
      } else {
        log('Can\'t get this Trainer, the document not found for ID: $userId');
        isLoading = false;
        notifyListeners();
        AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.BOTTOMSLIDE,
                title: navigationKey.currentContext!.locale.languageCode == 'ar'
                    ? "خطاء"
                    : "Error",
                desc: navigationKey.currentContext!.locale.languageCode == 'ar'
                    ? "حاول مجددا في وقت لاحق"
                    : "Try again later",
                btnOkOnPress: () {
                  // navigationKey.currentState!.pop();
                })
            .show();
        return null;
      }
    } catch (error) {
      log('Error: $error');
      isLoading = false;
      notifyListeners();
      AwesomeDialog(
              context: navigationKey.currentContext!,
              dialogType: DialogType.error,
              animType: AnimType.BOTTOMSLIDE,
              title: navigationKey.currentContext!.locale.languageCode == 'ar'
                  ? "خطاء"
                  : "Error",
              desc: navigationKey.currentContext!.locale.languageCode == 'ar'
                  ? "حاول مجددا في وقت لاحق"
                  : "Try again later",
              btnOkOnPress: () {
                // navigationKey.currentState!.pop();
              })
          .show();
      return null;
    }
  }

  Future<Gym?> getGymById(String gymId) async {
    isLoading = true;
    notifyListeners();

    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .doc(gymId)
          .get();

      if (docSnapshot.exists) {
        final gymData = docSnapshot.data() as Map<String, dynamic>;
        isLoading = false;
        notifyListeners();
        return Gym.fromJson(gymData, docSnapshot.id, 0.0);
      } else {
        isLoading = false;
        notifyListeners();
        AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.BOTTOMSLIDE,
                title: navigationKey.currentContext!.locale.languageCode == 'ar'
                    ? "خطاء"
                    : "Error",
                desc: navigationKey.currentContext!.locale.languageCode == 'ar'
                    ? "حاول مجددا في وقت لاحق"
                    : "Try again later",
                btnOkOnPress: () {
                  // navigationKey.currentState!.pop();
                })
            .show();
        return null;
      }
    } catch (e) {
      log('Error retrieving gym data: $e');
      isLoading = false;
      notifyListeners();
      AwesomeDialog(
              context: navigationKey.currentContext!,
              dialogType: DialogType.error,
              animType: AnimType.BOTTOMSLIDE,
              title: navigationKey.currentContext!.locale.languageCode == 'ar'
                  ? "خطاء"
                  : "Error",
              desc: navigationKey.currentContext!.locale.languageCode == 'ar'
                  ? "حاول مجددا في وقت لاحق"
                  : "Try again later",
              btnOkOnPress: () {
                // navigationKey.currentState!.pop();
              })
          .show();
      return null;
    }
  }

  Future<void> getAllOrdersForAdmin() async {
    try {
      isLoading = true;
      if (!userProvider.isAdmin) return;
      orders.clear();
      var data = await FirebaseFirestore.instance
          .collection('orders')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((value) {
        value.docs.forEach((element) {
          orders.add(ord.Order.fromJson(
              element.data() as Map<String, dynamic>, element.id));
        });
      });
      isLoading = false;

      notifyListeners();
    } catch (error) {
      isLoading = false;
      print(error);
    }
  }

  Future<void> updateOrderStatus(
      {required String id, required String status}) async {
    try {
      if (!userProvider.isAdmin) return;
      FirebaseFirestore.instance
          .collection('orders')
          .doc('data')
          .collection('data')
          .doc(id)
          .update({'status': status});

      orders.where((element) => element.id == id).first.status = status;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteOrder({required String id}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      String? data = orders.where((element) => element.id == id).first.image;
      if (!userProvider.isAdmin) return;
      await FirebaseFirestore.instance
          .collection('orders')
          .doc('data')
          .collection('data')
          .doc(id)
          .delete()
          .then((value) async {
        if (data != null && data.isNotEmpty) {
          await UploadProvider().deleteAllAssets([data]);
        }
      });
      orders.removeWhere((element) {
        return element.id == id;
      });

      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: navigationKey.currentContext!.locale.languageCode == 'ar'
            ? "تم الحذف"
            : "Deleted",
        desc: navigationKey.currentContext!.locale.languageCode == 'ar'
            ? "تم حذف الطلب بنجاح"
            : "Order deleted Successfully",
        btnOkOnPress: () {
          // pop();
          // pop();
        },
      ).show();
      notifyListeners();
    } catch (error) {
      log("ERROR While Delete An Order : $error");
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_request'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }
}
