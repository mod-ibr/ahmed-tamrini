import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/exercise_provider.dart';
import '../../provider/home_exercise_provider.dart';
import '../../utils/widgets/button_widget.dart';
import '../../utils/widgets/global Widgets.dart';

class SuggestedExercisesScreen extends StatefulWidget {
  final bool homeExercises;

  const SuggestedExercisesScreen({super.key, required this.homeExercises});

  @override
  State<SuggestedExercisesScreen> createState() =>
      _SuggestedExercisesScreenState();
}

class _SuggestedExercisesScreenState extends State<SuggestedExercisesScreen> {
  Stream<DocumentSnapshot> getSuggestedExercises() {
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.homeExercises ? 'homeExercises' : 'exercises')
        .snapshots();
  }

  String home() {
    String homeStr =
        context.locale.languageCode == 'ar' ? ' (المنزلية) ' : ' (Home) ';
    return widget.homeExercises ? homeStr : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar("${tr('suggested_exercises')} ${home()}"),
      // appBar: globalAppBar("التمارين${widget.homeExercises ? ' المنزلية ' : ' '}المقترحة"),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getSuggestedExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: ButtonWidget(
                text: tr('server_error'),
                // text: 'مشكلة في السيرفر ،العودة للصفحة السابقة',
                onClicked: () => Navigator.pop(context),
              ),
            );
          }
          if (snapshot.data == null ||
              !snapshot.data!.exists ||
              snapshot.data!.data() == null ||
              (snapshot.data!.data()! as Map).isEmpty ||
              (snapshot.data!.data() as Map<String, dynamic>)['data'] == null ||
              (snapshot.data!.data() as Map<String, dynamic>)['data'].isEmpty) {
            return Center(
              child: Text(
                tr('no_suggested_exercises'),
                // 'لا توجد اقتراحات حالية',
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            );
          }
          List myExercises =
              (snapshot.data!.data() as Map<String, dynamic>)['data'];
          return StatefulBuilder(
            builder: (context, setState) {
              return widget.homeExercises
                  ? Consumer<HomeExerciseProvider>(
                      builder: (context, _, child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: dismissibleWidget(myExercises[index]),
                            );
                          },
                          itemCount: myExercises.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 5.h);
                          },
                        );
                      },
                    )
                  : Consumer<ExerciseProvider>(
                      builder: (context, _, child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: dismissibleWidget(myExercises[index]));
                          },
                          itemCount: myExercises.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 5.h);
                          },
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }

  Widget dismissibleWidget(Map<String, dynamic> myExercises) {
    HomeExerciseProvider homeExerciseProvider =
        Provider.of<HomeExerciseProvider>(context, listen: false);
    ExerciseProvider exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);

    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            title: context.locale.languageCode == 'ar'
                ? 'حذف الاقتراح'
                : 'Delete suggestion',
            desc: tr('sure_of_deletion'),
            btnOkOnPress: () {
              (widget.homeExercises)
                  ? homeExerciseProvider.deleteHomeExerciseSuggestion(
                      data: myExercises)
                  : exerciseProvider.deleteExerciseSuggestion(
                      data: myExercises);
            },
          ).show();
          return null;
        },
        onDismissed: (direction) async {},
        child: exerciseCard(myExercises));
  }

  Widget exerciseCard(Map<String, dynamic> myExercises) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () {},
        title: Text(
          "${tr('category')} : ${myExercises["category_title"]}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${tr('exercise_name')} : ${myExercises["title"]}",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${tr('description')} : ${myExercises["description"]}",
            ),
          ],
        ),
      ),
    );
  }
}
