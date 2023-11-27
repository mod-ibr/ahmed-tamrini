import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/proten_calculator_provider.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../provider/ThemeProvider.dart';

class ProteinCalculatorScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> newData)? onSave;

  const ProteinCalculatorScreen({Key? key, this.onSave}) : super(key: key);

  @override
  State<ProteinCalculatorScreen> createState() =>
      _ProteinCalculatorScreenState();
}

class _ProteinCalculatorScreenState extends State<ProteinCalculatorScreen> {
  int _selectedPurpose = 0;
  int _selectedActivity = 0;
  final double _kItemExtent = 32.0;
  Gender selectedGender = Gender.Male;
  int height = 180;
  int weight = 70;
  int age = 25;

  FixedExtentScrollController? _activityController;
  FixedExtentScrollController? _purposeController;
  List<Widget> grams = List<Widget>.generate(1000, (int index) {
    return Center(
      child: Text(
        index.toString(),
      ),
    );
  });

  @override
  void initState() {
    super.initState();
    _activityController =
        FixedExtentScrollController(initialItem: _selectedActivity);
    Provider.of<ThemeProvider>(context, listen: false).loadRewardedAd();
    _purposeController =
        FixedExtentScrollController(initialItem: _selectedPurpose);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<ProteinCalculatorProvider>(navigationKey.currentState!.context,
            listen: false)
        .reset();

    Provider.of<ThemeProvider>(navigationKey.currentState!.context,
            listen: false)
        .showRewardedAd();
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(
      Widget child, FixedExtentScrollController controller, int index) {
    showCupertinoModalPopup<void>(
        context: navigationKey.currentContext!,
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback(
            /// [ScrollController] now refers to a
            /// [ListWheelScrollView] that is already mounted on the screen
            (context) => controller.jumpToItem(
              _selectedPurpose,
            ),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(tr('ok')),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: 250.sp,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ),
            ],
          );
        });
  }

  void _showActivtyDialog(
      Widget child, FixedExtentScrollController controller, int index) {
    showCupertinoModalPopup<void>(
        context: navigationKey.currentContext!,
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback(
            /// [ScrollController] now refers to a
            /// [ListWheelScrollView] that is already mounted on the screen
            (context) => controller.jumpToItem(
              _selectedActivity,
            ),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(tr('ok'))),
                    const Spacer(),
                  ],
                ),
              ),
              Container(
                height: 250.sp,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pop();

        return true;
      },
      child: Scaffold(
        persistentFooterButtons: [adBanner()],
        // navigationBar: const CupertinoNavigationBar(
        //   middle: Text('CupertinoPicker Sample'),
        // ),
        appBar: widget.onSave == null ? globalAppBar(tr('bmi')) : null,
        // appBar: globalAppBar("حاسبة البروتينات"),
        body: Consumer<ProteinCalculatorProvider>(builder: (context, _, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 40.0),
                    //   child: Divider(
                    //     color: Colors.grey,
                    //     thickness: 1,
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OurContainer(
                            onPress: () {
                              setState(() {
                                selectedGender = Gender.Male;
                              });
                              _.calculate(
                                  wight: weight,
                                  target: Target.values[_selectedPurpose],
                                  height: height,
                                  age: age,
                                  sex: selectedGender,
                                  activityLevel:
                                      ActivityLevel.values[_selectedActivity]);
                            },
                            colory: selectedGender == Gender.Male
                                ? kSecondaryColor!
                                : Theme.of(context).cardColor,
                            cardChild: GenderColumn(
                              icony: Icons.male,
                              texty: tr('male'),
                              // texty: 'ذكر',
                              colory: selectedGender == Gender.Male
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: OurContainer(
                            onPress: () {
                              setState(() {
                                selectedGender = Gender.Female;
                              });
                              _.calculate(
                                  wight: weight,
                                  target: Target.values[_selectedPurpose],
                                  height: height,
                                  age: age,
                                  sex: selectedGender,
                                  activityLevel:
                                      ActivityLevel.values[_selectedActivity]);
                            },
                            colory: selectedGender == Gender.Female
                                ? kSecondaryColor!
                                : Theme.of(context).cardColor,
                            cardChild: GenderColumn(
                              icony: Icons.female,
                              texty: tr('female'),
                              // texty: 'أنثى',
                              colory: selectedGender == Gender.Female
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    OurContainer(
                      colory: Theme.of(context).cardColor,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr('tall'),
                            // 'الطول',
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                height.toString(),
                                style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                tr('cm'),
                                // 'سم',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: kPrimaryColor,
                              inactiveTrackColor: Colors.grey,
                              thumbColor: kPrimaryColor,
                              overlayColor: kPrimaryColor.withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 20),
                            ),
                            child: Slider(
                              value: height.toDouble(),
                              min: 120,
                              max: 220,
                              onChanged: (double value) {
                                setState(() {
                                  height = value.round();
                                });
                                _.calculate(
                                    wight: weight,
                                    target: Target.values[_selectedPurpose],
                                    height: height,
                                    age: age,
                                    sex: selectedGender,
                                    activityLevel: ActivityLevel
                                        .values[_selectedActivity]);
                              },
                            ),
                          ),
                        ],
                      ),
                      onPress: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OurContainer(
                            colory: Theme.of(context).cardColor,
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tr('weight'),
                                  // "الوزن",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    // color: Colors.white,
                                  ),
                                ),
                                Text(
                                  weight.toString(),
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyFlooatingButton(
                                      myIcon: Icons.remove,
                                      onPressed: () {
                                        weight--;

                                        _.calculate(
                                            wight: weight,
                                            target:
                                                Target.values[_selectedPurpose],
                                            height: height,
                                            age: age,
                                            sex: selectedGender,
                                            activityLevel: ActivityLevel
                                                .values[_selectedActivity]);

                                        // setState(() {
                                        // });
                                      },
                                    ),
                                    MyFlooatingButton(
                                      myIcon: Icons.add,
                                      onPressed: () {
                                        weight++;
                                        _.calculate(
                                            wight: weight,
                                            target:
                                                Target.values[_selectedPurpose],
                                            height: height,
                                            age: age,
                                            sex: selectedGender,
                                            activityLevel: ActivityLevel
                                                .values[_selectedActivity]);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            onPress: () {},
                          ),
                        ),
                        Expanded(
                          child: OurContainer(
                            colory: Theme.of(context).cardColor,
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tr('age'),
                                  // "العمر",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  age.toString(),
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyFlooatingButton(
                                      myIcon: Icons.remove,
                                      onPressed: () {
                                        setState(() {
                                          age--;
                                        });
                                        _.calculate(
                                            wight: weight,
                                            target:
                                                Target.values[_selectedPurpose],
                                            height: height,
                                            age: age,
                                            sex: selectedGender,
                                            activityLevel: ActivityLevel
                                                .values[_selectedActivity]);
                                      },
                                    ),
                                    MyFlooatingButton(
                                      myIcon: Icons.add,
                                      onPressed: () {
                                        setState(() {
                                          age++;
                                        });
                                        _.calculate(
                                            wight: weight,
                                            target:
                                                Target.values[_selectedPurpose],
                                            height: height,
                                            age: age,
                                            sex: selectedGender,
                                            activityLevel: ActivityLevel
                                                .values[_selectedActivity]);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            onPress: () {},
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 200.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: kSecondaryColor!,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.5),
                              //     spreadRadius: 3,
                              //     blurRadius: 3,
                              //     offset: const Offset(
                              //         0, 3), // changes position of shadow
                              //     // changes position of shadow
                              //   ),
                              // ],
                            ),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              // Display a CupertinoPicker with list of fruits.
                              onPressed: () => _showDialog(
                                CupertinoPicker(
                                  scrollController: _purposeController,
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: false,
                                  itemExtent: _kItemExtent,
                                  // This is called when selected item is changed.
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedPurpose = selectedItem;
                                    });
                                    _.calculate(
                                        wight: weight,
                                        target: Target.values[_selectedPurpose],
                                        height: height,
                                        age: age,
                                        sex: selectedGender,
                                        activityLevel: ActivityLevel
                                            .values[_selectedActivity]);
                                  },
                                  children: List<Widget>.generate(
                                      Target.values.length, (int index) {
                                    return Center(
                                      child: Text(
                                        _.names[index],
                                        style: const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                _purposeController!,
                                _selectedPurpose,
                              ),
                              // This displays the selected fruit name.
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10.0),
                                      child: Text(
                                        _.names[_selectedPurpose],
                                        style: const TextStyle(
                                            // fontSize: 18.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(Icons.arrow_drop_down,
                                        size: 25.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 200.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: kSecondaryColor!,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.5),
                              //     spreadRadius: 3,
                              //     blurRadius: 3,
                              //     offset: const Offset(
                              //         0, 3), // changes position of shadow
                              //     // changes position of shadow
                              //   ),
                              // ],
                            ),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              // Display a CupertinoPicker with list of fruits.
                              onPressed: () => _showActivtyDialog(
                                CupertinoPicker(
                                  scrollController: _activityController,
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: false,
                                  itemExtent: _kItemExtent,
                                  // This is called when selected item is changed.
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedActivity = selectedItem;
                                    });
                                    _.calculate(
                                        wight: weight,
                                        target: Target.values[_selectedPurpose],
                                        height: height,
                                        age: age,
                                        sex: selectedGender,
                                        activityLevel: ActivityLevel
                                            .values[_selectedActivity]);
                                  },
                                  children: List<Widget>.generate(
                                      ActivityLevel.values.length, (int index) {
                                    return Center(
                                      child: Text(
                                        _.activities[index],
                                        style: const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                _activityController!,
                                _selectedActivity,
                              ),
                              // This displays the selected fruit name.
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 10.0),
                                      child: Text(
                                        _.activities[_selectedActivity],
                                        maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            // fontSize: 18.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(Icons.arrow_drop_down,
                                        size: 25.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(
                    //   height: 70.h,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          tr('nutrients'),
                          // "المغذيات",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tr('quantity'),
                          // "الكمية",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    //سعرات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              _.calories.toPrecision(2).toString(),
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              context.locale.languageCode == 'ar' ? "س" : "C",
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              _.protein.toPrecision(2).toString(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              _.fat.toPrecision(2).toString(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              _.carbs.toPrecision(2).toString(),
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
                    SizedBox(
                      height: 20.h,
                    ),
                    widget.onSave != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0.w, vertical: 10.h),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: kSecondaryColor!,
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              onPressed: () {
                                if (_selectedPurpose == 0) {
                                  Fluttertoast.showToast(
                                    msg: context.locale.languageCode == 'ar'
                                        ? 'يجب اختيار الغرض من التمرين'
                                        : 'You must choose the purpose of the exercise',
                                  );
                                  return;
                                }
                                widget.onSave!(
                                  {
                                    'calories': _.calories.toPrecision(2),
                                    'protein': _.protein.toPrecision(2),
                                    'fat': _.fat.toPrecision(2),
                                    'carbs': _.carbs.toPrecision(2),
                                  },
                                );
                                // Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 8.0),
                                    child:
                                        Icon(Icons.save, color: Colors.white),
                                  ),
                                  Text(
                                    tr('save'),
                                    // "حفظ",
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OurContainer extends StatelessWidget {
  const OurContainer(
      {super.key,
      required this.cardChild,
      required this.onPress,
      required this.colory});

  final Color colory;
  final Widget cardChild;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        // constraints:  BoxConstraints(
        //   minHeight: 100.sp,
        //   minWidth: 100.sp,
        //   maxHeight: 125.sp,
        // ),
        height: 150.sp,
        // width:150.sp,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colory,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kSecondaryColor!,
          ),
        ),
        child: cardChild,
      ),
    );
  }
}

class GenderColumn extends StatelessWidget {
  const GenderColumn(
      {super.key,
      required this.icony,
      required this.texty,
      required this.colory});

  final IconData icony;
  final String texty;
  final Color colory;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          icony,
          size: 40.sp,
          color: colory,
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          texty,
          style: TextStyle(
            // fontSize: 20.sp,
            color: colory,
          ),
          // style: kLableTaxt,
        ),
      ],
    );
  }
}

class MyFlooatingButton extends StatelessWidget {
  final IconData myIcon;
  final Function() onPressed;
  final double? radius;
  final double? size;

  const MyFlooatingButton({
    super.key,
    required this.myIcon,
    required this.onPressed,
    this.radius,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(
        width: radius ?? 25.h,
        height: radius ?? 25.h,
      ),
      fillColor: kSecondaryColor,
      shape: const CircleBorder(),
      elevation: 0,
      onPressed: onPressed,
      child: Icon(
        myIcon,
        color: Colors.white,
        size: size,
      ),
    );
  }
}
