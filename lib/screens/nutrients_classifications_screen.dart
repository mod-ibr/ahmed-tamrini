import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/nutrition_classes.dart';
import 'package:tamrini/provider/nutritious_value_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/nutritious_Screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/loading_widget.dart';

import '../provider/ThemeProvider.dart';

class NutrientsClassifications extends StatefulWidget {
  final void Function(Map<String, dynamic> newData)? onSave;

  const NutrientsClassifications({super.key, this.onSave});

  @override
  State<NutrientsClassifications> createState() =>
      _NutrientsClassificationsState();
}

class _NutrientsClassificationsState extends State<NutrientsClassifications> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NutritionalValueProvider>(
        navigationKey.currentState!.context,
        listen: false);
    print(
        "************ NutritionClassesList length : ${provider.nutritionClassesList.length}");

    Provider.of<ThemeProvider>(context, listen: false).loadRewardedAd();
  }

  @override
  void dispose() {
     Provider.of<ThemeProvider>(navigationKey.currentState!.context,
            listen: false)
        .showRewardedAd();

    super.dispose();
  }

  String classNameController = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        pop();
        Provider.of<ThemeProvider>(context, listen: false).showRewardedAd();

        return true;
      },
      child: Scaffold(
        floatingActionButton:
            Provider.of<UserProvider>(context, listen: false).isAdmin
                ? FloatingActionButton.extended(
                    onPressed: () => _showAddDialog(),
                    label: Row(
                      children: [
                        const Icon(Icons.add),
                        SizedBox(width: 4.w),
                        Text(tr('add_new_category'))
                      ],
                      // children: [Icon(Icons.add), Text('إضافة تصنيف جديد')],
                    ),
                  )
                : null,
        persistentFooterButtons: [adBanner()],
        resizeToAvoidBottomInset: true,
        appBar: widget.onSave == null
            ? globalAppBar(tr('nutritional_values'))
            : null,
        // appBar: globalAppBar("القيمة الغذائية"),
        body: Consumer<NutritionalValueProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: MediaQuery.sizeOf(context).width * 0.5,
                    child: const LoadingWidget()),
              );
            }

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  AutoSizeText(
                    tr('nutrients_categories'),
                    // 'تصنيفات العناصر الغذائية',
                    style: const TextStyle(color: kPrimaryColor, fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.height * 0.7,
                    child: (provider.nutritionClassesList.isEmpty)
                        ? Center(
                            child: Text(
                              tr('no_categories'),
                              // 'لا توجد تصنيفات حالية',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.nutritionClassesList.length,
                            itemBuilder: (context, index) {
                              return Provider.of<UserProvider>(context).isAdmin
                                  ? Dismissible(
                                      key: UniqueKey(),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      direction: DismissDirection.horizontal,
                                      confirmDismiss: (direction) async {
                                        AwesomeDialog(
                                                context: navigationKey
                                                    .currentContext!,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: context.locale
                                                            .languageCode ==
                                                        'ar'
                                                    ? 'حذف التصنيف'
                                                    : 'Delete category',
                                                desc: tr('sure_of_deletion'),
                                                btnOkOnPress: () {
                                                  provider.deleteNutritiousClass(
                                                      provider.nutritionClassesList[
                                                          index]);
                                                },
                                                btnCancelOnPress: () {})
                                            .show();
                                        return null;
                                      },
                                      onDismissed: (direction) async {},
                                      child: _itemCard(
                                        nutritionClasses: provider
                                            .nutritionClassesList[index],
                                        onTap: () {
                                          provider.selectedClass = index;

                                          debugPrint(
                                              'Selected Classe : ${provider.nutritionClassesList[index]} , Class NO : ${provider.selectedClass}');
                                          // TODO: Navigate to the Class Data
                                          Provider.of<NutritionalValueProvider>(
                                                  context,
                                                  listen: false)
                                              .initiate();
                                          To(NutritiousCalcScreen(
                                              onSave: widget.onSave));
                                        },
                                      ),
                                    )
                                  : _itemCard(
                                      nutritionClasses:
                                          provider.nutritionClassesList[index],
                                      onTap: () {
                                        provider.selectedClass = index;

                                        debugPrint(
                                            'Selected Classe : ${provider.nutritionClassesList[index]} , Class NO : ${provider.selectedClass}');
                                        // TODO: Navigate to the Class Data
                                        Provider.of<NutritionalValueProvider>(
                                                context,
                                                listen: false)
                                            .initiate();
                                        To(NutritiousCalcScreen(
                                            onSave: widget.onSave));
                                      },
                                    );
                            }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemCard(
      {required Function() onTap, required NutritionClasses nutritionClasses}) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: kSecondaryColor!,
          width: 1.0,
        ),
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
        title: AutoSizeText(nutritionClasses.classification),
        onTap: onTap,
        leading: Provider.of<UserProvider>(context, listen: false).isAdmin
            ? IconButton(
                onPressed: () =>
                    _showAddDialog(nutritionClasses: nutritionClasses),
                icon: Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
        trailing: Icon(
          context.locale.languageCode == 'ar'
              ? Icons.arrow_back_ios_new
              : Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _showAddDialog({NutritionClasses? nutritionClasses}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: nutritionClasses != null
              ? Text(
                  context.locale.languageCode == 'ar'
                      ? 'تعديل تصنيف'
                      : 'Modify a category',
                )
              : Text(context.locale.languageCode == 'ar'
                  ? 'أضف تصنيف جديد'
                  : 'Add a new category'),
          content: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),

                    // isCollapsed: true,
                    labelText: (nutritionClasses != null)
                        ? nutritionClasses.classification
                        : context.locale.languageCode == 'ar'
                            ? 'اسم الصنف'
                            : 'Category name',
                    icon: const Icon(Icons.fastfood_outlined),
                  ),
                  onChanged: (value) {
                    setState(() {
                      classNameController = value;
                      print(
                          '**************** New Class Name : $classNameController');
                    });
                  },
                ),
              ),
            );
          }),
          actions: [
            TextButton(
              child:
                  Text(context.locale.languageCode == 'ar' ? "إدخال" : 'Enter'),
              onPressed: () {
                if (classNameController.isEmpty) {
                  Fluttertoast.showToast(
                      msg: context.locale.languageCode == 'ar'
                          ? "الرجاء إدخال اسم الصنف"
                          : 'Please enter the category name',
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

                if (nutritionClasses != null) {
                  nutritionClasses.classification = classNameController;
                  provider.updateNutritiousClassName(nutritionClasses);
                  print(
                      '**************** New Class Name : $classNameController');
                  print(
                      '************ From Dialog Class ID : ${nutritionClasses.id} , Class name : ${nutritionClasses.classification}');
                } else {
                  print(
                      '**************** New Class Name : $classNameController');
                  NutritionClasses nutritionClasses = NutritionClasses(
                      classification: classNameController, id: "");
                  provider.addNewNutritiousClass(nutritionClasses);
                }
                classNameController = '';
              },
            ),
          ],
        );
      },
    );
  }
}

