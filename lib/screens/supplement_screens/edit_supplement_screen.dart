import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class EditSupplementScreen extends StatefulWidget {
  final SupplementData supplement;
  final Supplement category;
  const EditSupplementScreen(
      {Key? key, required this.supplement, required this.category})
      : super(key: key);

  @override
  State<EditSupplementScreen> createState() => _EditSupplementScreebState();
}

class _EditSupplementScreebState extends State<EditSupplementScreen> {
  String? oldTitle;
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
  void initState() {
    titleController.text = widget.supplement.title!;
    descriptionController.text = widget.supplement.description!;
    super.initState();
    oldTitle = widget.supplement.title;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(context.locale.languageCode == 'ar'
            ? "تعديل المكمل الغذائي"
            : 'Adjustment of dietary supplement'),
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
                        context.locale.languageCode == 'ar'
                            ? "تعديل المكمل الغذائي"
                            : 'Adjustment of dietary supplement',
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
                              ? 'عنوان المكمل الغذائي'
                              : 'Address of dietary supplement',
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
                      ImageUploads(
                        photoUrl: widget.supplement.images != null
                            ? widget.supplement.images!
                            : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            var images = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFiles();

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              Provider.of<SupplementProvider>(context,
                                      listen: false)
                                  .editSupplement(
                                category: widget.category,
                                supplement: SupplementData(
                                    id: widget.supplement.id,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    images: images.cast<String>()),
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
                        child: Text(context.locale.languageCode == 'ar'
                            ? "تعديل المكمل الغذائي"
                            : 'Adjustment of dietary supplement'),
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
