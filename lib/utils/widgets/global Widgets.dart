import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

GlobalKey<NavigatorState> get navigationKey => _navigationKey;

Future To(Widget widget) async {
  return await navigationKey.currentState
      ?.push(MaterialPageRoute(builder: (BuildContext context) => widget));
}

Future ToAndFinish(Widget widget) async {
  return navigationKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget),
      (route) => false);
}

pop() {
  return navigationKey.currentState?.pop();
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: Center(child: Image.asset('assets/images/loading.gif')),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget addFromGalleryItems({
  required String title,
  required IconData icon,
  required VoidCallback function,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 43.h,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(5.0),
        //   color: const Color(0xffffffff),
        //   border: Border.all(width: 1.0, color: const Color(0xffd5ddeb)),
        // ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'JF Flat',
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      IconButton(
          onPressed: function,
          icon: Icon(
            icon,
            color: const Color(0xFF7A90B7),
          ))
    ],
  );
}

Widget adBanner() {
  return Center(
    child: UnityBannerAd(
      placementId: Platform.isAndroid ? "Banner_Android" : "Banner_iOS",
      onLoad: (placementId) => print('Banner loaded: $placementId'),
      onClick: (placementId) => print('Banner clicked: $placementId'),
      onFailed: (placementId, error, message) =>
          print('Banner Ad $placementId failed: $error $message'),
    ),
  );
}

//
Widget searchBar(
  TextEditingController controller,
  Function(String) callback,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(navigationKey.currentContext!).cardColor,
        borderRadius: BorderRadius.circular(30.0),

        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 3,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: TextField(
        contextMenuBuilder:
            (BuildContext context, EditableTextState editableTextState) {
          return AdaptiveTextSelectionToolbar(
            anchors: editableTextState.contextMenuAnchors,
            // Build the default buttons, but make them look custom.
            // In a real project you may want to build different
            // buttons depending on the platform.
            children: editableTextState.contextMenuButtonItems
                .map((ContextMenuButtonItem buttonItem) {
              return CupertinoButton(
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: buttonItem.onPressed,
                padding: const EdgeInsets.all(8.0),
                pressedOpacity: 0.7,
                child: SizedBox(
                  width: 50.0,
                  child: Text(
                    CupertinoTextSelectionToolbarButton.getButtonLabel(
                        context, buttonItem),
                  ),
                ),
              );
            }).toList(),
          );
        },
        style: const TextStyle(
          fontSize: 20,
        ),
        controller: controller,
        onChanged: callback,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(navigationKey.currentContext!)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(navigationKey.currentContext!)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.3),
            ),
            // borderSide: BorderSide,
          ),
          fillColor: Colors.white,
          hintText: tr('search'),
          // hintText: 'بحث',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search,
          ),
          // border: InputBorder.none,
        ),
      ),
    ),
  );
}

//
Widget myListTielStatic(
        String title, Widget icon, Function? function, bool isSelected) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: isSelected
                ? BoxDecoration(
                    color: kSecondaryColor!,
                    borderRadius: BorderRadius.circular(15),
                  )
                : null,
            child: ListTile(
              //stileColor: primaryColor,
              onTap: () {
                function!();
              },
              title: Row(
                children: [
                  icon,
                  //Icon(Icons.fact_check , color: Colors.black,),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'cairo',
                    ),
                  ),
//            Spacer(),
//
//            Icon(Icons.arrow_forward_ios , size: 18.r, color: Colors.black45 ),
                ],
              ),

              //Image.asset("assets/images/order_icon.png"),
            ),
          ),

          // Divider(
          //   endIndent: 10,
          //   indent: 10,
          //   color: Colors.grey,
          //   thickness: 1,
          //
          // ),
        ],
      ),
    );

AppBar globalAppBar(String title,
    {bool isLeading = false,
    bool isMain = false,
    bool notification = false,
    List<Widget> actions = const []}) {
  if (isMain) {
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      }),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor:
          Theme.of(navigationKey.currentContext!).appBarTheme.backgroundColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'cairo'),
      ),
      actions: [
        IconButton(
          icon: Icon(
              notification ? Icons.notifications_active : Icons.notifications),
          color: Colors.white,
          onPressed: () {
            Provider.of<UserProvider>(navigationKey.currentContext!,
                        listen: false)
                    .isLogin
                ? Provider.of<UserProvider>(navigationKey.currentContext!,
                        listen: false)
                    .openNotifications()
                : AwesomeDialog(
                    context: navigationKey.currentContext!,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: tr('alert'),
                    desc: tr('must_login'),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      To(const LoginScreen());
                    },
                  ).show();
          },
        ),
      ],
    );
  }
  return AppBar(
    leading: isLeading
        ? Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          })
        : IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => pop(),
          ),
    actions: actions,
    // toolbarHeight: constraints.maxHeight * 0.11,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    // leading: Visibility(
    //     visible: onBackPressed != null,
    //     child: IconButton(
    //         icon: Icon(Icons.arrow_back_ios), onPressed: onBackPressed)),
    backgroundColor:
        Theme.of(navigationKey.currentContext!).appBarTheme.backgroundColor,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'cairo',
      ),
    ),
  );
}
