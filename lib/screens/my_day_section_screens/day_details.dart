import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';

import '../../provider/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/button_widget.dart';
import '../../utils/widgets/global Widgets.dart';
import '../nutrients_classifications_screen.dart';

class DayDetails extends StatefulWidget {
  final String day;

  const DayDetails({super.key, required this.day});

  @override
  State<DayDetails> createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  Map<String, dynamic> proteins = {};
  Map<String, dynamic> nutrients = {};
  bool addingMeal = false;

  // onSaveProteins(Map<String, dynamic> newData) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Provider.of<UserProvider>(context, listen: false).user.uid)
  //       .collection('days')
  //       .doc(widget.day)
  //       .set({'proteins_calc': newData}, SetOptions(merge: true));
  // }

  onSaveNutrients(Map<String, dynamic> newData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context, listen: false).user.uid)
        .collection('my_day')
        .doc('data')
        .collection('days')
        .doc(widget.day)
        .set({'nutrients': newData}, SetOptions(merge: true));
    setState(() => addingMeal = false);
  }

  removeMeal({required String title}) async {
    DocumentReference mealRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context, listen: false).user.uid)
        .collection('my_day')
        .doc('data')
        .collection('days')
        .doc(widget.day);

    // Fetch the current data from Firestore
    final mealDocSnapshot = await mealRef.get();

    if (mealDocSnapshot.exists) {
      // Get the current nutrients map from the document data
      final nutrientsMap = (mealDocSnapshot.data() as Map?)?['nutrients'] ?? {};

      // Check if the specified mealTitle exists in the nutrients map
      if (nutrientsMap.containsKey(title)) {
        // Create a copy of the nutrients map without the specified meal
        nutrientsMap.remove(title);

        // Update the document with the modified nutrients map
        await mealRef.update({'nutrients': nutrientsMap});
      } else {
        Fluttertoast.showToast(
          msg: context.locale.languageCode == 'ar'
              ? 'لم نجد الوجبة'
              : "We couldn't find the meal",
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: context.locale.languageCode == 'ar'
            ? 'لم نجد بيانات اليوم'
            : "We found no data today",
      );
    }
  }

  double getMyNeeds({required String type}) {
    double bodyNeed = proteins[type] ?? 0;
    double eatenMeals = nutrients.values.fold<double>(
        0.0,
        (double accumulator, nutrients) =>
            accumulator + (nutrients[type] ?? 0));
    return (bodyNeed - eatenMeals).toPrecision(2);
  }

  Stream<DocumentSnapshot> getBMIStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context).user.uid)
        .collection('my_day')
        .doc('data')
        .snapshots();
  }

  Stream<DocumentSnapshot> getDayStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<UserProvider>(context).user.uid)
        .collection('my_day')
        .doc('data')
        .collection('days')
        .doc(widget.day)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return SizedBox(
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
                    (snapshot.data!.data()! as Map)['proteins_calc'] == null ||
                    (snapshot.data!.data()! as Map)['proteins_calc'].isEmpty) {
                  return Center(
                    child: ButtonWidget(
                      text: context.locale.languageCode == 'ar'
                          ? 'بيانات حاسبة البروتينات مفقودة، العوده للصفحة السابقة للاضافة'
                          : 'BMI data is missing, go to previous page to add it',
                      onClicked: () => Navigator.pop(context),
                    ),
                  );
                }
                proteins = (snapshot.data!.data()! as Map)['proteins_calc'];
                return StreamBuilder<DocumentSnapshot>(
                  stream: getDayStream(),
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
                    if (snapshot.data == null ||
                        !snapshot.data!.exists ||
                        snapshot.data!.data() == null ||
                        (snapshot.data!.data()! as Map).isEmpty) {
                      return Center(
                        child: ButtonWidget(
                          text: tr('day_error'),
                          // text: 'مشكلة في بيانات اليوم ، محاولة الاصلاح',
                          onClicked: () async {
                            DocumentReference userDoc = FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user.uid);

                            await userDoc
                                .collection('my_day')
                                .doc('data')
                                .collection('days')
                                .doc(widget.day)
                                .getSavy()
                                .then((snapshot) {
                              snapshot.reference.set({
                                // 'proteins_calc': {},
                                'nutrients': {},
                              }, SetOptions(merge: true));
                            });
                          },
                        ),
                      );
                    } else {
                      Map<String, dynamic> dayData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      // proteins = dayData['proteins_calc'];
                      nutrients = dayData['nutrients'];
                      return Scaffold(
                        appBar: globalAppBar(DateFormat(
                                'EEEE dd MMMM', context.locale.languageCode)
                            .format(
                                DateFormat('dd-MM-yyyy').parse(widget.day))),
                        body: StatefulBuilder(
                          builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       To(ProteinCalculatorScreen(
                                  //         onSave: onSaveProteins,
                                  //       ));
                                  //     },
                                  //     child: Container(
                                  //       decoration: const BoxDecoration(
                                  //         image: DecorationImage(
                                  //           image: AssetImage(
                                  //               "assets/images/protien.jpg"),
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  //       ),
                                  //       constraints: BoxConstraints(
                                  //         minHeight: 100.h,
                                  //         maxHeight: 200.h,
                                  //         maxWidth: double.infinity,
                                  //         minWidth: double.infinity,
                                  //       ),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           tr('bmi'),
                                  //           // "حاسبة البروتينات",
                                  //           style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontSize: 30.sp,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       To(NutrientsClassifications(
                                  //           onSave: onSaveNutrients));
                                  //     },
                                  //     child: Container(
                                  //       decoration: const BoxDecoration(
                                  //         image: DecorationImage(
                                  //           image: AssetImage(
                                  //               "assets/images/nutiritious.jpg"),
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  //       ),
                                  //       constraints: BoxConstraints(
                                  //         minHeight: 100.h,
                                  //         maxHeight: 200.h,
                                  //         maxWidth: double.infinity,
                                  //         minWidth: double.infinity,
                                  //       ),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           tr('nutritional_values'),
                                  //           // "القيم الغذائية",
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 30.sp,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  nutrients.isEmpty || addingMeal
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: NutrientsClassifications(
                                              onSave: onSaveNutrients),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 20),
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              color: kSecondaryColor!,
                                              onPressed: () => setState(
                                                  () => addingMeal = true),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(end: 8.0),
                                                    child: Icon(
                                                      Icons.add_circle,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    context.locale
                                                                .languageCode ==
                                                            'ar'
                                                        ? 'اضافة أكلة'
                                                        : 'Add meal',
                                                    // "إضافة قسم جديد",
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                        ),
                                  // SizedBox(height: 25.h),
                                  proteins.isEmpty || nutrients.isEmpty
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.all(12.sp),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            border: Border.all(
                                                color: kSecondaryColor!),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 20.w,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${tr('rest_of_needs')}:",
                                                style: TextStyle(
                                                  // color: Colors.white,
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              //سعرات
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('calories'),
                                                    // "سعرات",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getMyNeeds(
                                                                type:
                                                                    'calories')
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'calories') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        context.locale
                                                                    .languageCode ==
                                                                'ar'
                                                            ? "ك"
                                                            : "k",
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'calories') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //بروتين
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('protein'),
                                                    // "بروتين",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getMyNeeds(
                                                                type: 'protein')
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'protein') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'protein') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //دهون
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('fats'),
                                                    // "دهون",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getMyNeeds(type: 'fat')
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'fat') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'fat') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //كربوهيدرات
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('carbs'),
                                                    // "كربوهيدرات",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getMyNeeds(
                                                                type: 'carbs')
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'carbs') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          color: getMyNeeds(
                                                                      type:
                                                                          'carbs') <
                                                                  0
                                                              ? Colors.red
                                                              : null,
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  // proteins.isEmpty
                                  proteins.isEmpty || nutrients.isEmpty
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.all(12.sp),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            border: Border.all(
                                                color: kSecondaryColor!),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 20.w,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${tr('bmi')}:",
                                                // "حاسبة البروتينات:",
                                                style: TextStyle(
                                                  // color: Colors.white,
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              //سعرات
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('calories'),
                                                    // "سعرات",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        proteins['calories']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        context.locale
                                                                    .languageCode ==
                                                                'ar'
                                                            ? "ك"
                                                            : "k",
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //بروتين
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('protein'),
                                                    // "بروتين",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        proteins['protein']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //دهون
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('fats'),
                                                    // "دهون",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        proteins['fat']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //كربوهيدرات
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    tr('carbs'),
                                                    // "كربوهيدرات",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        proteins['carbs']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        tr('gram'),
                                                        // "جم",
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  nutrients.isEmpty
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.all(12.sp),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            border: Border.all(
                                                color: kSecondaryColor!),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 20.w,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${tr('meals')}:",
                                                style: TextStyle(
                                                  // color: Colors.white,
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                tr('swipe_to_delete'),
                                                style: TextStyle(
                                                  // color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              ...List.generate(
                                                nutrients.length,
                                                (index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.h),
                                                    child: Dismissible(
                                                      key: UniqueKey(),
                                                      background: Container(
                                                        color: Colors.red,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      secondaryBackground:
                                                          Container(
                                                        color: Colors.red,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      direction:
                                                          DismissDirection
                                                              .horizontal,
                                                      confirmDismiss:
                                                          (direction) async {
                                                        AwesomeDialog(
                                                          context: navigationKey
                                                              .currentContext!,
                                                          dialogType: DialogType
                                                              .warning,
                                                          animType: AnimType
                                                              .bottomSlide,
                                                          title: context.locale
                                                                      .languageCode ==
                                                                  'ar'
                                                              ? 'حذف الوجبة'
                                                              : 'Delete the meal',
                                                          desc: tr(
                                                              'sure_of_deletion'),
                                                          btnOkOnPress: () =>
                                                              removeMeal(
                                                                  title: nutrients
                                                                      .keys
                                                                      .toList()[
                                                                          index]
                                                                      .toString()),
                                                          btnCancelOnPress:
                                                              () {},
                                                        ).show();
                                                        return null;
                                                      },
                                                      onDismissed:
                                                          (direction) async {},
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            nutrients.keys
                                                                .toList()[index]
                                                                .toString(),
                                                            style: TextStyle(
                                                              // color: Colors.white,
                                                              fontSize: 25.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          //جرام
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                context.locale
                                                                            .languageCode ==
                                                                        'ar'
                                                                    ? "جرام"
                                                                    : "Grams",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    nutrients[nutrients
                                                                            .keys
                                                                            .toList()[index]]['grams']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    tr('gram'),
                                                                    // "جم",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),

                                                          //سعرات
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                tr('calories'),
                                                                // "سعرات",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    nutrients[nutrients
                                                                            .keys
                                                                            .toList()[index]]['calories']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    context.locale.languageCode ==
                                                                            'ar'
                                                                        ? "ك"
                                                                        : "k",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          //بروتين
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                tr('protein'),
                                                                // "بروتين",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    nutrients[nutrients
                                                                            .keys
                                                                            .toList()[index]]['protein']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    tr('gram'),
                                                                    // "جم",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          //دهون
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                tr('fats'),
                                                                // "دهون",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    nutrients[nutrients
                                                                            .keys
                                                                            .toList()[index]]['fat']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    tr('gram'),
                                                                    // "جم",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          //كربوهيدرات
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                tr('carbs'),
                                                                // "كربوهيدرات",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    nutrients[nutrients
                                                                            .keys
                                                                            .toList()[index]]['carbs']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    tr('gram'),
                                                                    // "جم",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              }),
        );
      },
    );
  }
}
