import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';

import '../../provider/Upload_Image_provider.dart';
import '../../provider/trainer_provider.dart';
import '../../utils/widgets/global Widgets.dart';

class AddGalleryItemScreen extends StatefulWidget {
  final User trainer;
  const AddGalleryItemScreen({required this.trainer, Key? key})
      : super(key: key);

  @override
  State<AddGalleryItemScreen> createState() => _AddGalleryItemScreenState();
}

class _AddGalleryItemScreenState extends State<AddGalleryItemScreen> {
  File? beforeImg;

  File? afterImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(
        context.locale.languageCode == 'ar' ? "اضافة عمل" : 'Add work',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'قبل التمرين'
                      : 'Before the training',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (beforeImg != null)
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Image.file(
                          beforeImg!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                beforeImg = null;
                              });
                            },
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                addFromGalleryItems(
                    title: context.locale.languageCode == 'ar'
                        ? "إضافة صورة"
                        : "Add image",
                    icon: Icons.add_a_photo_rounded,
                    function: () async {
                      File? image = await _showPicker(context);
                      if (image != null) {
                        setState(() {
                          beforeImg = image;
                        });
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'بعد التمرين'
                      : 'After the training',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (afterImg != null)
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Image.file(
                          afterImg!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                afterImg = null;
                              });
                            },
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                addFromGalleryItems(
                    title: context.locale.languageCode == 'ar'
                        ? "إضافة صورة"
                        : "Add image",
                    icon: Icons.add_a_photo_rounded,
                    function: () async {
                      File? image = await _showPicker(context);
                      if (image != null) {
                        setState(() {
                          afterImg = image;
                        });
                      }
                    }),
                ElevatedButton(
                  onPressed: () async {
                    if (beforeImg == null) {
                      Fluttertoast.showToast(
                          msg: context.locale.languageCode == 'ar'
                              ? 'يجب ادخال صوره قبل التمرين'
                              : 'You must enter a picture before the exercise',
                          toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if (afterImg == null) {
                      Fluttertoast.showToast(
                          msg: context.locale.languageCode == 'ar'
                              ? 'يجب ادخال صوره بعد التمرين'
                              : 'You must enter a picture after the exercise',
                          toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    // add to gallery

                    try {
                      showLoaderDialog(context);
                      var images = await Provider.of<UploadProvider>(context,
                              listen: false)
                          .uploadImages([beforeImg!, afterImg!]);

                      Provider.of<TrainerProvider>(context, listen: false)
                          .addToGallery(widget.trainer, images);

                      pop();
                    } on Exception catch (e) {
                      pop();
                      Fluttertoast.showToast(msg: tr('an_error'));
                    }
                  },
                  child: Text(tr('add')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> _showPicker(context) {
    return showModalBottomSheet<File?>(
        context: context,
        builder: (BuildContext bc) {
          return Consumer<UploadProvider>(builder: (context, uploader, child) {
            return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                      leading: const Icon(Icons.video_collection),
                      title: Text(context.locale.languageCode == 'ar'
                          ? 'صورة من المعرض'
                          : 'Image from gallery'),
                      onTap: () async {
                        File? imgFile = await uploader.getImgFromGallery();
                        Navigator.of(context).pop(imgFile);
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text(
                      context.locale.languageCode == 'ar' ? 'كاميرا' : 'Camera',
                    ),
                    onTap: () async {
                      File? imgFile = await uploader.getImgFromCamera();
                      Navigator.of(context).pop(imgFile);
                    },
                  ),
                ],
              ),
            );
          });
        });
  }
}
