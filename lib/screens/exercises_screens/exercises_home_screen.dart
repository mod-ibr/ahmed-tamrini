import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/exercises_screens/Add_exercise_category_screen.dart';
import 'package:tamrini/screens/exercises_screens/edit_category_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/helper_functions.dart';

class ExercisesHomeScreen extends StatefulWidget {
  final bool? isCourse;
  final String dayID;
  final bool? superSet;
  final ExerciseData? mainExercise;

  const ExercisesHomeScreen(
      {Key? key,
      this.isCourse = false,
      this.dayID = "",
      this.superSet = false,
      this.mainExercise})
      : super(key: key);

  @override
  State<ExercisesHomeScreen> createState() => _ExercisesHomeScreenState();
}

class _ExercisesHomeScreenState extends State<ExercisesHomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: SizedBox(child: adBanner() , height: 50 ,  width: 100.w ),
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('exercises')),
      // appBar: globalAppBar("التمارين"),
      body: SingleChildScrollView(
        child: Consumer<ExerciseProvider>(builder: (context, _, child) {
          return _.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Provider.of<UserProvider>(context, listen: false).isAdmin
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: kSecondaryColor!,
                                  onPressed: () {
                                    To(const AddExerciseCategoryScreen());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            end: 8.0),
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        tr('add_new_section'),
                                        // "إضافة قسم جديد",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.isCourse!
                              ? _.moveToExercise(_.allExercises,
                                  isAll: true,
                                  isAdd: true,
                                  dayID: widget.dayID,
                                  superSet: widget.superSet,
                                  mainExercise: widget.mainExercise)
                              : _.moveToExercise(_.allExercises, isAll: true);
                        },
                        child: Container(
                          alignment: AlignmentDirectional.topStart,
                          constraints: BoxConstraints(
                            minHeight: 100.spMax,
                            minWidth: 100,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/allExer.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tr('all_exercises'),
                              // "جميع التمارين",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          dragStartBehavior: DragStartBehavior.start,
                          itemCount: _.exercises.length,
                          itemBuilder: (BuildContext context, int index) {
                            _.exercises
                                .sort((a, b) => a.order!.compareTo(b.order!));
                            return GestureDetector(
                              onTap: () {
                                widget.isCourse!
                                    ? _.moveToExercise(
                                        _.exercises[index],
                                        isAdd: true,
                                        dayID: widget.dayID,
                                        superSet: widget.superSet,
                                        mainExercise: widget.mainExercise,
                                      )
                                    : _.moveToExercise(_.exercises[index]);

                                // To(ExerciseArticlesScreen(
                                //   // exercise: _.exercises[index],
                                // ));
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                constraints: const BoxConstraints(
                                  minHeight: 100,
                                  minWidth: 100,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black54, BlendMode.darken),
                                    image: _.exercises[index].image!.isNotEmpty
                                        ? HelperFunctions
                                            .ourFirebaseImageProvider(
                                                url: _.exercises[index].image!)
                                        : const AssetImage(
                                            "assets/images/allExer.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .isAdmin
                                          ? IconButton(
                                              onPressed: () {
                                                Widget cancelButton =
                                                    TextButton(
                                                  child: Text(tr('cancel')),
                                                  onPressed: () {
                                                    pop();
                                                  },
                                                );
                                                Widget continueButton =
                                                    TextButton(
                                                  child: Text(
                                                    tr('confirm_deletion'),
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    pop();
                                                    _.deleteCategory(
                                                        id: _.exercises[index]
                                                            .id!);
                                                  },
                                                );

                                                showDialog(
                                                    context: navigationKey
                                                        .currentState!.context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                            tr('confirm_deletion'),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          content: Text(
                                                            '${tr('delete_section')} ${_.exercises[index].title} ؟',
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          actions: [
                                                            continueButton,
                                                            cancelButton,
                                                          ],
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                        ));
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            )
                                          : const SizedBox(),
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: AutoSizeText(
                                                _.exercises[index].title!,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .isAdmin
                                                ? IconButton(
                                                    onPressed: () {
                                                      To(EditEXECategoryScreen(
                                                        category:
                                                            _.exercises[index],
                                                      ));
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.yellow,
                                                      size: 30,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.width / 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
