import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/nutritional.dart';
import 'package:tamrini/provider/nutritious_value_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../provider/ThemeProvider.dart';

const double _kItemExtent = 32.0;

class NutritiousCalcScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> newData)? onSave;

  const NutritiousCalcScreen({super.key, this.onSave});

  @override
  State<NutritiousCalcScreen> createState() => _NutritiousCalcScreenState();
}

class _NutritiousCalcScreenState extends State<NutritiousCalcScreen> {
  int _selectedMeal = 0;
  final int _baseWeight = 100;
  int _selectedWeight = 100;
  TextEditingController searchController = TextEditingController();
  String nameController = "";
  double? proteinController;
  double? carbsController;
  double? fatController;
  double? caloriesController;

  FixedExtentScrollController? _weightController;
  FixedExtentScrollController? _mealController;

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
    _weightController =
        FixedExtentScrollController(initialItem: _selectedWeight);
    _mealController = FixedExtentScrollController(initialItem: _selectedMeal);
    searchController.text = "";
    Provider.of<ThemeProvider>(context, listen: false).loadRewardedAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchController.dispose();
    _weightController!.dispose();
    _mealController!.dispose();
    // TODO : ADS

    Provider.of<ThemeProvider>(navigationKey.currentState!.context,
            listen: false)
        .showRewardedAd();

