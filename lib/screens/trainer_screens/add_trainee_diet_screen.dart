import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AddTraineeDietScreen extends StatefulWidget {
  // final User user;
  const AddTraineeDietScreen({Key? key}) : super(key: key);

  @override
  State<AddTraineeDietScreen> createState() => _AddTraineeDietScreenState();
}

class _AddTraineeDietScreenState extends State<AddTraineeDietScreen> {
  List<String> days = [];

  final titleController = TextEditingController();
  final day1Controller = TextEditingController();
  final day2Controller = TextEditingController();
  final day3Controller = TextEditingController();
  final day4Controller = TextEditingController();
  final day5Controller = TextEditingController();
  final day6Controller = TextEditingController();
  final day7Controller = TextEditingController();
  final durationController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    day1Controller.dispose();
    day2Controller.dispose();
    day3Controller.dispose();
    day4Controller.dispose();
    day5Controller.dispose();
    day6Controller.dispose();
    day7Controller.dispose();
    durationController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    days = [
      context.locale.languageCode == 'ar' ? 'يوم السبت' : 'Saturday',
      context.locale.languageCode == 'ar' ? 'يوم الأحد' : 'Sunday',
      context.locale.languageCode == 'ar' ? 'يوم الاثنين' : 'Monday',
      context.locale.languageCode == 'ar' ? 'يوم الثلاثاء' : 'Tuesday',
      context.locale.languageCode == 'ar' ? 'يوم الأربعاء' : 'Wednesday',
      context.locale.languageCode == 'ar' ? 'يوم الخميس' : 'Thursday',
      context.locale.languageCode == 'ar' ? 'يوم الجمعة' : 'Friday',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        appBar: globalAppBar(tr('add_diet_trainee')),
        // appBar: globalAppBar("إضافة نظام غذائي لمتدرب"),
        body: Consumer<TraineeProvider>(builder: (context, _, child) {
          return Consumer<TraineeProvider>(builder: (context, _, child) {
            return Padding(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: tr('plan_title'),
                              // labelText: 'عنوان النظام',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: durationController,
                            decoration: InputDecoration(
                              labelText: tr('plan_period'),
                              // labelText: 'مدة النظام',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day1Controller,
                            decoration: InputDecoration(
                              labelText: days[0],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day2Controller,
                            decoration: InputDecoration(
                              labelText: days[1],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day3Controller,
                            decoration: InputDecoration(
                              labelText: days[2],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day4Controller,
                            decoration: InputDecoration(
                              labelText: days[3],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day5Controller,
                            decoration: InputDecoration(
                              labelText: days[4],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day6Controller,
                            decoration: InputDecoration(
                              labelText: days[5],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: day7Controller,
                            decoration: InputDecoration(
                              labelText: days[6],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (titleController.text.isNotEmpty &&
                                        durationController.text.isNotEmpty
                                    // day1Controller.text.isNotEmpty &&
                                    // day2Controller.text.isNotEmpty &&
                                    // day3Controller.text.isNotEmpty &&
                                    // day4Controller.text.isNotEmpty &&
                                    // day5Controller.text.isNotEmpty &&
                                    // day6Controller.text.isNotEmpty &&
                                    // day7Controller.text.isNotEmpty
                                    ) {
                                  String body =
                                      "${days[0]} : ${day1Controller.text}  \n \n${days[1]} : ${day2Controller.text}  \n \n${days[2]} : ${day3Controller.text}  \n \n${days[3]} : ${day4Controller.text}  \n \n${days[4]} : ${day5Controller.text}  \n \n${days[5]} : ${day6Controller.text}  \n \n${days[6]} : ${day7Controller.text}  \n \n";

                                  Food diet = Food(
                                    title: titleController.text,
                                    foodData: body,
                                    duration: durationController.text,
                                  );
                                  //

                                  //
                                  await Provider.of<TraineeProvider>(context,
                                          listen: false)
                                      .addFoodToTrainee(diet);

                                  await Provider.of<TraineeProvider>(context,
                                          listen: false)
                                      .saveChangedSelectedTraineeData();
                                } else {
                                  pop();

                                  Fluttertoast.showToast(
                                      msg: "الرجاء إدخال جميع البيانات",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } catch (e) {
                                pop();

                                Fluttertoast.showToast(
                                    msg: tr('wrong'),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text(tr('add'),
                                // child: const Text('إضافة',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
