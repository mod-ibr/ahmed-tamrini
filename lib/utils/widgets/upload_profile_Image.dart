// import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_cached_image/firebase_cached_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:tamrini/provider/Upload_Image_provider.dart';
// import 'package:tamrini/utils/widgets/global%20Widgets.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// import '../regex.dart';

// class ProfileImageUpload extends StatefulWidget {
 

//   const ProfileImageUpload({
//     Key? key,
   
//   }) : super(key: key);

//   @override
//   State<ProfileImageUpload> createState() => _ProfileImageUploadState();
// }

// class _ProfileImageUploadState extends State<ProfileImageUpload> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UploadProvider>(builder: (context, uploader, child) {
//       {
//         return Column(
//           children: <Widget>[
//             Provider.of<UploadProvider>(context).profileImage != null
//                 ? SizedBox(
//                     width: double.infinity,
//                     height: 100.h,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: allPhotos.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Stack(
//                             children: [
//                               Container(
//                                 clipBehavior: Clip.antiAlias,
//                                 height: 100.h,
//                                 width: 100.w,
//                                 // padding: const EdgeInsets.all(15),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(15),
//                                   ),
//                                   // border: Border.all(color: Colors.white),
//                                   // boxShadow: const [
//                                   //   BoxShadow(
//                                   //     color: Colors.black12,
//                                   //     offset: Offset(2, 2),
//                                   //     spreadRadius: 2,
//                                   //     blurRadius: 1,
//                                   //   ),
//                                   // ],
//                                 ),
//                                 child: allPhotos[index]
//                                                 .runtimeType
//                                                 .toString() ==
//                                             "String" &&
//                                         allPhotos[index].contains(RegExp(
//                                             "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)"))
//                                     ? Image(
//                                         image: FirebaseImageProvider(
//                                           FirebaseUrl(allPhotos[index]),
//                                         ),
//                                         fit: BoxFit.cover,
//                                       )

//                                     // CachedNetworkImage(imageUrl:
//                                     //         allPhotos[index],
//                                     //         fit: BoxFit.cover,
//                                     //       )
//                                     : allPhotos[index].runtimeType.toString() ==
//                                             "_File"
//                                         ? Image.file(
//                                             allPhotos[index],
//                                             fit: BoxFit.cover,
//                                           )
//                                         : allPhotos[index]
//                                                     .runtimeType
//                                                     .toString() ==
//                                                 "XFile"
//                                             ? FutureBuilder(
//                                                 future: genThumbnailFile(
//                                                     allPhotos[index].path),
//                                                 builder: (context, _) {
//                                                   if (_.hasData) {
//                                                     return _.data!;
//                                                   }
//                                                   return const Center(
//                                                     child:
//                                                         CircularProgressIndicator(),
//                                                   );
//                                                 })
//                                             : FutureBuilder(
//                                                 future: genThumbnailFile(
//                                                     allPhotos[index]),
//                                                 builder: (context, _) {
//                                                   if (_.hasData) {
//                                                     return _.data!;
//                                                   }
//                                                   return const Center(
//                                                     child:
//                                                         CircularProgressIndicator(),
//                                                   );
//                                                 }),
//                               ),
//                               Positioned(
//                                 top: 0,
//                                 left: 0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       uploader.removeImage(index);
//                                     },
//                                     child: const Icon(
//                                       Icons.delete_forever,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 : Container(
//                     height: 1,
//                   ),
//             addFromGalleryItems(
//                 title: "إضافة صور",
//                 icon: Icons.add_a_photo_rounded,
//                 function: () {
//                   _showPicker(context);
//                 }),
//           ],
//         );
//       }
//     });
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Consumer<UploadProvider>(builder: (context, uploader, child) {
//             return SafeArea(
//               child: Wrap(
//                 children: !widget.isOneImage
//                     ? <Widget>[
//                         ListTile(
//                             leading: const Icon(Icons.photo_library),
//                             title: const Text('صور من المعرض'),
//                             onTap: () {
//                               uploader.imgFromGallery();
//                               Navigator.of(context).pop();
//                             }),
//                         ListTile(
//                           leading: const Icon(Icons.photo_camera),
//                           title: const Text('صورة من الكاميرا'),
//                           onTap: () {
//                             uploader.imgFromCamera();
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         widget.isVideo
//                             ? ListTile(
//                                 leading: const Icon(Icons.video_collection),
//                                 title: const Text('فيديو من المعرض'),
//                                 onTap: () {
//                                   uploader.videoFromGallery();
//                                   Navigator.of(context).pop();
//                                 })
//                             : Container(),
//                       ]
//                     : [
//                         ListTile(
//                             leading: const Icon(Icons.video_collection),
//                             title: const Text('صورة من المعرض'),
//                             onTap: () {
//                               uploader.oneImgFromGallery();
//                               Navigator.of(context).pop();
//                             }),
//                         ListTile(
//                           leading: const Icon(Icons.photo_camera),
//                           title: const Text('Camera'),
//                           onTap: () {
//                             uploader.imgFromCamera();
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//               ),
//             );
//           });
//         });
//   }

//   Future<Widget> genThumbnailFile(String path) async {
//     final fileName = await VideoThumbnail.thumbnailFile(
//       video: path,
//       thumbnailPath: (await getTemporaryDirectory()).path,
//       imageFormat: ImageFormat.PNG,
//       maxHeight:
//           100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//       quality: 45,
//     );
//     File file = File(fileName!);
//     setState(() {});

//     return Image.file(
//       file,
//       fit: BoxFit.cover,
//     );
//   }

//   // getTemporaryDirectory() async {
//   //   Directory tempDir = await getTemporaryDirectory();
//   //   String tempPath = tempDir.path;
//   //
//   //   Directory appDocDir = await getApplicationDocumentsDirectory();
//   //   String appDocPath = appDocDir.path;
//   //   return await getTemporaryDirectory();
//   // }

//   // Future<void> genThumbnailFile(String path) async {
//   //   // final thum = await VideoCompress.getFileThumbnail(path,
//   //   //     quality: 50, // default(100)
//   //   //     position: -1 // default(-1)
//   //   //     );
//   //   _thumbnailFile = await VideoCompress.getFileThumbnail(path);
//   //
//   //   setState(() {});
//   // }
//   //
//   // Widget _buildThumbnail() {
//   //   if (_thumbnailFile != null) {
//   //     return Container(
//   //       padding: EdgeInsets.all(20.0),
//   //       child: Image(image: FileImage(_thumbnailFile!), fit: BoxFit.cover),
//   //     );
//   //   }
//   //   return Container();
//   // }
// }
