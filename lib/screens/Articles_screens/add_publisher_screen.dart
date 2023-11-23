import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/publisherProvider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/user.dart';

class AddPublisherScreen extends StatefulWidget {
  final User user;

  const AddPublisherScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AddPublisherScreen> createState() => _AddPublisherScreenState();
}

class _AddPublisherScreenState extends State<AddPublisherScreen> {
  late TextEditingController summaryController;
  @override
  void initState() {
    summaryController = TextEditingController(
        text: widget.user.isPublisher! ? widget.user.publisherSummary : null);
    super.initState();
  }

  @override
  void dispose() {
    summaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PublisherProvider publisherProvider = Provider.of<PublisherProvider>(
        navigationKey.currentContext!,
        listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar(!widget.user.isPublisher!
            ? tr('promote_to_publisher')
            : context.locale.languageCode == 'ar'
                ? "تعديل بيانت الناشر"
                : "Update Publisher Data"),
        // appBar: globalAppBar("الترقية الي ناشر"),
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
                    offset: const Offset(0, 3),
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
                        context.locale.languageCode == 'ar'
                            ? 'اكتب نبذة عنك'
                            : 'Write about you',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: summaryController,
                        decoration: InputDecoration(
                          labelText: context.locale.languageCode == 'ar'
                              ? 'نبذة عنك'
                              : "About you",
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);

                            if (summaryController.text.isNotEmpty) {
                              //! Merge Trainer data with user data
                              widget.user.publisherSummary =
                                  summaryController.text;

                              log('publisherSummary : ${widget.user.publisherSummary}');
                              log('isPublisher : ${widget.user.isPublisher}');
                              (!widget.user.isPublisher!)
                                  ? publisherProvider
                                      .subscribeAsPublisher(widget.user)
                                  : publisherProvider
                                      .updatePublisherData(widget.user);
                            } else {
                              pop();

                              Fluttertoast.showToast(msg: tr('enter_data'));
                            }
                          } on Exception catch (e) {
                            log("ERROR while adding new Publisher : $e");
                            pop();
                            Fluttertoast.showToast(msg: tr('an_error'));
                          }
                        },
                        child: Text(
                            context.locale.languageCode == 'ar'
                                ? 'تقديم طلب'
                                : 'Submit request',
                            // child: const Text('تقديم طلب',
                            style: const TextStyle(color: Colors.white)),
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
