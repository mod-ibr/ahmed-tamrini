import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tamrini/data/location.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/gym.dart';
import '../utils/helper_functions.dart';
import '../utils/widgets/global Widgets.dart';
import 'Upload_Image_provider.dart';

class GymProvider with ChangeNotifier {
  List<Gym> _gyms = [], pendingGyms = [];
  List<Gym> filteredGyms = [];
  bool isLoading = false;
  String? selectedSortBy;
  TextEditingController searchController = TextEditingController();

  List<Gym> get gyms {
    return [..._gyms];
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Gym?> getGymByOwnerId(String gymOwnerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('gyms')
          .doc('data')
          .collection('data')
          .where('gymOwnerId', isEqualTo: gymOwnerId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final gymData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return Gym.fromJson(gymData, querySnapshot.docs.first.id, 0.0);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving gym data: $e');
      return null;
    }
  }

  changeSelectedSortBy(String? value) {
    selectedSortBy = value;
    List sortBy = [
      tr('lowest_price'),
      // 'الأقل سعراً',
      tr('highest_price'),
      // 'الأعلى سعراً',
      tr('closest'),
      // 'الأقرب',
      tr('furthest'),
      // 'الأبعد',
    ];
    int index = sortBy.indexWhere((element) => element == value);
    switch (index) {
      case 2:
        // case 'الأقرب':
        sortByDistance(isAscending: true);
        break;
      case 3:
        // case 'الأبعد':
        sortByDistance(isAscending: false);
        break;
      case 1:
        // case 'الأعلى سعراً':
        sortByPrice(isAscending: false);
        break;
      case 0:
        // case 'الأقل سعراً':
        sortByPrice(isAscending: true);
        break;
      default:
        sortByDistance();
    }
  }

  Future<void> addGym(
      {required Gym gym, required UserProvider userProvider}) async {
    try {
      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .add(gym.toJson())
          .then((value) async {
        // TODO : save the gymID for the user and add it to pending list
        log('******************** Gym ID : ${value.id}');
        log('******************** Gym Owner ID : ${gym.gymOwnerId}');
        gym.id = value.id;
        await userProvider.addUserGymId(gym.id);
        (!gym.isPendingGym) ? _gyms.add(gym) : pendingGyms.add(gym);
        filteredGyms = [..._gyms];
        notifyListeners();
      });
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('accomplished_successfully'),
          desc: tr('added_gym'),
          btnOkOnPress: () {
            navigationKey.currentState!.pop();
          }).show();
    } catch (error) {
      print(error);
    }
  }

