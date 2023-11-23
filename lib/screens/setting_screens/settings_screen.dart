import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/ThemeProvider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/setting_screens/change_password_sceen.dart';
import 'package:tamrini/screens/setting_screens/change_phone_screen.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/constants.dart';
import 'setting_alarm_screen-updated.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue = CacheHelper.getBoolean(key: 'isDark');

  // bool isArabic =  CacheHelper.getBoolean(key: 'isArabic');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('settings')),
        // appBar: globalAppBar("الإعدادات"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.brightness_4,
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    Text(
                      tr('dark_mode'),
                      // 'الوضع المظلم',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'cairo',
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: switchValue,
                      onChanged: (value) {
                        setState(() {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .changeAppMode(fromShared: value);

                          switchValue = value;
                          debugPrint(
                              '${CacheHelper.getBoolean(key: 'isDark')}');
                        });
                      },
                      // trackColor:
                      //     Colors.grey.shade200.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.h),
              const Divider(
                endIndent: 50,
                indent: 50,
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(width: 15.h),
              Provider.of<UserProvider>(context).isLogin
                  ? InkWell(
                      onTap: () {
                        To(ProfileScreen(
                          user:
                              Provider.of<UserProvider>(context, listen: false)
                                  .user,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.person,
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              tr('profile'),
                              // 'الملف الشخصي',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Provider.of<UserProvider>(context).isLogin
                  ? SizedBox(
                      width: 15.h,
                    )
                  : Container(),
              Provider.of<UserProvider>(context).isLogin
                  ? const Divider(
                      endIndent: 50,
                      indent: 50,
                      color: Colors.grey,
                      thickness: 1,
                    )
                  : Container(),
              SizedBox(
                width: 15.h,
              ),
              Provider.of<UserProvider>(context).isLogin
                  ? Provider.of<UserProvider>(context).user.password !=
                          "!@#%^&*"
                      ? InkWell(
                          onTap: () {
                            To(ChangePasswordScreen());
                            // Provider.of<UserProvider>(context,listen: false).logout(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Ionicons.lock_closed_outline,
                                ),
                                SizedBox(
                                  width: 15.h,
                                ),
                                Text(
                                  tr('change_password'),
                                  // 'تغيير كلمة المرور',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              SizedBox(
                width: 15.h,
              ),
              Provider.of<UserProvider>(context).isLogin
                  ? Provider.of<UserProvider>(context).user.password !=
                          "!@#%^&*"
                      ? const Divider(
                          endIndent: 50,
                          indent: 50,
                          color: Colors.grey,
                          thickness: 1,
                        )
                      : Container()
                  : Container(),
              SizedBox(
                width: 15.h,
              ),
              Provider.of<UserProvider>(context).isLogin
                  ? InkWell(
                      onTap: () {
                        To(const ChangePhoneScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.logout,
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              !Provider.of<UserProvider>(context)
                                      .user
                                      .isVerifiedPhoneNumber
                                  ? tr('verify_phone')
                                  : tr('change_phone'),
                              // ? 'تأكيد رقم الهاتف'
                              // : 'تغيير رقم الهاتف',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 15.h,
              ),
              Provider.of<UserProvider>(context).isLogin
                  ? const Divider(
                      endIndent: 50,
                      indent: 50,
                      color: Colors.grey,
                      thickness: 1,
                    )
                  : Container(),
              SizedBox(width: 15.h),
              Provider.of<UserProvider>(context).isLogin
                  ? InkWell(
                      onTap: () {
                        To(const SettingAlarmScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.alarm,
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              tr('water_alarm'),
                              // 'منبه لشرب الماء',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(width: 15.h),
              Provider.of<UserProvider>(context).isLogin
                  ? const Divider(
                      endIndent: 50,
                      indent: 50,
                      color: Colors.grey,
                      thickness: 1,
                    )
                  : Container(),
              SizedBox(width: 15.h),
              // Provider.of<UserProvider>(context).isLogin
              //     ?
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<ThemeProvider>(context, listen: false)
                            .changeLanguage(
                                arabic: true, lang: const Locale('ar'));
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 25.w,
                        ),
                        decoration: BoxDecoration(
                          color: context.locale.languageCode == 'ar'
                              ? kSecondaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'العربية',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.locale.languageCode == 'ar'
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<ThemeProvider>(context, listen: false)
                            .changeLanguage(
                                arabic: false, lang: const Locale('en'));
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 25.w,
                        ),
                        decoration: BoxDecoration(
                          color: context.locale.languageCode != 'ar'
                              ? kSecondaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'English',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.locale.languageCode != 'ar'
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              // : Container()
              ,
              SizedBox(width: 15.h),
              // Provider.of<UserProvider>(context).isLogin
              //     ?
              const Divider(
                endIndent: 50,
                indent: 50,
                color: Colors.grey,
                thickness: 1,
              )
              // : Container()
              ,
            ],
          ),
        ));
  }
}
