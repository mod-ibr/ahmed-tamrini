import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/data/user_data.dart';
import 'package:tamrini/provider/product_provider.dart';
import 'package:tamrini/screens/setting_screens/banner_screen.dart';
import 'package:tamrini/screens/setting_screens/orders_screens.dart';
import 'package:tamrini/screens/setting_screens/payment_methods_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/save_pdf_file.dart';
// import 'package:open_file/open_file.dart' as of;

class AdminControlScreen extends StatefulWidget {
  const AdminControlScreen({Key? key}) : super(key: key);

  @override
  State<AdminControlScreen> createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  bool isLoading = false;
  Future<void> downloadAndSaveUsersPDF() async {
    var status = await Permission.storage.request();
    setState(() {
      isLoading = true;
    });
    try {
      final users = await downloadUsersData(); // Fetch your user data

      final pdf = pw.Document();

      final ttf =
          await rootBundle.load('assets/fonts/noto/NotoSans-Regular.ttf');
      final arabicFont = pw.Font.ttf(ttf);

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            // Create a list of widgets for each user's data
            final List<pw.Widget> userWidgets = users.map((user) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Name: ${user['name']}',
                    style: pw.TextStyle(font: arabicFont),
                  ),
                  pw.Text(
                    'Email: ${user['email']}',
                    style: pw.TextStyle(font: arabicFont),
                  ),
                  pw.Text(
                    'Phone: ${user['phone']}',
                    style: pw.TextStyle(font: arabicFont),
                  ),
                  pw.Divider(),
                ],
              );
            }).toList();

            // Return the list of user widgets
            return userWidgets;
          },
        ),
      );

      final pdfData = await pdf.save();

      try {
        if (status.isGranted) {
          if (Platform.isIOS) {
            final directory = await getApplicationDocumentsDirectory();

            final filePath =
                '${directory.path}/${DateTime.now().microsecondsSinceEpoch.toString()}.pdf';
            final pdfFile = File(filePath);
            final pdfResult = await pdfFile.writeAsBytes(pdfData, flush: true);
            debugPrint("this is pdf path ${pdfResult.path}");
            await OpenFilex.open(pdfResult.path);

            // final pdfResult=  await pdfFile.writeAsBytes(pdfData);
            //   if (pdfFile.existsSync()) {
            //     await OpenFile.open(pdfFile.path);
            //   } else {

            //     await pdfFile.create(recursive: true).then((value) {
            //       OpenFile.open(value.path);
            //     });
            //   }
          }
          //! Start New Path
          else {
            Directory? appDocDir =
                await getExternalStorageDir(folderName: 'Tamrini');
            if (appDocDir != null) {
              log(appDocDir.path);
              final targetPath = appDocDir.path;
              final filePath =
                  '$targetPath/${DateFormat('dd-MM-yyyy').format(DateTime.now())}-users.pdf';
              final pdfFile = File(filePath);

              await pdfFile.writeAsBytes(pdfData);
              log("String generatedPdfFilePath : ${pdfFile.path} ");
              await OpenFilex.open(pdfFile.path);
            }
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      setState(() {
        isLoading = false;
      });
//! Ebd New Path
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      log("ERROR While download users data L: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('dashboard')),
      // appBar: globalAppBar('صفحة التحكم'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: kSecondaryColor,
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .fetchAndSetPaymentMethods();
                To(const PaymentMethodsScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 8.0),
                    //   child: Icon(Icons.add_circle, color: Colors.white),
                    // ),
                    Text(
                      tr('payment_methods'),
                      // "وسائل الدفع",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: kSecondaryColor,
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .getAllOrdersForAdmin();
                To(const OrdersScreens());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 8.0),
                    //   child: Icon(Icons.add_circle, color: Colors.white),
                    // ),
                    Text(
                      tr('purchase_orders'),
                      // "طلبات الشراء",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: kSecondaryColor,
                onPressed: () {
                  To(const BannerScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 8.0),
                      //   child: Icon(Icons.add_circle, color: Colors.white),
                      // ),
                      Text(
                        tr('banner'),
                        // "البانر",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: kSecondaryColor,
                onPressed: () async {
                  await downloadAndSaveUsersPDF();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const Padding(
                            //   padding: EdgeInsets.only(left: 8.0),
                            //   child: Icon(Icons.add_circle, color: Colors.white),
                            // ),
                            Text(
                              tr('download_users'),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
