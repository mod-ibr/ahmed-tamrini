import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/map_screen.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class EditGymScreen extends StatefulWidget {
  final Gym gym;

  const EditGymScreen({
    Key? key,
    required this.gym,
  }) : super(key: key);

  @override
  State<EditGymScreen> createState() => _EditGymScreenState();
}

class _EditGymScreenState extends State<EditGymScreen> {
  String? oldTitle;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  MapScreen? mapPicker;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    allPhotos.clear();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titleController.text = widget.gym.name;
    descriptionController.text = widget.gym.description;
    priceController.text = widget.gym.price.toString();
    mapPicker = MapScreen();
    super.initState();
    oldTitle = widget.gym.name;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(tr('edit_gym')),
        // appBar: globalAppBar("تعديل صالة الجيم"),
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
                        tr('edit_gym'),
                        // 'تعديل صالة الجيم',
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
                          labelText: tr('gym_name'),
                          // labelText: 'اسم الصالة',
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
                          labelText: tr('gym_desc'),
                          // labelText: 'وصف الصالة',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 50,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: tr('gym_price'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          child: Text(tr('determine_gym_location'),
                              // child: const Text('حدد موقع الصالة',
                              style: const TextStyle(color: Colors.white)),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return mapPicker!;
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ImageUploads(
                        photoUrl: widget.gym.assets,
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
                            // print("id is ${widget.gym.id}");

                            if (titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if (images.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: context.locale.languageCode == 'ar'
                                      ? 'من فضلك ادخل صورة الصالة'
                                      : 'Please enter the photo of the gym',
                                );
                                pop();
                                return;
                              }
                              Gym gym = Gym(
                                name: titleController.text,
                                description: descriptionController.text,
                                assets: images,
                                // category: widget.category,
                                id: widget.gym.id,
                                location: mapPicker!.value == null
                                    ? widget.gym.location
                                    : GeoPoint(mapPicker!.value!.latitude,
                                        mapPicker!.value!.longitude),
                                price: int.parse(priceController.text),
                                distance: widget.gym.distance,
                                isPendingGym:
                                    userProvider.isAdmin ? false : true,
                                gymOwnerId: widget.gym.gymOwnerId,
                              );
                              Provider.of<GymProvider>(
                                      navigationKey.currentContext!,
                                      listen: false)
                                  .updateGym(
                                      gym: gym, userProvider: userProvider);

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
                        child: Text(
                          tr('edit_the_gym'),
                          // 'تعديل الصالة',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
