import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class EditSUPPCategoryScreen extends StatefulWidget {
  final Supplement category;
  const EditSUPPCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<EditSUPPCategoryScreen> createState() => _EditSUPPCategoryScreenState();
}

class _EditSUPPCategoryScreenState extends State<EditSUPPCategoryScreen> {
  String? oldTitle;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.category.title!;
    oldTitle = widget.category.title;
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('edit_section')),
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
                        tr('edit_section'),
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
                          labelText: tr('section_title'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ImageUploads(
                        photoUrl: widget.category.image != null
                            ? [widget.category.image]
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
                                images.isNotEmpty) {
                              Provider.of<SupplementProvider>(context,
                                      listen: false)
                                  .editCategory(
                                      title: titleController.text,
                                      image: images.last,
                                      oldTitle: oldTitle!);
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(tr('edit_section')),
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
