import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/screens/setting_screens/alarm_water_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../provider/user_provider.dart';
import '../../utils/widgets/alarm_widget.dart';

class SettingAlarmScreen extends StatelessWidget {
  const SettingAlarmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<UserProvider>(
      builder: (context, alarmProvider, _) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          alarmProvider.resetAlarm();
        },
        child: Scaffold(
          appBar: globalAppBar(tr('water_alarm')),
          // appBar: globalAppBar('منبه لشرب الماء'),
          floatingActionButton: FloatingActionButton(
            // onPressed: () => _showTimePickerDialog(context, alarmProvider),
            // onPressed: () => _showAddAlarmDialog(context),
            onPressed: () => To(const AlarmWaterScreen()),

            child: const Icon(Icons.add),
          ),
          body: _body(
            context: context,
            height: height,
            width: width,
            userProvider: alarmProvider,
          ),
        ),
      ),
    );
  }

  Widget _body({
    required BuildContext context,
    required double width,
    required double height,
    required UserProvider userProvider, // Add the AlarmProvider as a parameter
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: (userProvider.alarms.isEmpty)
          ? Center(
              child: Text(
                tr('add_water_reminder'),
                // 'أضف تذكير لشرب الماء',
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            )
          : ListView.builder(
              // Use ListView.builder to display all alarms
              itemCount: userProvider.alarms.length,
              itemBuilder: (context, index) {
                final alarm = userProvider.alarms[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    userProvider.deleteAlarm(alarm.id!);
                  },
                  child: AlarmWidget(
                    alarmName: alarm.alarmName,
                    alarmTime: TimeOfDay(
                      hour: int.parse(alarm.alarmTime.split(':')[0]),
                      minute: int.parse(alarm.alarmTime.split(':')[1]),
                    ),
                    height: height,
                    width: width,
                    waterQuantity: alarm.waterQuantity,
                  ),
                );
              },
            ),
    );
  }
}
