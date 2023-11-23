import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/home_exercise.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/home_exercise_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/regex.dart';

class AddHomeExerciseScreen extends StatefulWidget {
  final HomeExercise category;

  const AddHomeExerciseScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<AddHomeExerciseScreen> createState() => _AddHomeExerciseScreebState();
}

class _AddHomeExerciseScreebState extends State<AddHomeExerciseScreen> {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: globalAppBar(tr('add_home_exercise')),
          // appBar: globalAppBar("إضافة تمرين منزلي"),
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
                          tr('add_exercise'),
                          // 'اضافة تمرين',
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
                        const ImageUploads(),
                        TextFormField(
                          controller: youtubeUrlController,
                          decoration: InputDecoration(
                            labelText: tr('opt_youtube'),
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

                              CacheHelper.init();

                              if (titleController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty) {
                                if (youtubeUrlController.text.isNotEmpty &&
                                    RegExp(RegexPatterns
                                                .allowedYoutubeUrlFormat)
                                            .hasMatch(
                                                youtubeUrlController.text) ==
                                        false) {
                                  Fluttertoast.showToast(
                                      msg: context.locale.languageCode == 'ar'
                                          ? 'من فضلك ادخل رابط يوتيوب صحيح'
                                          : 'Please enter a valid YouTube like');

                                  return;
                                }

                                Provider.of<HomeExerciseProvider>(context,
                                        listen: false)
                                    .addExercise(
                                        title: titleController.text,
                                        images:
                                            youtubeUrlController.text.isEmpty ==
                                                    false
                                                ? [
                                                    ...images.cast<String>(),
                                                    youtubeUrlController.text
                                                  ]
                                                : images.cast<String>(),
                                        description: descriptionController.text,
                                        category: widget.category);

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
                          child: Text(tr('add_exercise')),
                          // child: const Text('إضافة تمرين'),
                        ),
                      ],
                    ),
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
