import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AddSupplementCategoryScreen extends StatefulWidget {
  const AddSupplementCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddSupplementCategoryScreen> createState() =>
      _AddSupplementCategoryScreebState();
}

class _AddSupplementCategoryScreebState
    extends State<AddSupplementCategoryScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('add_section')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: MediaQuery.of(context).size.height- 500,
            width: double.infinity,
            // width: double.infinity,
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
                          ? 'إضافة قسم جديد'
                          : 'Add new section',
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
                        labelText: context.locale.languageCode == 'ar'
                            ? 'اسم القسم'
                            : 'Section name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ImageUploads(
                      isOneImage: true,
                      isVideo: false,
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
                              images.isNotEmpty) {
                            Provider.of<SupplementProvider>(context,
                                    listen: false)
                                .addCategory(
                              title: titleController.text,
                              image: images[0],
                            );

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
                      child: Text(tr('add_the_section')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
