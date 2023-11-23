import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/regex.dart';

class EditExerciseScreen extends StatefulWidget {
  final ExerciseData exercise;
  final Exercise categoryID;

  const EditExerciseScreen(
      {Key? key, required this.exercise, required this.categoryID})
      : super(key: key);

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreebState();
}

class _EditExerciseScreebState extends State<EditExerciseScreen> {
  String? oldTitle;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController youtubeUrlController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    youtubeUrlController.dispose();
    allPhotos.clear();

    super.dispose();
  }

  @override
  void initState() {
    titleController.text = widget.exercise.title!;
    descriptionController.text = widget.exercise.description!;
    super.initState();
    oldTitle = widget.exercise.title;
    if (widget.exercise.assets?.isNotEmpty == true) {
      for (var asset in widget.exercise.assets!) {
        if (RegExp(RegexPatterns.allowedYoutubeUrlFormat).hasMatch(asset) ==
            true) {
          youtubeUrlController.text = asset;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('edit_exercise')),
        // appBar: globalAppBar("تعديل التمرين"),
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
                        tr('edit_exercise'),
                        // 'تعديل التمرين',
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
                          // labelText: 'عنوان التمرين',
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
                      ImageUploads(
                        photoUrl: widget.exercise.assets != null
                            ? widget.exercise.assets!
                            : null,
                      ),
                      TextFormField(
                        controller: youtubeUrlController,
                        decoration: InputDecoration(
                          labelText: tr('opt_youtube'),
                          // labelText: 'رابط يوتيوب (اختياري)',
                          border: const OutlineInputBorder(),
                        ),
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

                            print(images);

                            CacheHelper.init();

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              if (youtubeUrlController.text.isNotEmpty &&
                                  RegExp(RegexPatterns.allowedYoutubeUrlFormat)
                                          .hasMatch(
                                              youtubeUrlController.text) ==
                                      false) {
                                Fluttertoast.showToast(
                                    msg: context.locale.languageCode == 'ar'
                                        ? 'من فضلك ادخل رابط يوتيوب صحيح'
                                        : 'Please enter a valid YouTube like');

                                return;
                              }

                              Provider.of<ExerciseProvider>(context,
                                      listen: false)
                                  .editExercise(
                                title: titleController.text,
                                catID: widget.categoryID.id,
                                images:
                                    youtubeUrlController.text.isEmpty == false
                                        ? [
                                            ...images.cast<String>(),
                                            youtubeUrlController.text
                                          ]
                                        : images.cast<String>(),
                                description: descriptionController.text,
                                id: widget.exercise.id!,
                              );
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(tr('edit_exercise')),
                        // child: const Text('تعديل التمرين'),
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
