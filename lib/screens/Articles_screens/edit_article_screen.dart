import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/article.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/artical_provider.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class EditArticlesScreen extends StatefulWidget {
  final Article article;
  final String? type;
  const EditArticlesScreen({Key? key, required this.article, this.type})
      : super(key: key);

  @override
  State<EditArticlesScreen> createState() => _EditArticlesScreenState();
}

class _EditArticlesScreenState extends State<EditArticlesScreen> {
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
    titleController.text = widget.article.title!;
    descriptionController.text = widget.article.body!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(context.locale.languageCode == 'ar'
            ? " تعديل المقال"
            : "Edit the article"),
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
                            ? 'تعديل المقال'
                            : "Edit the article",
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
                              ? 'عنوان المقال'
                              : "Article's title",
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
                              ? 'المقال'
                              : "The article",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ImageUploads(
                        photoUrl: widget.article.image!,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);

                            print("article id: ${widget.article.id}");

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              var images = await Provider.of<UploadProvider>(
                                      context,
                                      listen: false)
                                  .uploadFiles();

                              print(images);

                              Article article = Article(
                                  title: titleController.text,
                                  body: descriptionController.text,
                                  image: images,
                                  date: Timestamp.fromDate(DateTime.now()),
                                  writer: widget.article.writer,
                                  id: widget.article.id);
                              pop();
                              Provider.of<ArticleProvider>(context,
                                      listen: false)
                                  .updateArticle(article, widget.type!);
                            } else {
                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            // pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(context.locale.languageCode == 'ar'
                            ? ' تعديل المقال'
                            : "Edit the article"),
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