    super.dispose();
  }

  _resetControllers() {
    proteinController = null;
    carbsController = null;
    fatController = null;
    caloriesController = null;
  }

  void _showAddDialog() {
    _resetControllers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            context.locale.languageCode == 'ar'
                ? 'أضف قيمة جديدة'
                : 'Add new value',
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),

                          // isCollapsed: true,
                          labelText: context.locale.languageCode == 'ar'
                              ? 'اسم الاكلة'
                              : "Name of the food",
                          icon: Icon(Icons.fastfood_outlined),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nameController = value;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      // height: 100.h,
                      // width: 200.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                              // Allow only numbers with up to 2 decimal places
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              // isCollapsed: true,
                              labelText: tr('protein'),
                              icon: const Icon(Icons.fastfood_outlined),
                              // hintText: '0-1',
                              suffixText: context.locale.languageCode == 'ar'
                                  ? "جرام"
                                  : "Gram",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return context.locale.languageCode == 'ar'
                                    ? 'الرجاء إدخال البروتين'
                                    : 'Please enter protein';
                              }
                              // if (double.parse(value) > 1) {
                              //   return 'الرجاء إدخال قيمة صحيحة';
                              // }
                              return null;
                            },
                            // keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                proteinController = double.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                              // Allow only numbers with up to 2 decimal places
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,

                              // isCollapsed: true,
                              labelText: tr('fats'),
                              icon: Icon(Icons.fastfood_outlined),
                              // hintText: '0-1',

                              suffixText: tr('gram'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return context.locale.languageCode == 'ar'
                                    ? 'الرجاء إدخال البروتين'
                                    : 'Please enter protein';
                              }
                              // if (double.parse(value) > 1) {
                              //   return 'الرجاء إدخال قيمة صحيحة';
                              // }
                              return null;
                            },
                            // keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                fatController = double.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                              // Allow only numbers with up to 2 decimal places
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              // isCollapsed: true,
                              labelText: tr('carbs'),
                              // hintText: '0-1',
                              icon: Icon(Icons.fastfood_outlined),

                              suffixText: tr('gram'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return context.locale.languageCode == 'ar'
                                    ? 'الرجاء إدخال البروتين'
                                    : 'Please enter protein';
                              }
                              // if (double.parse(value) > 1) {
                              //   return 'الرجاء إدخال قيمة صحيحة';
                              // }
                              return null;
                            },
                            // keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                carbsController = double.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                              // Allow only numbers with up to 2 decimal places
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,

                              // isCollapsed: true,
                              labelText: tr('calories'),
                              // hintText: '0-9999',
                              icon: Icon(Icons.fastfood_outlined),

                              suffixText: context.locale.languageCode == 'ar'
                                  ? 'سعرة'
                                  : 'calorie',
                            ),
                            // keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                caloriesController = double.parse(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          actions: [
            TextButton(
              child:
                  Text(context.locale.languageCode == 'ar' ? "إدخال" : 'Enter'),
              onPressed: () {
                if (nameController.isEmpty) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال اسم الاكلة"
                          : 'Please enter the name of the dish',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (caloriesController == null || caloriesController! > 9999) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال السعرات الحرارية"
                          : ' Please enter calories',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (proteinController == null || proteinController! < 0) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال قيمة صالحة للبروتين"
                          : ' Please enter a valid value for protein',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (fatController == null || fatController! < 0) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال قيمة صالحة للدهون"
                          : 'Please enter a valid value for fat',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                if (carbsController == null || carbsController! < 0) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال قيمة صالحة للكربوهيدرات"
                          : '  Please enter a valid value for carbohydrat',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                final provider = Provider.of<NutritionalValueProvider>(
                    navigationKey.currentState!.context,
                    listen: false);
                Nutritious nutritious = Nutritious(
                  title: nameController,
                  calories: caloriesController!,
                  proteins: proteinController!,
                  fats: fatController!,
                  carbs: carbsController!,
                  classification: provider
                      .nutritionClassesList[provider.selectedClass]
                      .classification,
                  id: '',
                );

                provider.addNewNutritious(nutritious);
              },
            ),
          ],
        );
      },
    );
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showPickerDialog(Widget child, FixedExtentScrollController controller,
      int index, bool searchable) {
    showCupertinoModalPopup<void>(
        context: navigationKey.currentState!.context,
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback(

              /// [ScrollController] now refers to a
              /// [ListWheelScrollView] that is already mounted on the screen
              (context) => controller.jumpToItem(_selectedMeal));

          return ListView(
            shrinkWrap: true,
            children: [
              searchable
                  ? Material(
                      child: SizedBox(
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(tr('ok'))),
                            SizedBox(
                              width: 200.w,
                              height: 70.h,
                              child: searchBar(searchController, (s0) {
                                Provider.of<NutritionalValueProvider>(context,
                                        listen: false)
                                    .search(s0);
                                Provider.of<NutritionalValueProvider>(context,
                                            listen: false)
                                        .nutritiousList
                                        .isNotEmpty
                                    ? controller.animateToItem(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut)
                                    : null;
                                setState(() {});
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Material(),
              Container(
                height: 300.h,
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

  void _showDialog(
      Widget child, FixedExtentScrollController controller, int index) {
    showCupertinoModalPopup<void>(
        context: navigationKey.currentContext!,
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback(
            /// [ScrollController] now refers to a
            /// [ListWheelScrollView] that is already mounted on the screen
            (context) => controller.jumpToItem(
              _selectedWeight,
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
                height: 300.sp,
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
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        pop();
        // Provider.of<ThemeProvider>(context, listen: false).showRewardedAd();

        return true;
      },
      child: Consumer<NutritionalValueProvider>(
        builder: (context, _, child) {
          return Scaffold(
            persistentFooterButtons: [adBanner()],
            resizeToAvoidBottomInset: true,
            appBar: globalAppBar(
                _.nutritionClassesList[_.selectedClass].classification),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50)),
                        border: Border.all(
                          color: kSecondaryColor!,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 130.w,
                                  height: 35.sp,
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
                                    onPressed: () => _showPickerDialog(
                                        Consumer<NutritionalValueProvider>(
                                            builder: (context, _, child) {
                                      return CupertinoPicker(
                                        selectionOverlay:
                                            const CupertinoPickerDefaultSelectionOverlay(),
                                        scrollController: _mealController,
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        // This is called when selected item is changed.
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          _selectedMeal = selectedItem;

                                          setState(() {});
                                          _.calculate(
                                              nutritious: _.nutritiousList[
                                                  _selectedMeal],
                                              weight: _selectedWeight);
                                        },
                                        children: _.nutritiousList.isNotEmpty
                                            ? List<Widget>.generate(
                                                _.nutritiousList.length,
                                                (int index) {
                                                return Center(
                                                  child: GestureDetector(
                                                    onTapUp: (_) {
                                                      _mealController
                                                          ?.animateToItem(index,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              curve: Curves
                                                                  .easeInOut);
                                                      setState(() {});
                                                      pop();
                                                    },
                                                    child: AutoSizeText(
                                                      _.nutritiousList[index]
                                                          .title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                            : [
                                                Center(
                                                  child: Text(
                                                    _.nutritiousList.isEmpty
                                                        ? tr('no_results')
                                                        : _
                                                            .nutritiousList[
                                                                _selectedMeal]
                                                            .title,
                                                  ),
                                                )
                                              ],
                                      );
                                    }), _mealController!, _selectedMeal, true),
                                    // This displays the selected fruit name.
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: _.nutritiousList.isNotEmpty
                                          ? [
                                              Expanded(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                    _
                                                        .nutritiousList[
                                                            _selectedMeal]
                                                        .title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        // fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 25.sp,
                                                    color: Colors.white),
                                              ),
                                            ]
                                          : [
                                              Text(
                                                tr('pick_meal'),
                                                // "إختر الوجبة",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              ),
                                              Icon(Icons.arrow_drop_down,
                                                  size: 25.sp,
                                                  color: Colors.white),
                                            ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 130.w,
                                  height: 35.sp,
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
                                        scrollController: _weightController,
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        // This is called when selected item is changed.
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          _selectedWeight = selectedItem;
                                          _.calculate(
                                              nutritious: _.nutritiousList[
                                                  _selectedMeal],
                                              weight: _selectedWeight);
                                        },
                                        children: grams,
                                      ),
                                      _weightController!,
                                      _selectedWeight,
                                      // false,
                                    ),
                                    // This displays the selected fruit name.
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${_selectedWeight.toString()} ${tr('gram')}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 25.sp,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: 200.h,
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 20,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.01),
                                      offset: Offset(0, 1))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _.nutritiousList.isNotEmpty
                                      ? [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 60.w,
                                                child: Text(
                                                  tr('protein'),
                                                  // "بروتين",
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: _selectedWeight !=
                                                              0
                                                          ? size.width *
                                                              (_
                                                                  .nutritiousList[
                                                                      _selectedMeal]
                                                                  .proteins) /
                                                              2
                                                          : 1,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: size.width *
                                                            _selectedWeight /
                                                            2.5 *
                                                            (_
                                                                .nutritiousList[
                                                                    _selectedMeal]
                                                                .proteins) /
                                                            22000,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${(_.nutritiousList[_selectedMeal].proteins * _selectedWeight / _baseWeight).toDouble().toPrecision(1)} ${tr('gram')}",
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 60.w,
                                                child: Text(
                                                  tr('fats'),
                                                  // "دهون",
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: _selectedWeight !=
                                                              0
                                                          ? size.width *
                                                              (_
                                                                  .nutritiousList[
                                                                      _selectedMeal]
                                                                  .fats) /
                                                              2
                                                          : 1,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: size.width *
                                                            _selectedWeight /
                                                            2.5 *
                                                            (_
                                                                .nutritiousList[
                                                                    _selectedMeal]
                                                                .fats) /
                                                            22000,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${(_.nutritiousList[_selectedMeal].fats * _selectedWeight / _baseWeight).toDouble().toPrecision(3)} ${tr('gram')}",
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 60.w,
                                                child: AutoSizeText(
                                                  tr('carbs'),
                                                  // "كربوهيدرات",
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: _selectedWeight !=
                                                              0
                                                          ? size.width *
                                                              (_
                                                                  .nutritiousList[
                                                                      _selectedMeal]
                                                                  .carbs) /
                                                              2
                                                          : 1,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: size.width *
                                                            _selectedWeight /
                                                            2.5 *
                                                            (_
                                                                .nutritiousList[
                                                                    _selectedMeal]
                                                                .carbs) /
                                                            22000,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${(_.nutritiousList[_selectedMeal].carbs * _selectedWeight / _baseWeight).toPrecision(3)} ${tr('gram')}",
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 60.w,
                                                child: Text(
                                                  tr('calories'),
                                                  // "سعرات ",
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: _selectedWeight !=
                                                              0
                                                          ? size.width *
                                                              _selectedWeight /
                                                              2.2 *
                                                              (_
                                                                  .nutritiousList[
                                                                      _selectedMeal]
                                                                  .calories) /
                                                              2200
                                                          : 1,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: size.width *
                                                            _selectedWeight /
                                                            0.25 *
                                                            (_
                                                                .nutritiousList[
                                                                    _selectedMeal]
                                                                .calories) /
                                                            220000,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${(_.nutritiousList[_selectedMeal].calories * _selectedWeight / _baseWeight).toDouble().toPrecision(3)} ${context.locale.languageCode == 'ar' ? 'سعرة' : 'calorie'}",
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ]
                                      : []),
                            ),
                          ),
                          Provider.of<UserProvider>(context, listen: false)
                                  .isAdmin
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70.0),
                                  child: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            _showAddDialog();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle,
                                                color: kPrimaryColor,
                                                size: 18.h,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                tr('add_meal'),
                                                // "اضافة طعام",
                                                style:
                                                    TextStyle(fontSize: 16.sp),
                                              ),
                                            ],
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            if (_selectedMeal != -1) {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: 'تحذير',
                                                desc:
                                                    'هل انت متاكد من حذف هذا الطعام؟',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  _.deleteNutritious(
                                                      _.nutritiousList[
                                                          _selectedMeal]);
                                                  _selectedMeal = 0;
                                                  setState(() {});
                                                },
                                              ).show();
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 18.h,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                tr('delete'),
                                                // "حذف",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.onSave != null
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0.w, vertical: 10.h),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    onPressed: () {
                                      if (_.nutritiousList.isEmpty ||
                                          _.nutritiousList[_selectedMeal]
                                                  .title ==
                                              tr('pick_meal')) {
                                        Fluttertoast.showToast(
                                            msg: context.locale.languageCode ==
                                                    'ar'
                                                ? 'يجب اختيار الوجبة'
                                                : 'You must choose the meal');
                                        return;
                                      }

                                      widget.onSave!(
                                        {
                                          _.nutritiousList[_selectedMeal].title:
                                              {
                                            'grams': _selectedWeight,
                                            'calories': _
                                                .nutritiousList[_selectedMeal]
                                                .calories
                                                .toPrecision(2),
                                            'protein': _
                                                .nutritiousList[_selectedMeal]
                                                .proteins
                                                .toPrecision(2),
                                            'fat': _
                                                .nutritiousList[_selectedMeal]
                                                .fats
                                                .toPrecision(2),
                                            'carbs': _
                                                .nutritiousList[_selectedMeal]
                                                .carbs
                                                .toPrecision(2),
                                          }
                                        },
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 8.0),
                                          child: Icon(Icons.save,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          tr('save'),
                                          // "حفظ",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
