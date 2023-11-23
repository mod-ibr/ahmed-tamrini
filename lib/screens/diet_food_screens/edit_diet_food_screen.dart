import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/diet_food.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/diet_food_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class EditDietFoodScreen extends StatefulWidget {
  final DietFood dietFood;
  final String type;
  const EditDietFoodScreen(
      {Key? key, required this.dietFood, required this.type})
      : super(key: key);

  @override
  State<EditDietFoodScreen> createState() => _EditDietFoodScreebState();
}

class _EditDietFoodScreebState extends State<EditDietFoodScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    allPhotos.clear();

    allPhotos.clear();
    super.dispose();
  }

  @override
  void initState() {
    titleController.text = widget.dietFood.title;
    descriptionController.text = widget.dietFood.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(
          context.locale.languageCode == 'ar'
              ? " تعديل الأكلة"
              : "Edit the diet food",
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
              child: Form(
                onWillPop: () async {
                  allPhotos.clear();
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        context.locale.languageCode == 'ar'
                            ? " تعديل الأكلة"
                            : "Edit the diet food",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: tr('meal_name'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 50,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'تفاصيل الأكلة'
                              : "Meal's details",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ImageUploads(
                        photoUrl: widget.dietFood.assets,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);
                            var images = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFiles();

                            CacheHelper.init();

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              DietFood dietFood = DietFood(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  assets: images,
                                  date: Timestamp.fromDate(DateTime.now()),
                                  writer: widget.dietFood.writer,
                                  id: widget.dietFood.id);

                              Provider.of<DietFoodProvider>(context,
                                      listen: false)
                                  .updateMeal(dietFood, widget.type);

                              pop();
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(
                          context.locale.languageCode == 'ar'
                              ? ' تعديل أكلة الدايت'
                              : "Edit the diet food",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
