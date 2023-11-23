import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/alarm_model.dart';
import '../../provider/user_provider.dart';
import '../../utils/helper_functions.dart';
import '../../utils/widgets/global Widgets.dart';
import '../ProteinCalc_Screen.dart';

class AlarmWaterScreen extends StatefulWidget {
  const AlarmWaterScreen({super.key});

  @override
  State<AlarmWaterScreen> createState() => _AlarmWaterScreenState();
}

class _AlarmWaterScreenState extends State<AlarmWaterScreen> {
  Future<void> _addAlarm({required UserProvider p}) async {
    AlarmModel newAlarm = AlarmModel(
      alarmName: 'New Alarm',
      alarmTime:
          '${p.selectedTime?.hour.toString().padLeft(2, '0')}:${p.selectedTime?.minute.toString().padLeft(2, '0')}',
      isSwitchedOn: true,
      waterQuantity: p.waterLitres,
    );
    p.addAlarm(newAlarm);
    // TODO : Notify The User
    await HelperFunctions.scheduleDailyNotification(p.selectedTime!, p,
        waterLitres: newAlarm.waterQuantity);

    print('***************** Water Q from add :${newAlarm.waterQuantity}');
    debugPrint('Updated alarm time: ${p.selectedTime}');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, alarmProvider, _) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          alarmProvider.resetAlarm();
        },
        child: WillPopScope(
          onWillPop: () async {
            alarmProvider.resetAlarm();
            return Future.value(true);
          },
          child: Scaffold(
            appBar: globalAppBar(tr('add_alarm')),
            // appBar: globalAppBar('اضافة منبه'),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => alarmProvider.showTimePickerDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: Row(
                        children: [
                          (alarmProvider.selectedTime != null)
                              ? Text(
                                  '${context.locale.languageCode == 'ar' ? 'يوميا' : 'Daily'} : ${alarmProvider.selectedTime?.hour.toString().padLeft(2, '0')}:${alarmProvider.selectedTime?.minute.toString().padLeft(2, '0')} ',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  tr('enter_alert_time'),
                                  // "حدد موعد التنبية ",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          const Spacer(),
                          Icon(
                            Icons.more_time,
                            size: 30.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyFlooatingButton(
                          myIcon: Icons.add,
                          onPressed: () => alarmProvider.increase(),
                          radius: 50.sp,
                          size: 35.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Image.asset(
                            'assets/images/water.png',
                            height: 150.h,
                            width: 110.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        MyFlooatingButton(
                          myIcon: Icons.remove,
                          onPressed: () => alarmProvider.decrease(),
                          radius: 50.sp,
                          size: 35.sp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "${tr('water_quantity')} ${alarmProvider.waterLitres} (${context.locale.languageCode == 'ar' ? 'كوب' : 'cup'})",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (alarmProvider.selectedTime == null) {
                            Fluttertoast.showToast(
                              msg: context.locale.languageCode == 'ar'
                                  ? 'اختر توقيت المنبه أولا'
                                  : 'Choose your alarm time first',
                            );
                          } else {
                            Navigator.of(context).pop();
                            _addAlarm(p: alarmProvider)
                                .then((value) => alarmProvider.resetAlarm());
                          }
                        },
                        child: Text(
                          tr('add_the_alarm'),
                          // "أضف المنبه",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          alarmProvider.resetAlarm();
                        },
                        child: Text(
                          tr('cancel'),
                          // "الغاء",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
