// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import '../model/alarm_model.dart';
// import '../utils/alarm_database_helper.dart';

// class AlarmProvide with ChangeNotifier {
//   List<AlarmModel> _alarms = [];
//   bool _isLoading = false;
//   int waterLitres = 1;

//   List<AlarmModel> get alarms => _alarms;
//   bool get isLoading => _isLoading;

//   // Initialize the alarms from the database when the provider is created
//   AlarmProvider() {
//     _initAlarms();
//   }

//   // Function to initialize alarms from the database
//   void _initAlarms() async {
//     _isLoading = true;
//     notifyListeners();

//     _alarms = await AlarmDatabaseHelper.instance.getAllAlarms();

//     _isLoading = false;
//     notifyListeners();
//   }

//   // Function to add a new alarm
//   Future<void> addAlarm(AlarmModel alarm) async {
//     _isLoading = true;
//     notifyListeners();

//     int id = await AlarmDatabaseHelper.instance.insert(alarm);
//     alarm.id = id;
//     _alarms.add(alarm);
// // TODO: make the Alarm notification logic

//     _isLoading = false;
//     notifyListeners();
//   }

//   // Function to update an existing alarm
//   Future<void> updateAlarm(AlarmModel alarm) async {
//     _isLoading = true;
//     notifyListeners();

//     await AlarmDatabaseHelper.instance.updateAlarm(alarm);
//     _alarms[_alarms.indexWhere((element) => element.id == alarm.id)] = alarm;

//     _isLoading = false;
//     notifyListeners();
//   }

//   // Function to delete an alarm
//   Future<void> deleteAlarm(int id) async {
//     _isLoading = true;
//     notifyListeners();

//     await AlarmDatabaseHelper.instance.deleteAlarm(id);
//     _alarms.removeWhere((element) => element.id == id);

//     _isLoading = false;
//     notifyListeners();
//   }

// // Function to update the water quantity for a specific alarm
//   Future<void> updateWaterQuantity(int id, int waterQuantity) async {
//     _isLoading = true;
//     notifyListeners();

//     await AlarmDatabaseHelper.instance.updateWaterQuantity(id, waterQuantity);
//     _alarms[_alarms.indexWhere((element) => element.id == id)].waterQuantity =
//         waterQuantity;

//     _isLoading = false;
//     notifyListeners();
//   }


// }
