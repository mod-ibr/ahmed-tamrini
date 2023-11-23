// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:tamrini/utils/cache_helper.dart';
// import 'package:tamrini/utils/constants.dart';
// import 'package:tamrini/utils/helper_functions.dart';
// import 'package:tamrini/utils/widgets/global%20Widgets.dart';

// import '../../provider/user_provider.dart';
// import '../ProteinCalc_Screen.dart';

// class SettingAlarmScreenOld extends StatefulWidget {
//   const SettingAlarmScreenOld({Key? key}) : super(key: key);

//   @override
//   State<SettingAlarmScreenOld> createState() => _SettingAlarmScreenOldState();
// }

// class _SettingAlarmScreenOldState extends State<SettingAlarmScreenOld> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProvider>(
//       builder: (context, userProvider, ___) => GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Scaffold(
//             appBar: globalAppBar(
//               'منبه لشرب الماء',
//             ),
//             body: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20.h),
//                     child: Text(
//                       userProvider.drinkAlarm == null
//                           ? "لا يوجد منبه حالي"
//                           : "يوميا: ${userProvider.drinkAlarm!.format(context)} (${userProvider.waterLitres} لتر)",
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         height: 50.h,
//                         width: 100.w,
//                         margin: EdgeInsets.symmetric(vertical: 30.h),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await showTimePicker(
//                               context: context,
//                               initialTime:
//                                   userProvider.drinkAlarm ?? TimeOfDay.now(),
//                             ).then((newTime) async {
//                               if (newTime != null) {
//                                 await CacheHelper.putString(
//                                   key: 'drinkAlarm',
//                                   value: jsonEncode({
//                                     'time': newTime.toString(),
//                                     'litres': userProvider.waterLitres,
//                                   }),
//                                 );
//                                 await HelperFunctions.scheduleDailyNotification(
//                                   newTime,
//                                   userProvider,
//                                 );
//                                 userProvider.setUserDrinkAlarm(
//                                   newTime,
//                                   userProvider.waterLitres,
//                                 );
//                                 debugPrint('Updated alarm time: $newTime');
//                               }
//                             });
//                           },
//                           child: Text(
//                             'ضبط المنبه',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'cairo',
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 50.h,
//                         width: 100.w,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await userProvider.setUserDrinkAlarm(null, null);
//                             await CacheHelper.sharedPreferences!
//                                 .remove('drinkAlarm');
//                           },
//                           style: const ButtonStyle(
//                               backgroundColor:
//                                   MaterialStatePropertyAll(Colors.red)),
//                           child: Text(
//                             'الغاء المنبه',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'cairo',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: kPrimaryColor,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "كمية الماء (لتر)",
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             MyFlooatingButton(
//                               myIcon: Icons.remove,
//                               onPressed: () async {
//                                 userProvider.decreaseLitres();
//                                 if (userProvider.drinkAlarm != null) {
//                                   await CacheHelper.putString(
//                                     key: 'drinkAlarm',
//                                     value: jsonEncode({
//                                       'time':
//                                           userProvider.drinkAlarm!.toString(),
//                                       'litres': userProvider.waterLitres,
//                                     }),
//                                   );
//                                 }
//                               },
//                             ),
//                             Text(
//                               userProvider.waterLitres.toString(),
//                               style: TextStyle(
//                                 fontSize: 22.sp,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                             MyFlooatingButton(
//                               myIcon: Icons.add,
//                               onPressed: () async {
//                                 userProvider.increaseLitres();
//                                 if (userProvider.drinkAlarm != null) {
//                                   await CacheHelper.putString(
//                                     key: 'drinkAlarm',
//                                     value: jsonEncode({
//                                       'time':
//                                           userProvider.drinkAlarm!.toString(),
//                                       'litres': userProvider.waterLitres,
//                                     }),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
