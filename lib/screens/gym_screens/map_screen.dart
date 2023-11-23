import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/data/location.dart';

class MapScreen extends StatefulWidget {
  LatLng? value;

  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    widget.value = LatLng(33.3118944, 44.4959932);

    _cameraPosition =
        CameraPosition(target: LatLng(33.3118944, 44.4959932), zoom: 14.4746);
  }

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationController>(
      builder: (_, locationController, __) {
        return Scaffold(
            // appBar: AppBar(
            //   title: const Text('Maps Sample App'),
            //   backgroundColor: Colors.green[700],
            // ),
            body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                widget.value = _cameraPosition.target;
                // locationController.setMapController(mapController);
              },
              initialCameraPosition: _cameraPosition,
              onCameraMove: (CameraPosition newPosition) {
                // print(newPosition.target.toJson());
                widget.value = newPosition.target;
              },
            ),
            Positioned(
              top: 50,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () => Get.dialog(
                    LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.location_on,
                        size: 25, color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    //here we show the address on the top
                    Expanded(
                      child: Text(
                        '${locationController.pickPlaceMark.name ?? ''} ${locationController.pickPlaceMark.locality ?? ''} '
                        '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.search,
                        size: 25,
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2,
              right: (MediaQuery.of(context).size.width - 30) / 2,
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
                    // final GoogleMapController controller =
                    // await _mapController.future;
                    _mapController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 17)));
                  },
                  icon: const Icon(Icons.my_location, color: Colors.black),
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
        ));
      },
    );
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

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;

  const LocationSearchDialog({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
            width: 350,
            child: TypeAheadField(
              hideSuggestionsOnKeyboardHide: false,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: tr('search'),
                  // hintText: 'بحث',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 20,
                    ),
              ),
              suggestionsCallback: (pattern) async {
                return await Get.find<LocationController>()
                    .searchLocation(context, pattern);
              },
              itemBuilder: (context, Prediction suggestion) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(suggestion.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline2?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: 20,
                                  )),
                    ),
                  ]),
                );
              },
              onSuggestionSelected: (Prediction suggestion) {
                print("My location is " + suggestion.description!);
                Get.find<LocationController>()
                    .setLocation(suggestion, mapController!);
                Get.back();
              },
            )),
      ),
    );
  }
}
