import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/exercises_screens/edit_exercise_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/youtube_manager.dart';

import '../../utils/distripute_assets.dart';
import '../../utils/helper_functions.dart';
import 'article_assets_view.dart';

class ExerciseArticlesDetailsScreen extends StatefulWidget {
  final ExerciseData exercise;
  final Exercise category;
  final bool isAll;
  final ExerciseData? superSetExercise;

  const ExerciseArticlesDetailsScreen({
    Key? key,
    required this.exercise,
    required this.category,
    required this.isAll,
    this.superSetExercise,
  }) : super(key: key);

  @override
  State<ExerciseArticlesDetailsScreen> createState() =>
      _ExerciseArticlesDetailsScreenState();
}

class _ExerciseArticlesDetailsScreenState
    extends State<ExerciseArticlesDetailsScreen> {
  int _current = 1;
  bool isFullScreen = false;
  OverlayEntry? _videoOverlay;
  List<Widget> assets = [];

  // setFullScreen(bool full) {
  //   print('############### START OVERLAY');
  //   if (isFullScreen != full) {
  //     if (full &&
  //         _videoOverlay == null &&
  //         _current < assets.length &&
  //         assets[_current] is YoutubeManager) {
  //       _videoOverlay = OverlayEntry(
  //         builder: (context) => Positioned.fill(
  //           bottom: 10,
  //           child: Center(
  //             child: assets[_current],
  //           ),
  //         ),
  //       );
  //       Future.delayed(const Duration())
  //           .then((value) => Overlay.of(context).insert(_videoOverlay!));
  //     } else if (!full && _videoOverlay != null) {
  //       _videoOverlay?.remove();
  //       _videoOverlay = null;
  //     }
  //     debugPrint('changing fullscreen to $full');
  //     setState(() => isFullScreen = full);
  //     print('############### START OVERLAY');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.exercise.assets != null && widget.exercise.assets!.length == 2) {
      assets = distributeAssets(
        widget.exercise.assets!,
        // setFullScreen: setFullScreen,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('exercise_details')),
      // appBar: globalAppBar("تفاصيل التمرين"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            // constraints:  BoxConstraints(
            //   minHeight: MediaQuery.of(context).size.height,
            // ),
            width: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ArticleView(
                    // onEnterFullScreen: setFullScreen,
                    // onExitFullScreen: setFullScreen,
                    height: height,
                    width: width,
                    exercise: widget.exercise,
                    assets: assets,
                    current: _current,
                    updateCurrent: (value) => _current = value,
                  ),
                  if (widget.superSetExercise != null) ...[
                    const Divider(
                      color: Colors.white,
                    ),
                    Text(
                      context.locale.languageCode == 'ar'
                          ? 'التمرين الثاني'
                          : 'Second exercise',
                      // 'التمرين الثاني',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xff007c9d),
                      ),
                    ),
                    ArticleView(
                      // onEnterFullScreen: setFullScreen,
                      // onExitFullScreen: setFullScreen,
                      height: height,
                      width: width,
                      exercise: widget.superSetExercise!,
                      assets: (widget.superSetExercise!.assets != null &&
                              widget.superSetExercise!.assets!.length == 2)
                          ? distributeAssets(widget.superSetExercise!.assets!)
                          : [],
                    ),
                  ],
                  Provider.of<UserProvider>(context, listen: false).isAdmin &&
                          !widget.isAll
                      ? MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: kSecondaryColor!,
                          onPressed: () {
                            To(EditExerciseScreen(
                              exercise: widget.exercise,
                              categoryID: widget.category,
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                tr('edit'),
                                // "تعديل",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            ],
                          ))
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  final ExerciseData exercise;
  final List<Widget> assets;
  final double width, height;
  // final Function onEnterFullScreen;
  // final Function onExitFullScreen;
  final int? current;
  final void Function(int)? updateCurrent;

  const ArticleView({
    // required this.onEnterFullScreen,
    // required this.onExitFullScreen,
    required this.exercise,
    required this.assets,
    required this.width,
    required this.height,
    this.current,
    this.updateCurrent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            exercise.title ?? '',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        (assets.isNotEmpty)
            ? VideoViewer(
              title:  exercise.title ?? '',
                // onEnterFullScreen: onEnterFullScreen,
                // onExitFullScreen: onExitFullScreen,
                width: width,
                height: height,
                imageUrl: exercise.assets!.first,
                videourl: exercise.assets!.last,
              )
            : const SizedBox(),
        // exercise.assets == null || exercise.assets!.isEmpty
        //     ? Container()
        //     : ClipRRect(
        //         borderRadius: BorderRadius.circular(10.0),
        //         child: CustomImageSlideShow(
        //           assets: exercise.assets!,
        //           onPageChanged: (value) {
        //             if (updateCurrent != null) {
        //               updateCurrent!(value);
        //             }
        //           },
        //           currentIndex: current,
        //           updateCurrent: updateCurrent,
        //           children: [
        //             for (var i = 0; i < exercise.assets!.length; i++)
        //               InkWell(
        //                 onTap: () {
        //                   if (exercise.assets![i].contains(
        //                       RegExp(RegexPatterns.allowedImageFormat))) {
        //                     showDialog<dynamic>(
        //                         context: context,
        //                         barrierDismissible: false,
        //                         builder: (BuildContext context) {
        //                           return OrientationBuilder(
        //                             builder: (context, orientation) {
        //                               return StatefulBuilder(
        //                                   builder: (context, setState) {
        //                                 return Scaffold(
        //                                   appBar: AppBar(
        //                                     backgroundColor:
        //                                         const Color(0xFFEFF2F7),
        //                                     elevation: 0,
        //                                     iconTheme: const IconThemeData(
        //                                         color: Color(0xFF003E4F)),
        //                                     centerTitle: false,
        //                                     title: Text(
        //                                       exercise.title ?? '',
        //                                       style: TextStyle(
        //                                         fontSize: 20.sp,
        //                                         color: const Color(0xff007c9d),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                   body: Container(
        //                                     // height: 1.sh,
        //                                     alignment: Alignment.center,
        //                                     child: CustomImageSlideShow(
        //                                       height: 1.sh,
        //                                       assets: exercise.assets!,
        //                                       currentIndex: current,
        //                                       updateCurrent: updateCurrent,
        //                                       children: assets,
        //                                     ),
        //                                   ),
        //                                 );
        //                               });
        //                             },
        //                           );
        //                         });
        //                   }
        //                 },
        //                 child: assets[i],
        //               )
        //           ],
        //         ),
        //       ),
        InkWell(
          onTap: () => HelperFunctions.showDialogue(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.alarm,
                  color: kPrimaryColor,
                ),
                SizedBox(width: 5.w),
                Text(context.locale.languageCode == 'ar'
                    ? 'اضافة مؤقت'
                    : 'Add timer'),
                // const Text('اضافة مؤقت'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                """${(exercise.description)}""",
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
