import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/utils/helper_functions.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class TrainerRequestScreen2 extends StatefulWidget {
  final User user;

  const TrainerRequestScreen2({Key? key, required this.user}) : super(key: key);

  @override
  State<TrainerRequestScreen2> createState() => _TrainerRequestScreen2State();
}

class _TrainerRequestScreen2State extends State<TrainerRequestScreen2> {
  late final descriptionController;
  late final contact1Controller;
  late final contact2Controller;
  late final contact3Controller;
  late final priceController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<TextFieldModel> _list;
  int? _selectedItem;
  late int _nextItem;
  File? gymImage;

  @override
  void dispose() {
    descriptionController.dispose();
    allPhotos.clear();

    contact1Controller.dispose();
    contact2Controller.dispose();
    contact3Controller.dispose();
    priceController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController(
        text: (widget.user.role == 'captain') ? widget.user.description : null);

    contact1Controller = TextEditingController(
        text:
            (widget.user.role == 'captain') ? widget.user.contacts![1] : null);
    contact2Controller = TextEditingController(
        text:
            (widget.user.role == 'captain') ? widget.user.contacts![2] : null);
    contact3Controller = TextEditingController(
        text:
            (widget.user.role == 'captain') ? widget.user.contacts![3] : null);
    priceController = TextEditingController(
        text: (widget.user.role == 'captain')
            ? widget.user.price.toString()
            : null);
    _list = ListModel<TextFieldModel>(
      listKey: _listKey,
      initialItems: <TextFieldModel>[
        TextFieldModel(controller: TextEditingController())
      ],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = _list.length;
  }

  Widget _buildRemovedItem(
      TextFieldModel item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index = _selectedItem ?? _list.length;
    _list.insert(index, TextFieldModel(controller: TextEditingController()));
  }

  // Remove the selected item from the list model.
  void remove(int index) {
    _list.removeAt(index);

    setState(() {
      _selectedItem = null;
    });
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          remove(index);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        appBar: globalAppBar((widget.user.role != 'captain')
            ? tr('subscribe_as_trainer')
            : context.locale.languageCode == 'ar'
                ? "تحديث بيانات المدرب"
                : "Update Trainer data"),
        // appBar: globalAppBar("طلب اشتراك كمدرب"),
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
                      Text(
                        context.locale.languageCode == 'ar'
                            ? 'بياناتك'
                            : 'Your data',
                        // 'بياناتك',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                              ? 'انجازاتك'
                              : 'Your achievements',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'السعر في الشهر (د.ع)'
                              : 'Monthly subscription price (IQD)',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const ImageUploads(
                      //   isOneImage: true,
                      //   isVideo: false,
                      // ),
                      if (gymImage != null || (widget.user.gymImage != null))
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
                              child: (widget.user.role != 'captain')
                                  ? Image.file(
                                      gymImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image(
                                      image: HelperFunctions
                                          .ourFirebaseImageProvider(
                                        url: widget.user.gymImage![0],
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                            (widget.user.role != 'captain')
                                ? Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gymImage = null;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
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
                                gymImage = image;
                              });
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        context.locale.languageCode == 'ar'
                            ? 'بيانات التواصل'
                            : 'Contact details',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: contact1Controller,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'فيسبوك'
                              : 'Facebook',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: contact2Controller,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'تويتر'
                              : 'Twitter',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: contact3Controller,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'انستجرام'
                              : 'Instagram',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        context.locale.languageCode == 'ar'
                            ? 'الأسئلة المطلوبه من المشترك'
                            : 'Required questions from trainee',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AnimatedList(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          initialItemCount: _list.length,
                          key: _listKey,
                          itemBuilder: (context, index, animation) {
                            return _buildItem(context, index, animation);
                          }),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            _insert();
                          },
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.locale.languageCode == 'ar'
                                    ? 'إضافة سؤال'
                                    : 'Add question',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ],
                          )),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);
                            log("descriptionController.text : ${descriptionController.text}");
                            log("priceController.text : ${priceController.text}");
                            log("_list.length : ${_list.length}");
                            if (descriptionController.text.isNotEmpty &&
                                priceController.text.isNotEmpty &&
                                (gymImage != null ||
                                    (widget.user.gymImage != null &&
                                        widget.user.gymImage!.isNotEmpty)) &&
                                _list.length > 0) {
                              var images = (widget.user.role != 'captain')
                                  ? await Provider.of<UploadProvider>(context,
                                          listen: false)
                                      .uploadImages([gymImage!])
                                  : widget.user.gymImage;

                              var questions = _list._items
                                  .map((e) => e.controller.text)
                                  .where((element) => element.isNotEmpty)
                                  .toList();
                              //! Merge Trainer data with user data
                              widget.user.price =
                                  int.parse(priceController.text);
                              widget.user.description =
                                  descriptionController.text;
                              widget.user.contacts = [
                                widget.user.phone,
                                (contact1Controller.text.isNotEmpty)
                                    ? contact1Controller.text
                                    : "",
                                (contact2Controller.text.isNotEmpty)
                                    ? contact2Controller.text
                                    : "",
                                (contact3Controller.text.isNotEmpty)
                                    ? contact3Controller.text
                                    : "",
                              ];
                              widget.user.questions = questions;
                              widget.user.gymImage = images;

                              // Trainer trainer = Trainer(
                              //   name: widget.user.name,
                              //   price: int.parse(priceController.text),
                              //   image: images[0],
                              //   description: descriptionController.text,
                              //   gender: widget.user.gender,
                              //   contacts: [
                              //     widget.user.phone,
                              //     contact1Controller.text,
                              //     contact2Controller.text,
                              //     contact3Controller.text,
                              //   ],
                              //   questions: questions,
                              // );

                              TrainerProvider trainerProvider =
                                  Provider.of<TrainerProvider>(
                                      navigationKey.currentContext!,
                                      listen: false);

                              (widget.user.role != 'captain')
                                  ? trainerProvider
                                      .subscribeAsTrainer(widget.user)
                                  : trainerProvider
                                      .updateTrainerData(widget.user);
                              // pop();
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
                            ? 'ارسال'
                            : 'Send'),
                      ),
                      const SizedBox(
                        height: 50,
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
                          : 'Photo from gallery'),
                      // title: const Text('صورة من المعرض'),
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

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    this.selected = false,
    required this.animation,
    required this.item,
  });

  final Animation<double> animation;
  final VoidCallback? onTap;
  final TextFieldModel item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headlineMedium!;
    if (selected) {
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        child: SizedBox(
          height: 80.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: item.controller,
                  decoration: InputDecoration(
                    labelText: context.locale.languageCode == 'ar'
                        ? 'السؤال'
                        : 'Question',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                    onPressed: onTap,
                    icon: const Icon(
                      Ionicons.remove,
                      color: Colors.red,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldModel {
  TextFieldModel({
    required this.controller,
  });

  final TextEditingController controller;
}
