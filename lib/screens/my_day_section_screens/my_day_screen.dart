import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/provider/user_provider.dart';

import '../../utils/constants.dart';
import '../../utils/widgets/button_widget.dart';
import '../../utils/widgets/global Widgets.dart';
import '../ProteinCalc_Screen.dart';
import 'day_details.dart';

class MyDay extends StatefulWidget {
  const MyDay({super.key});

  @override
  State<MyDay> createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  bool resetBMI = false;
  bool canAdd = false;

  onSaveProteins(Map<String, dynamic> newData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context, listen: false).user.uid)
        .collection('my_day')
        .doc('data')
        .set({'proteins_calc': newData}, SetOptions(merge: true));
    setState(() => resetBMI = false);
  }

  _addToday({required String docID}) async {
    debugPrint(docID);
    // inside each user, we'll have a days collection
    // each doc ID will be the day itself like dd-MM-yyyy
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(docID);

    String dayDoc = DateFormat('dd-MM-yyyy').format(DateTime.now());
    await userDoc
        .collection('my_day')
        .doc('data')
        .collection('days')
        .doc(dayDoc)
        .getSavy()
        .then((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        Fluttertoast.showToast(msg: tr("day_exists"));
      } else {
        await snapshot.reference.set({
          // 'proteins_calc': {},
          'nutrients': {},
        }, SetOptions(merge: true));
        To(DayDetails(day: snapshot.id));
      }
    });
  }

  Stream<QuerySnapshot> getDaysStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context).user.uid)
        .collection('my_day')
        .doc('data')
        .collection('days')
        .snapshots();
  }

  Stream<DocumentSnapshot> getBMIStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context).user.uid)
        .collection('my_day')
        .doc('data')
        .snapshots();
  }

  dayCard({required String day}) {
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
      confirmDismiss: (direction) async {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          title: context.locale.languageCode == 'ar'
              ? 'حذف اليوم'
              : 'Delete the day',
          desc: tr('sure_of_deletion'),
          btnOkOnPress: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<UserProvider>(context, listen: false).user.uid)
                .collection('my_day')
                .doc('data')
                .collection('days')
                .doc(day)
                .delete()
                .onError((error, stackTrace) => Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? 'لم نتمكن من حذف اليوم'
                          : "We couldn't delete the day",
                    ))
                .whenComplete(() => Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? 'تم حذف اليوم'
                          : 'The day has been deleted',
                    ));
          },
          btnCancelOnPress: () {},
        ).show();
        return null;
      },
      onDismissed: (direction) async {},
      child: Container(
        margin: EdgeInsets.all(15.0.sp),
        padding: EdgeInsets.all(15.0.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: kSecondaryColor!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          leading: Image.asset(
            'assets/images/calendar.png',
            height: 40.h,
            width: 40.w,
            fit: BoxFit.fill,
          ),
          title: AutoSizeText(
            DateFormat('EEEE dd MMMM', context.locale.languageCode)
                .format(DateFormat('dd-MM-yyyy').parse(day)),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            To(DayDetails(day: day));
          },
          trailing: Icon(
            context.locale.languageCode == 'ar'
                ? Icons.arrow_back_ios_new
                : Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Scaffold(
          appBar: globalAppBar(tr('my_day')),
          // appBar: globalAppBar('يومي'),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder<DocumentSnapshot>(
                stream: getBMIStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: ButtonWidget(
                        text: tr('server_error'),
                        // text: 'مشكلة في السيرفر ،العودة للصفحة السابقة',
                        onClicked: () => Navigator.pop(context),
                      ),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      !snapshot.data!.exists ||
                      snapshot.data!.data() == null ||
                      (snapshot.data!.data()! as Map)['proteins_calc'] ==
                          null ||
                      (snapshot.data!.data()! as Map)['proteins_calc']
                          .isEmpty ||
                      resetBMI) {
                    return ProteinCalculatorScreen(onSave: onSaveProteins);
                  }
                  canAdd = true;
                  return Scaffold(
                    floatingActionButton: !canAdd
                        ? null
                        : FloatingActionButton.extended(
                            onPressed: () async =>
                                await _addToday(docID: userProvider.user.uid),
                            label: Row(
                              children: [
                                const Icon(Icons.add),
                                Text(tr('add_current_day'))
                              ],
                              // children: [Icon(Icons.add), Text('إضافة اليوم الحالي')],
                            ),
                          ),
                    body: StreamBuilder<QuerySnapshot>(
                      stream: getDaysStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: ButtonWidget(
                              text: tr('server_error'),
                              // text: 'مشكلة في السيرفر ،العودة للصفحة السابقة',
                              onClicked: () => Navigator.pop(context),
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              tr('no_previous_days'),
                              // 'لا توجد أيام سابقة ، ابدأ باضافة يومك',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        List<QueryDocumentSnapshot> allDays =
                            snapshot.data?.docs ?? [];
                        Map<String, dynamic> dayData = {};
                        List<Map<String, dynamic>> validDays = [];
                        for (QueryDocumentSnapshot day in allDays) {
                          if (!day.exists || day.data() == null) continue;
                          dayData = day.data() as Map<String, dynamic>;
                          validDays.add({
                            'day': day.id,
                            // 'proteins_calc': dayData['proteins_calc'],
                            'nutrients': dayData['nutrients'],
                          });
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            vertical: 20.h,
                            horizontal: 10.w,
                          ),
                          itemCount: validDays.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () =>
                                        setState(() => resetBMI = true),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 8.0),
                                          child: Icon(
                                            Icons.refresh_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          context.locale.languageCode == 'ar'
                                              ? 'اعادة ضبط حاسبة البروتينات'
                                              : "Reset BMI",
                                          // "إضافة قسم جديد",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              );
                            }
                            return dayCard(day: validDays[index - 1]['day']);
                          },
                        );
                      },
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
