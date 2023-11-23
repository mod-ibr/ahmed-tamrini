import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

bool isLink = false;
void fetchLinkData() async {
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    print("this is query for hs ${dynamicLinkData.link.queryParameters['q']}");
    isLink = true;

    handleDeepLink(dynamicLinkData);
  }).onError((error) {
    print("nav error : ${error.toString()}");
    // Handle errors
  });

  handleDeepLink(initialLink);
}

handleDeepLink(PendingDynamicLinkData? data) async {
  final Uri? deepLink = data?.link;
  if (deepLink != null) {
    print("_handleDeepLink | deeplink : $deepLink}");

    final queryParams = deepLink.queryParameters;
    if (queryParams.isNotEmpty) {
      // String? search = queryParams["email"];
      // verify the username is parsed correctly
      final String? actionCode = queryParams['oobCode'];
      try {
        await FirebaseAuth.instance.checkActionCode(actionCode!);
        await FirebaseAuth.instance.applyActionCode(actionCode);
        var id = Provider.of<UserProvider>(navigationKey.currentContext!,
                listen: false)
            .user
            .uid;
        await FirebaseFirestore.instance.collection('users').doc(id).set({
          'isVerifiedEmail': true,
        }, SetOptions(merge: true));
        // Confirm the link is a sign-in with email link.
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('activated_successfully'),
          desc: tr('activated_successfully_log_in'),
          btnOkOnPress: () {},
        ).show();
        // If successful, reload the user:
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-action-code') {}
      }
    }
    // var isId = deepLink.pathSegments.contains("id");
  }
}
