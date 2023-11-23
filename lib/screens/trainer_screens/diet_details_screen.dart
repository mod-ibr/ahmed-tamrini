import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class DietDetailsScreen extends StatelessWidget {
  final Food food;

  const DietDetailsScreen({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('diet_details')),
      // appBar: globalAppBar('تفاصيل النظام الغذائي'),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              food.title!,
                              style: TextStyle(
                                  fontSize: 25.spMin,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: Text(
                                  " ${food.duration ?? ""} ${context.locale.languageCode == 'ar' ? 'أسبوع' : 'week'} ")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      food.foodData!,
                      style: TextStyle(
                          fontSize: 20.spMin, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
