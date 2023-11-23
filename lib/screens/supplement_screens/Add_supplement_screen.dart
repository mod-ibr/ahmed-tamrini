import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AddSupplementScreen extends StatefulWidget {
  final Supplement category;
  const AddSupplementScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<AddSupplementScreen> createState() => _AddSupplementScreebState();
}

class _AddSupplementScreebState extends State<AddSupplementScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
        appBar: globalAppBar(tr('add_supplement')),
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
                        tr('add_supplement'),
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
                              ? 'اسم المكمل'
                              : 'Name of nutritional supplement',
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
                              ? 'خواص المكمل'
                              : 'Properties of nutritional supplement',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ImageUploads(),
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
                              Provider.of<SupplementProvider>(context,
                                      listen: false)
                                  .addSupplement(
                                      supplement: SupplementData(
                                        id: '',
                                        title: titleController.text,
                                        description: descriptionController.text,
                                        images: images.cast<String>(),
                                      ),
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
                        child: Text(tr('add_the_section')),
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
