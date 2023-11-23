import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

class LocationController extends ChangeNotifier {
  Placemark _pickPlaceMark = Placemark();
  Placemark get pickPlaceMark => _pickPlaceMark;

  setLocation(Prediction suggestion, GoogleMapController controller) async {
    var location = await getPlaceMarkFromId(suggestion.placeId!);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(location.lat!, location.lng!), zoom: 17)));
    notifyListeners();
  }

  // get location from place id
  Future<dynamic> getPlaceMarkFromId(String placeId) async {
    final geocoding =
        GoogleMapsGeocoding(apiKey: "AIzaSyBufaYHAy80nTHvhEjS8ABOwBlSK_3HCnQ");

    final response = await geocoding.searchByPlaceId(placeId);

    final result = response.results[0].geometry.location;
    return result;
  }

  List<Prediction> _predictionList = [];
  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      print("my status is " + data["status"]);
      if (data['status'] == 'OK') {
        _predictionList = [];
        data['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
        print(_predictionList.length);
      } else {
        // ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  Future<http.Response> getLocationData(String text) async {
    http.Response response;

    var apiKey = "AIzaSyBufaYHAy80nTHvhEjS8ABOwBlSK_3HCnQ";
    response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$apiKey',
    ));

    print(jsonDecode(response.body));
    return response;
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  log('serviceEnabled: $serviceEnabled');
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  log('permission: $permission');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future checkPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.

      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.

    return false;
  }
  return true;
}
