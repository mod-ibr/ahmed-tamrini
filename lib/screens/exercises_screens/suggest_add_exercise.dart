import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../provider/exercise_provider.dart';
import '../../provider/home_exercise_provider.dart';

class SuggestAddExercise extends StatefulWidget {
  final String categoryTitle;
  final bool homeExercise;

  const SuggestAddExercise({
    super.key,
    required this.categoryTitle,
    this.homeExercise = false,
  });

  @override
  State<SuggestAddExercise> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<SuggestAddExercise> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String home() {
    String homeStr =
        context.locale.languageCode == 'ar' ? ' (منزلي) ' : ' (home) ';
    return widget.homeExercise ? homeStr : '';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    allPhotos.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('suggest_exercise')),
        // appBar: globalAppBar("اقتراح إضافة تمرين"),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${tr('suggest_exercise')} ${home()}',
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
                          labelText: tr('exercise_title'),
                          // labelText: 'اسم التمرين',
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
                          labelText: tr('exercise_desc'),
                          // labelText: 'وصف التمرين',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            showLoaderDialog(context);

                            CacheHelper.init();

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              if (!widget.homeExercise) {
                                // normal exercise
                                Provider.of<ExerciseProvider>(context,
                                        listen: false)
                                    .suggestExercise(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  categoryTitle: widget.categoryTitle,
                                );
                              } else {
                                // home exercise
                                Provider.of<HomeExerciseProvider>(context,
                                        listen: false)
                                    .suggestExercise(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  categoryTitle: widget.categoryTitle,
                                );
                              }
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(tr('suggest_exercise')),
                        // child: const Text('اقتراح إضافة تمرين'),
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
