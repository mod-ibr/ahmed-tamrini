import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('contact_us')),
        // appBar: globalAppBar("عن التطبيق"),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "${context.locale.languageCode == 'ar' ? "للإستفسار او اي تساؤل تواصل معنا على" : "For inquiries or any questions, contact us on"} :  ",
                    // " للإستفسار او اي تساؤل تواصل معنا على :  ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          launchUrl(Uri.parse("tel:+9647711211318"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Icon(
                          Ionicons.call_outline,
                          size: 40,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          launchUrl(Uri.parse("https://wa.me/+9647711211318"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Icon(
                          Ionicons.logo_whatsapp,
                          color: Colors.green,
                          size: 40,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          launchUrl(
                              Uri.parse("https://www.facebook.com/tamrini2"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Icon(
                          Ionicons.logo_facebook,
                          color: Colors.blue,
                          size: 40,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          launchUrl(Uri.parse("https://instagram.com/tamrini_"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Icon(
                          Ionicons.logo_instagram,
                          color: Colors.pink,
                          size: 40,
                        )),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? "جميع الحقوق محفوظة"
                        : "All rights preserved"),
                    // const Text("جميع الحقوق محفوظة"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Tamrini"),
                        const Text(" © "),
                        Text(DateTime.now().year.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
