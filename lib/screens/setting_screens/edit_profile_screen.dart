import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/button_widget.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? newEmail;
  String? newName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newEmail = widget.user.email;
    newName = widget.user.name;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(
          context.locale.languageCode == 'ar'
              ? "تعديل البروفايل"
              : 'Edit profile',
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),

            // ProfileWidget(
            //   isUser: true,
            //   //TODO: add image
            //   // imagePath: widget.user.image!,
            //   imagePath: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            //   isEdit: true,
            //   onClicked: () async {
            //
            //   },
            // ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: tr('full_name'),
              text: widget.user.name,
              onChanged: (name) {
                newName = name;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: tr('email'),
              text: widget.user.email.toString(),
              onChanged: (email) {
                newEmail = email;
              },
            ),
            const SizedBox(height: 24),
            // TextFieldWidget(
            //   label: 'رقم الهاتف',
            //   text: widget.user.phone,
            //   maxLines: 1,
            //   onChanged: (phone) {
            //     widget.user.phone = phone;
            //
            //   },
            // ),
            const SizedBox(height: 50),

            ButtonWidget(
              text: context.locale.languageCode == 'ar'
                  ? 'حفظ التغييرات'
                  : 'Save changes',
              onClicked: () async {
                //TODO: save changes
                print("newEmail: $newEmail");
                print(Provider.of<UserProvider>(context, listen: false)
                    .user
                    .email);
                if (newEmail !=
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .email) {
                  Provider.of<UserProvider>(context, listen: false)
                      .changeEmail(newEmail!);
                }
                if (newName !=
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .name) {
                  Provider.of<UserProvider>(context, listen: false)
                      .editUserData(newName!);
                }
              },
            ),
          ],
        ),
      );
}
