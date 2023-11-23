import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tamrini/provider/user_provider.dart';

class HelperFunctions {
  static Widget wrapWithAnimatedBuilder({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => FractionalTranslation(
        translation: animation.value,
        child: child,
      ),
    );
  }

  static bool _customContains(String word, String searchWord) {
    searchWord = _normalizeArabicLetters(searchWord);
    word = _normalizeArabicLetters(word);

    for (int i = 0; i <= word.length - searchWord.length; i++) {
      if (word.substring(i, i + searchWord.length) == searchWord) {
        return true;
      }
    }
    return false;
  }

  static String _normalizeArabicLetters(String input) {
    final Map<String, String> arabicEquivalences = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'ة': 'ه',
      'ى': 'ي',
      'ظ': 'ض',
      'ق': 'ج',
    };
    return input.replaceAllMapped(RegExp('[${arabicEquivalences.keys.join()}]'),
        (match) => arabicEquivalences[match.group(0)]!);
  }

  static bool matchesSearch(List<String> searchWords, String phrase) {
    // List<String> words = phrase.toLowerCase().split(' ');
    // return searchWords.any((searchTerm) =>
    //     words.any((word) => word.contains(searchTerm.toLowerCase())));

    List<String> words = phrase.toLowerCase().split(" ");
    return searchWords.every((searchWord) =>
        words.any((word) => _customContains(word, searchWord.toLowerCase())));
  }

  static Future<void> scheduleDailyNotification(
      TimeOfDay notificationTime, UserProvider userProvider,
      {int waterLitres = 1}) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate.add(const Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'daily_notification',
        title: tr('drink_water'),
        body: '${tr('about_drinking')} $waterLitres ${tr('cup')}',
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
  }

  static Future<void> rescheduleDailyNotification(
    UserProvider userProvider,
  ) async {
    if (userProvider.drinkAlarm != null) {
      await scheduleDailyNotification(userProvider.drinkAlarm!, userProvider);

      const Duration durationUntilNextNotification = Duration(days: 1);
      await AndroidAlarmManager.periodic(
        durationUntilNextNotification,
        0,
        rescheduleDailyNotification,
        startAt: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          userProvider.drinkAlarm!.hour,
          userProvider.drinkAlarm!.minute,
        ),
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    }
  }

  static TimeOfDay parseTimeOfDayFromString(String timeString) {
    String timeValue = timeString.substring(
        timeString.indexOf('(') + 1, timeString.indexOf(')'));
    List<String> timeValues = timeValue.split(':');
    int hour = int.parse(timeValues[0]);
    int minute = int.parse(timeValues[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<void> showDialogue(BuildContext context) async {
    int minutes = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.locale.languageCode == 'ar'
              ? 'تذكير استراحة'
              : 'Break reminder'),
          content: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                labelText: context.locale.languageCode == 'ar'
                    ? 'بعد كم دقيقة؟'
                    : 'In how many minutes?'),
            onChanged: (value) {
              minutes = int.tryParse(value) ?? 0;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 0,
                    channelKey: 'exercises_rest',
                    title: tr('reminder_to_rest'),
                    body: tr('time_for_break'),
                    notificationLayout: NotificationLayout.Default,
                  ),
                  schedule: NotificationInterval(interval: minutes * 60),
                );
                Fluttertoast.showToast(msg: tr('timer_added'));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static ImageProvider ourFirebaseImageProvider({required String url}) {
    try {
      ImageProvider image = FirebaseImageProvider(FirebaseUrl(url));
      // log("Good Image");
      return image;
    } on FirebaseException {
      // log("ERROR :ourFirebaseImageProvider : FirebaseException");
      return Image.asset("assets/images/allExer.jpg").image;
    } catch (e) {
      // log("ERROR :ourFirebaseImageProvider : ${e.toString()}");
      return Image.asset("assets/images/allExer.jpg").image;
    }
  }
}
