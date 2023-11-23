import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../helper_functions.dart';
import '../regex.dart';

class ImageUploads extends StatefulWidget {
  final List? photoUrl;
  final bool isOneImage;
  final bool isVideo;

  const ImageUploads(
      {Key? key, this.photoUrl, this.isOneImage = false, this.isVideo = true})
      : super(key: key);

  @override
  State<ImageUploads> createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  @override
  void initState() {
    allPhotos.clear();
    if (widget.photoUrl != null) {
      debugPrint("pre : ${widget.photoUrl.runtimeType}");
      allPhotos += widget.photoUrl!;
      allPhotos.removeWhere((photo) =>
          RegExp(RegexPatterns.allowedYoutubeUrlFormat).hasMatch(photo) ==
          true);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadProvider>(builder: (context, uploader, child) {
      {
        return Column(
          children: <Widget>[
            allPhotos.isNotEmpty || widget.photoUrl != null
                ? SizedBox(
                    width: double.infinity,
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allPhotos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                height: 100.h,
                                width: 100.w,
                                // padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: allPhotos[index]
                                                .runtimeType
                                                .toString() ==
                                            "String" &&
                                        allPhotos[index].contains(RegExp(
                                            "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)"))
                                    ? Image(
                                        image: HelperFunctions
                                            .ourFirebaseImageProvider(
                                          url: allPhotos[index],
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : allPhotos[index].runtimeType.toString() ==
                                            "_File"
                                        ? Image.file(
                                            allPhotos[index],
                                            fit: BoxFit.cover,
                                          )
                                        : allPhotos[index]
                                                    .runtimeType
                                                    .toString() ==
                                                "XFile"
                                            ? FutureBuilder(
                                                future: genThumbnailFile(
                                                    allPhotos[index].path),
                                                builder: (context, _) {
                                                  if (_.hasData) {
                                                    return _.data!;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                })
                                            : FutureBuilder(
                                                future: genThumbnailFile(
                                                    allPhotos[index]),
                                                builder: (context, _) {
                                                  if (_.hasData) {
                                                    return _.data!;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: GestureDetector(
                                    onTap: () {
                                      uploader.removeImage(index);
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
                        );
                      },
                    ),
                  )
                : Container(
                    height: 1,
                  ),
            addFromGalleryItems(
                title: context.locale.languageCode == 'ar'
                    ? "إضافة صور"
                    : "Add images",
                // title: "إضافة صور",
                icon: Icons.add_a_photo_rounded,
                function: () {
                  _showPicker(context);
                }),
          ],
        );
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Consumer<UploadProvider>(builder: (context, uploader, child) {
            return SafeArea(
              child: Wrap(
                children: !widget.isOneImage
                    ? <Widget>[
                        ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: Text(context.locale.languageCode == 'ar'
                                ? 'صور من المعرض'
                                : 'Images from gallery'),
                            onTap: () {
                              uploader.imgFromGallery();
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: Text(context.locale.languageCode == 'ar'
                              ? 'صورة من الكاميرا'
                              : 'Photo from camera'),
                          onTap: () {
                            uploader.imgFromCamera();
                            Navigator.of(context).pop();
                          },
                        ),
                        widget.isVideo
                            ? ListTile(
                                leading: const Icon(Icons.video_collection),
                                title: Text(context.locale.languageCode == 'ar'
                                    ? 'فيديو من المعرض'
                                    : 'Videos from gallery'),
                                onTap: () {
                                  uploader.videoFromGallery();
                                  Navigator.of(context).pop();
                                })
                            : Container(),
                      ]
                    : [
                        ListTile(
                            leading: const Icon(Icons.video_collection),
                            title: Text(context.locale.languageCode == 'ar'
                                ? 'صورة من المعرض'
                                : 'Image from gallery'),
                            onTap: () {
                              uploader.oneImgFromGallery();
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: Text(
                            context.locale.languageCode == 'ar'
                                ? 'كاميرا'
                                : 'Camera',
                          ),
                          onTap: () {
                            uploader.imgFromCamera();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
              ),
            );
          });
        });
  }

  Future<Widget> genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 100,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 45,
    );
    File file = File(fileName!);
    setState(() {});

    return Image.file(
      file,
      fit: BoxFit.cover,
    );
  }

// getTemporaryDirectory() async {
//   Directory tempDir = await getTemporaryDirectory();
//   String tempPath = tempDir.path;
//
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String appDocPath = appDocDir.path;
//   return await getTemporaryDirectory();
// }

// Future<void> genThumbnailFile(String path) async {
//   // final thum = await VideoCompress.getFileThumbnail(path,
//   //     quality: 50, // default(100)
//   //     position: -1 // default(-1)
//   //     );
//   _thumbnailFile = await VideoCompress.getFileThumbnail(path);
//
//   setState(() {});
// }
//
// Widget _buildThumbnail() {
//   if (_thumbnailFile != null) {
//     return Container(
//       padding: EdgeInsets.all(20.0),
//       child: Image(image: FileImage(_thumbnailFile!), fit: BoxFit.cover),
//     );
//   }
//   return Container();
// }
}