/*

SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const AutoSizeText(
                  'تصنيفات العناصر الغذائية',
                  style: TextStyle(color: kPrimaryColor, fontSize: 30),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.7,
                  child: (provider.nutritionClassesList.isEmpty)
                      ? Center(
                          child: Text(
                            'لا توجد تصنيفات حالية',
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.nutritionClassesList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                AwesomeDialog(
                                        context: navigationKey.currentContext!,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'حذف التصنيف',
                                        desc: tr('sure_of_deletion'),
                                        btnOkOnPress: () {
                                          provider.deleteNutritiousClass(
                                              provider
                                                  .nutritionClassesList[index]);
                                        },
                                        btnCancelOnPress: () {})
                                    .show();
                                return null;
                              },
                              onDismissed: (direction) async {},
                              child: _itemCard(
                                nutritionClasses:
                                    provider.nutritionClassesList[index],
                                onTap: () {
                                  provider.selectedClass = index;

                                  debugPrint(
                                      'Selected Classe : ${provider.nutritionClassesList[index]} , Class NO : ${provider.selectedClass}');
                                  // TODO: Navigate to the Class Data
                                  Provider.of<NutritionalValueProvider>(context,
                                          listen: false)
                                      .initiate();
                                  To(const NutritiousCalcScreen());
                                },
                              ),
                            );
                          }),
                ),
              ],
            ),
          );


 */
