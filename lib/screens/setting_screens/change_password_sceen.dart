import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/button_widget.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/textfield_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key, bool isReset = false}) : super(key: key);
  String oldPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
  bool isReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('change_password')),
        // appBar: globalAppBar("تغيير كلمة المرور"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              isReset ? const SizedBox() : const SizedBox(height: 24),
              isReset
                  ? const SizedBox()
                  : TextFieldWidget(
                      label: tr('old_password'),
                      // label: 'كلمة المرور القديمة',
                      onChanged: (password) {
                        oldPassword = password;
                      },
                      text: '',
                      isPassword: true,
                    ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: tr('new_password'),
                // label: 'كلمة المرور الجديدة',
                onChanged: (password) {
                  newPassword = password;
                },
                text: '',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: tr('confirm_new_password'),
                // label: 'تأكيد كلمة المرور الجديدة',
                onChanged: (password) {
                  confirmNewPassword = password;
                },
                text: '',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              ButtonWidget(
                text: tr('change_password'),
                // text: 'تغيير كلمة المرور',
                onClicked: () {
                  if (!isReset) {
                    if (oldPassword == '' ||
                        newPassword == '' ||
                        confirmNewPassword == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red.shade900,
                          content: Text(
                            context.locale.languageCode == 'ar'
                                ? 'الرجاء ملئ جميع الحقول'
                                : 'Please fill in all fields',
                          ),
                        ),
                      );
                      return;
                    }
                    if (oldPassword !=
                        Provider.of<UserProvider>(context, listen: false)
                            .user
                            .password) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red.shade900,
                          content: Text(
                            context.locale.languageCode == 'ar'
                                ? 'كلمة المرور القديمة غير صحيحة'
                                : 'The old password is incorrect',
                          ),
                        ),
                      );
                      return;
                    }
                  } else {
                    if (newPassword == '' || confirmNewPassword == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red.shade900,
                          content: Text(
                            context.locale.languageCode == 'ar'
                                ? 'الرجاء ملئ جميع الحقول'
                                : 'Please fill in all fields',
                          ),
                        ),
                      );
                      return;
                    }
                  }

                  if (newPassword.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red.shade900,
                        content: Text(
                          context.locale.languageCode == 'ar'
                              ? 'كلمة المرور يجب أن تكون أكثر من 6 أحرف'
                              : 'Password must be more than 6 characters',
                        ),
                      ),
                    );
                    return;
                  }

                  if (newPassword != confirmNewPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red.shade900,
                        content: Text(context.locale.languageCode == 'ar'
                            ? 'كلمة المرور غير متطابقة'
                            : 'Password mismatch'),
                      ),
                    );
                    return;
                  } else {
                    Provider.of<UserProvider>(context, listen: false)
                        .changePassword(newPassword);
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ));
  }
}
