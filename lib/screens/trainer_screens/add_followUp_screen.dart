//add follow up screen from consumet

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../provider/trainee_provider.dart';

class AddFollowUpScreen extends StatefulWidget {
  final bool isNewSub;
  final User? trainer;

  const AddFollowUpScreen({Key? key, required this.isNewSub, this.trainer})
      : super(key: key);

  @override
  State<AddFollowUpScreen> createState() => _AddFollowUpScreenState();
}

class _AddFollowUpScreenState extends State<AddFollowUpScreen> {
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllers = widget.isNewSub
        ? List.generate(widget.trainer!.questions?.length ?? 0,
            (index) => TextEditingController())
        : List.generate(1, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isNewSub
          ? globalAppBar(tr('subscription_request'))
          // ? globalAppBar('طلب اشتراك')
          : globalAppBar(tr('add_followup')),
      // : globalAppBar("اضافة متابعة"),
      body: Consumer<TrainerProvider>(builder: (context, _, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 2),
                        blurRadius: 5)
                  ]),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  widget.isNewSub
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.trainer!.questions!.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              const SizedBox(height: 20),
                              Text(widget.trainer!.questions![index]),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  hintText: widget.trainer!.questions![index],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ]);
                          },
                        )
                      : Column(
                          children: [
                            Text(context.locale.languageCode == 'ar'
                                ? 'ملاحظات'
                                : 'Notes'),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _controllers[0],
                              decoration: InputDecoration(
                                hintText: context.locale.languageCode == 'ar'
                                    ? 'ملاحظات مثل الوزن والطول الجديد'
                                    : 'Notes like new weight & tall',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      Text(context.locale.languageCode == 'ar'
                          ? 'اضافة صور للجسم للمعاينه من قبل المدرب'
                          : 'Adding pictures of the body for review by the trainer'),
                      // Text('اضافة صور للجسم للمعاينه من قبل المدرب'),
                      const ImageUploads(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      showLoaderDialog(context);
                      var images = await Provider.of<UploadProvider>(context,
                              listen: false)
                          .uploadFiles();

                      if (images.isNotEmpty &&
                          _controllers
                              .every((element) => element.text.isNotEmpty)) {
                        widget.isNewSub
                            ? _.subscribeToTrainer(
                                trainer: widget.trainer!,
                                answers:
                                    _controllers.map((e) => e.text).toList(),
                                images: images)
                            : {
                                Provider.of<TraineeProvider>(context,
                                        listen: false)
                                    .addFollowUpToTrainee(
                                        note: _controllers[0].text,
                                        images: images)
                              };
                      } else {
                        pop();
                        Fluttertoast.showToast(
                            msg: context.locale.languageCode == 'ar'
                                ? 'يجب ادخال جميع البيانات'
                                : 'All data must be entered');
                      }
                    },
                    child: Text(
                      tr('add'),
                      // 'اضافة',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