  Future<void> acceptGym({required Gym gym}) async {
    try {
      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .doc(gym.id)
          .update({'isPendingGym': false}).then((value) async {
        log('******************** Gym ID : ${gym.id}');
        log('******************** Gym Owner ID : ${gym.gymOwnerId}');
        gym.isPendingGym = false;
        _gyms.add(gym);
        pendingGyms.removeWhere((element) => element.id == gym.id);

        filteredGyms = [..._gyms];
        notifyListeners();
      });
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('accomplished_successfully'),
          desc: tr('added_gym'),
          btnOkOnPress: () {
            navigationKey.currentState!.pop();
          }).show();
    } catch (error) {
      print(error);
    }
  }

  Future<void> rejectGym(
      {required Gym gym, required UserProvider userProvider}) async {
    try {
      var data = gym.assets;
      log('Gym assets length : ${data.length}');
      String gymOwnerId = gym.gymOwnerId;

      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .doc(gym.id)
          .delete()
          .then((value) async {
        await UploadProvider().deleteAllAssets(data);

        _gyms.removeWhere((element) => element.id == gym.id);
        pendingGyms.removeWhere((element) => element.id == gym.id);
        await userProvider.deleteUserGymId(gymOwnerId);
        filteredGyms = [..._gyms];
        AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: tr('accomplished_successfully'),
                desc: tr('deleted_gym'),
                btnOkOnPress: () {})
            .show();
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateGym(
      {required Gym gym, required UserProvider userProvider}) async {
    try {
      bool isFound = false;
      var data = _gyms.firstWhere((element) => element.id == gym.id).assets;
      log('Before Update');
      log('******************** Gym ID : ${gym.id}');
      log('******************** Gym Owner ID : ${gym.gymOwnerId}');
      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .doc(gym.id)
          .get()
          .then((value) async {
        if (value.exists) {
          log("Gym  Found");
          await value.reference.update(gym.toJson());
          isFound = true;
        }
      });
      log('After Update');
      log('******************** Gym ID : ${gym.id}');
      log('******************** Gym Owner ID : ${gym.gymOwnerId}');
      if (!isFound) return;
      await UploadProvider()
          .deleteOldImages(oldImages: data, newImages: gym.assets);

      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('accomplished_successfully'),
          desc: tr('modified_gym'),
          btnOkOnPress: () {
            pop();
            pop();
          }).show();

      _gyms[_gyms.indexWhere((element) => element.id == gym.id)] = gym;
      filteredGyms = [..._gyms];

      notifyListeners();
    } catch (error) {
      pop();
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('wrong'),
          desc: tr('error_while_modified_gym'),
          btnOkOnPress: () {
            navigationKey.currentState!.pop();
          }).show();
      print("eroorr" + error.toString());
    }
  }

  Future<void> fetchAndSetGyms() async {
    isLoading = true;
    try {
      var location;
      var startLatitude;
      var startLongitude;
      try {
        // ask for permission
        location = await determinePosition();
        startLatitude = location.latitude;
        startLongitude = location.longitude;
        log("location : $location");
      } catch (error) {
        startLatitude = 33.3118944;
        startLongitude = 44.4959932;
        // default location in baghdad
        print(error);
      }

      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        log('*************** Start fetching Gyms');
        _gyms = event.docs.map((e) {
          var data = e.data() as Map<String, dynamic>;
          GeoPoint endLocation = data['location'];
          log('endLocation : $endLocation');
          log("name : ${data['name']}");
          double distance = Geolocator.distanceBetween(startLatitude,
                  startLongitude, endLocation.latitude, endLocation.longitude) /
              1000;
          log('distance : $distance');

          Gym gym =
              Gym.fromJson(e.data() as Map<String, dynamic>, e.id, distance);

          return gym;
        }).toList();
        _gyms.removeWhere((element) => element.isPendingGym);
        _gyms.sort(((a, b) => a.distance.compareTo(b.distance)));
        filteredGyms = List.from(_gyms);

        isLoading = false;

        sortByDistance();
        // notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      log('*************** ERROR fetching Gyms :$error');
      print(error);
    }
  }

  Future<void> fetchAndSetPendingGyms() async {
    isLoading = true;
    try {
      var location;
      var startLatitude;
      var startLongitude;
      try {
        // ask for permission
        location = await determinePosition();
        startLatitude = location.latitude;
        startLongitude = location.longitude;
      } catch (error) {
        startLatitude = 33.3118944;
        startLongitude = 44.4959932;
        // default location in baghdad
        print(error);
      }

      await FirebaseFirestore.instance
          .collection('gyms')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        pendingGyms = event.docs.map((e) {
          var data = e.data() as Map<String, dynamic>;
          GeoPoint endLocation = data['location'];
          double distance = Geolocator.distanceBetween(startLatitude,
                  startLongitude, endLocation.latitude, endLocation.longitude) /
              1000;
          Gym gym =
              Gym.fromJson(e.data() as Map<String, dynamic>, e.id, distance);
          log('******************** User Id :${gym.gymOwnerId} ');

          return gym;
        }).toList();
        pendingGyms.removeWhere((element) => !element.isPendingGym);
        isLoading = false;

        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);
    }
  }

  Future<void> searchGym() async {
    if (searchController.text.isEmpty) {
      filteredGyms = [..._gyms];
      notifyListeners();
      return;
    }

    filteredGyms = _gyms.where((element) {
      return HelperFunctions.matchesSearch(
        searchController.text.toLowerCase().split(" "),
        element.name,
      );
    }).toList();
    notifyListeners();
  }

  clearSearch() {
    searchController.clear();
    filteredGyms = [..._gyms];
  }

  sortByPrice({bool isAscending = true}) {
    filteredGyms.sort((a, b) {
      return a.price.compareTo(b.price);
    });
    if (!isAscending) {
      filteredGyms = filteredGyms.reversed.toList();
    }
    notifyListeners();
  }

  sortByDistance({bool isAscending = true}) async {
    if (await checkPermission()) {
      filteredGyms.sort((a, b) {
        return a.distance.compareTo(b.distance);
      });
      if (!isAscending) {
        filteredGyms = filteredGyms.reversed.toList();
      }

      notifyListeners();
    } else {
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('enable_location'),
          btnOkOnPress: () {
            checkPermission();
          }).show();
    }
  }

  Future<void> openMap(Gym gym) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${gym.location.latitude},${gym.location.longitude}';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
