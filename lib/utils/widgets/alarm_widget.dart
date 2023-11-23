import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlarmWidget extends StatelessWidget {
  final double width, height;
  final String alarmName;
  final TimeOfDay alarmTime;
  final int waterQuantity;

  const AlarmWidget({
    super.key,
    required this.alarmName,
    required this.alarmTime,
    required this.width,
    required this.height,
    required this.waterQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.10,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tr('water_quantity'),
            // "كمية الماء",
            style: TextStyle(fontSize: 15.sp),
          ),
          SizedBox(width: 3.w),
          Text(
            waterQuantity.toString(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            "(${context.locale.languageCode == 'ar' ? 'كوب' : 'cup'})",
            style: TextStyle(fontSize: 15.sp),
          ),
          SizedBox(width: 5.w),
          Image.asset(
            'assets/images/water.png',
            height: 18.h,
            width: 15.w,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 12.w),
          const Spacer(),
          Text(
            '${context.locale.languageCode == 'ar' ? 'يوميا' : 'Daily'} : ${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')} ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
