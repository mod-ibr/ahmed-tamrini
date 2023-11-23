import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart'; // import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/map_screen.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AddGymScreen extends StatefulWidget {
  const AddGymScreen({Key? key}) : super(key: key);

  @override
  State<AddGymScreen> createState() => _AddGymScreenState();
}

class _AddGymScreenState extends State<AddGymScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // Location? location ;
  String address = "null";
  String autocompletePlace = "null";
  MapScreen mapPicker = MapScreen();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    allPhotos.clear();

    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('add')),
        // appBar: globalAppBar("إضافة"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        tr('add_gym'),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: tr('gym_name'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 50,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: tr('gym_desc'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 50,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: tr('gym_price'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          child: Text(tr('determine_gym_location'),
                              // child: const Text('حدد موقع الصالة',
                              style: const TextStyle(color: Colors.white)),
                          onPressed: () async {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return mapPicker;
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ImageUploads(),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);
                            var images = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFiles();

                            CacheHelper.init();

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                images.isNotEmpty) {
                              if (mapPicker.value == null) {
                                pop();

                                Fluttertoast.showToast(
                                  msg: context.locale.languageCode == 'ar'
                                      ? 'من فضلك اختر موقع الصالة'
                                      : "Please enter the gym's location",
                                );
                                return;
                              }

                              Gym gym = Gym(
                                name: titleController.text,
                                description: descriptionController.text,
                                assets: images,
                                isPendingGym:
                                    userProvider.isAdmin ? false : true,
                                gymOwnerId: userProvider.isAdmin
                                    ? ''
                                    : userProvider.getCurrentUserId() ?? "",
                                price: int.parse(priceController.text),
                                location: GeoPoint(mapPicker.value!.latitude,
                                    mapPicker.value!.longitude),
                                // location as GeoPoint,
                                id: '',
                                distance: 0,
                              );

                              gymProvider.addGym(
                                  gym: gym, userProvider: userProvider);

                              pop();
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            print("image uploade error2" + e.toString());
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(tr('add_the_gym'),
                            // child: const Text('إضافة الصالة',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapPicker extends StatefulWidget {
  static const DEFAULT_ZOOM = 14.4746;
  static const KINSHASA_LOCATION = LatLng(33.3118944, 44.4959932);

  double initZoom;
  LatLng initCoordinates;
  LatLng? value;

  MapPicker(
      {Key? key,
      this.initZoom = DEFAULT_ZOOM,
      this.initCoordinates = KINSHASA_LOCATION})
      : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  String location = tr('search');
  CameraPosition? cameraPosition;
  String googleApikey = "AIzaSyBufaYHAy80nTHvhEjS8ABOwBlSK_3HCnQ";
  late GoogleMapController googleMapController;
  Set<Marker> markersList = {};

  @override
  void initState() {
    widget.value = widget.initCoordinates;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      body: Center(
        child: SizedBox(
          // width: 400,
          // height: 300,
          child: LayoutBuilder(
            builder: (context, constraints) {
              var maxWidth = constraints.biggest.width;
              var maxHeight = constraints.biggest.height;

              return Stack(
                children: <Widget>[
                  GestureDetector(
                    child: SizedBox(
                      height: maxHeight,
                      width: maxWidth,
                      child: GoogleMap(
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer()))
                          ..add(Factory<ScaleGestureRecognizer>(
                              () => ScaleGestureRecognizer()))
                          ..add(Factory<TapGestureRecognizer>(
                              () => TapGestureRecognizer())),
                        // gestureRecognizers: Set()
                        //   ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                        //   ..add(Factory<VerticalDragGestureRecognizer>(
                        //           () => VerticalDragGestureRecognizer())),

                        initialCameraPosition: CameraPosition(
                          target: widget.initCoordinates,
                          zoom: widget.initZoom,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          widget.value = widget.initCoordinates;
                          _controller.complete(controller);
                          googleMapController = controller;
                        },
                        onCameraMove: (CameraPosition newPosition) {
                          // print(newPosition.target.toJson());
                          widget.value = newPosition.target;
                        },
                        markers: markersList,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: false,
                        zoomGesturesEnabled: true,
                        padding: const EdgeInsets.all(0),
                        buildingsEnabled: true,
                        cameraTargetBounds: CameraTargetBounds.unbounded,
                        compassEnabled: true,
                        indoorViewEnabled: false,
                        mapToolbarEnabled: true,
                        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        trafficEnabled: false,
                      ),
                    ),
                  ),
                  Positioned(
                      //search input bar
                      top: 10,
                      child: InkWell(
                          onTap: () async {
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleApikey,
                                mode: Mode.overlay,
                                types: [],
                                strictbounds: false,
                                language: "ar",
                                components: [
                                  Component(Component.country, 'iq'),
                                  Component(Component.country, 'sa'),
                                  Component(Component.country, 'ae'),
                                  Component(Component.country, 'kw'),
                                  Component(Component.country, 'bh'),
                                  Component(Component.country, 'om'),
                                  Component(Component.country, 'qa'),
                                  Component(Component.country, 'jo'),
                                  Component(Component.country, 'lb'),
                                  Component(Component.country, 'sy'),
                                  Component(Component.country, 'eg'),
                                  Component(Component.country, 'ly'),
                                  Component(Component.country, 'ma'),
                                  Component(Component.country, 'dz'),
                                  Component(Component.country, 'tn'),
                                  Component(Component.country, 'ye'),
                                  Component(Component.country, 'ps'),
                                  Component(Component.country, 'mr'),
                                  Component(Component.country, 'so'),
                                  Component(Component.country, 'sd'),
                                  Component(Component.country, 'er'),
                                  Component(Component.country, 'dj'),
                                  Component(Component.country, 'et'),
                                  Component(Component.country, 'ss'),
                                  Component(Component.country, 'sd'),
                                  Component(Component.country, 'cf'),
                                  Component(Component.country, 'cm'),
                                  Component(Component.country, 'td'),
                                  Component(Component.country, 'cf'),
                                  Component(Component.country, 'cg'),
                                  Component(Component.country, 'ga'),
                                  Component(Component.country, 'gq'),
                                  Component(Component.country, 'cg'),
                                  Component(Component.country, 'ao'),
                                  Component(Component.country, 'cd'),
                                ],
                                //google_map_webservice package
                                onError: (err) {
                                  print("map error" + err.toString());
                                });

                            if (place != null) {
                              setState(() {
                                location = place.description.toString();
                              });

                              //form google_maps_webservice package
                              final plist = GoogleMapsPlaces(
                                apiKey: googleApikey,
                                apiHeaders:
                                    await const GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              final geometry = detail.result.geometry!;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              var newlatlang = LatLng(lat, lang);
                              final GoogleMapController controller =
                                  await _controller.future;
                              //move map camera to selected place with animation
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 17)));
                            }
                            displayPrediction(place!);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListTile(
                                    title: Text(
                                      location,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    trailing: Icon(Icons.search),
                                    dense: true,
                                  )),
                            ),
                          ))),
                  Positioned(
                    bottom: maxHeight / 2,
                    right: (maxWidth - 30) / 2,
                    child: const Icon(
                      Icons.person_pin_circle,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          var position = await _determinePosition();
                          final GoogleMapController controller =
                              await _controller.future;
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      position.latitude, position.longitude),
                                  zoom: widget.initZoom)));
                        },
                        icon:
                            const Icon(Icons.my_location, color: Colors.black),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        icon: const Icon(
                            Icons.check
                            // Icons.check_circle_outline,
                            ,
                            color: Colors.black
                            // Colors.green,
                            ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: googleApikey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
