import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/exercises_screens/Add_exercise_screen.dart';
import 'package:tamrini/screens/exercises_screens/article_assets_view.dart';
import 'package:tamrini/screens/exercises_screens/exercise_Article_details_screen.dart';
import 'package:tamrini/screens/exercises_screens/suggest_add_exercise.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/distripute_assets.dart';

class ExerciseArticlesScreen extends StatefulWidget {
  final Exercise exercise;
  final bool isAll;

  const ExerciseArticlesScreen(
      {Key? key, required this.exercise, this.isAll = false})
      : super(key: key);

  @override
  State<ExerciseArticlesScreen> createState() => _ExerciseArticlesScreen();
}

class _ExerciseArticlesScreen extends State<ExerciseArticlesScreen> {
  int _current = 1;
  bool isFullScreen = true;
  OverlayEntry? _videoOverlay;
  List<Widget> assets = [];

  // setFullScreen(bool full) {
  //   print('############### START OVERLAY');
  //   if (isFullScreen != full) {
  //     if (full && _videoOverlay == null) {
  //       _videoOverlay = OverlayEntry(
  //         builder: (context) => Positioned.fill(
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

//! start pagination data
  final int _limit = 10;
  int counter = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<ExerciseData> loadedExercise = [];
  late ScrollController _controller;

  resetLoadedExercise() {
    loadedExercise = [];
    counter = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
  }

  void _firstLoad() async {
    List<ExerciseData> allExercise = Provider.of<ExerciseProvider>(
            navigationKey.currentContext!,
            listen: false)
        .selectedExercise;
    resetLoadedExercise();
    TextEditingController searchController =
        Provider.of<ExerciseProvider>(context, listen: false).searchController;
    if (searchController.text.trimRight().trimLeft().isEmpty) {
      await Future.delayed(Duration.zero)
          .then((value) => setState(() => _isFirstLoadRunning = true));
    }

    await Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        loadedExercise = allExercise.sublist(
          0,
          _limit <= allExercise.length ? _limit : allExercise.length,
        );

        counter += _limit;
        log("Counter Value : $counter");

        setState(() => _isFirstLoadRunning = false);
      },
    );
  }

  void _loadMore() async {
    List<ExerciseData> allExercise = Provider.of<ExerciseProvider>(
            navigationKey.currentContext!,
            listen: false)
        .selectedExercise;
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() => _isLoadMoreRunning = true);
      await Future.delayed(const Duration(seconds: 2));
      final List<ExerciseData> fetchedPosts =
          getNextItems(allExercise, counter);
      if (fetchedPosts.isNotEmpty) {
        counter += _limit;
        setState(() {
          log("THe all List lenght : ${allExercise.length}");
          log("THe loaded List lenght BEFORE ADDING : ${loadedExercise.length}");
          loadedExercise.addAll(fetchedPosts);
          log("THe loaded List lenght After ADDING : ${loadedExercise.length}");

          log("Counter Value : $counter");
          _isLoadMoreRunning = false;
        });
      } else {
        setState(() {
          _hasNextPage = false;
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  List<ExerciseData> getNextItems(
      List<ExerciseData> selectedExercise, int startIndex) {
    final endIndex = startIndex + _limit;

    if (startIndex >= selectedExercise.length) {
      // No more items to load, return an empty list
      return [];
    }

    final nextItems = selectedExercise.sublist(
      startIndex,
      endIndex <= selectedExercise.length ? endIndex : selectedExercise.length,
    );

    // List<ExerciseData> nextItems = selectedExercise
    //     .skip(startIndex)
    //     .take(_limit) // Take the next 20 items
    //     .toList();

    return nextItems;
  }

  @override
  void initState() {
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ExerciseProvider>(navigationKey.currentContext!, listen: false)
        .clearSearch();
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  //! End pagination data
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(
            widget.isAll ? tr('all_exercises') : widget.exercise.title!),
        // widget.isAll ? "جميع التمارين" : widget.exercise.title!),
        body: Consumer<ExerciseProvider>(builder: (context, _, child) {
          return _.isLoading || _isFirstLoadRunning
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : Column(
                  children: [
                    searchBar(_.searchController, (value) {
                      print(value);
                      widget.isAll
                          ? _.searchAll()
                          : _.search(widget.exercise.id);
                      _firstLoad();
                    }),
                    Provider.of<UserProvider>(context, listen: false).isAdmin &&
                            !widget.isAll
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: kSecondaryColor!,
                                  onPressed: () {
                                    To(AddExerciseScreen(
                                        category: widget.exercise.title!));
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
                                        tr('add_exercise'),
                                        // "إضافة تمرين",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            ],
                          )
                        : !Provider.of<UserProvider>(context, listen: false)
                                    .isAdmin &&
                                !widget.isAll
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      color: kSecondaryColor!,
                                      onPressed: () {
                                        To(SuggestAddExercise(
                                            categoryTitle:
                                                widget.exercise.title!));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            tr('suggest_exercise'),
                                            // "اقتراح إضافة تمرين",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            : const SizedBox(),
                    _.searchController.text.isNotEmpty &&
                            _.selectedExercise.isEmpty
                        ? Center(
                            child: Text(
                              context.locale.languageCode == 'ar'
                                  ? "لا يوجد تمارين بهذا الإسم"
                                  : "There are no exercises with this name",
                            ),
                          )
                        : _.selectedExercise == null ||
                                _.selectedExercise.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            100.h),
                                child: Center(
                                  child: Text(tr('no_exercises')),
                                  // child: Text('لا يوجد تمارين'),
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                  controller: _controller,
                                  itemCount: loadedExercise.length,
                                  itemBuilder: (context, index) {
                                    assets.clear();
                                    if (loadedExercise[index].assets != null &&
                                        loadedExercise[index].assets!.length ==
                                            2) {
                                      assets = distributeAssets(
                                        loadedExercise[index].assets!,
                                        // setFullScreen: setFullScreen,
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          To(
                                            ExerciseArticlesDetailsScreen(
                                              category: widget.exercise,
                                              exercise: loadedExercise[index],
                                              isAll: widget.isAll,
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              elevation: 7,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ExerciseCard(
                                                  // onEnterFullScreen:
                                                  //     setFullScreen,
                                                  // onExitFullScreen:
                                                  //     setFullScreen,
                                                  height: height,
                                                  width: width,
                                                  exercise:
                                                      loadedExercise[index],
                                                  assets: assets,
                                                  current: _current,
                                                  updateCurrent: (value) =>
                                                      _current = value,
                                                ),
                                              ),
                                            ),
                                            Provider.of<UserProvider>(context,
                                                            listen: false)
                                                        .isAdmin &&
                                                    !widget.isAll
                                                ? Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          Widget cancelButton =
                                                              TextButton(
                                                            child: Text(
                                                                tr('cancel')),
                                                            onPressed: () {
                                                              pop();
                                                            },
                                                          );
                                                          Widget
                                                              continueButton =
                                                              TextButton(
                                                            child: Text(tr(
                                                                'confirm_deletion')),
                                                            onPressed: () {
                                                              pop();

                                                              _.deleteExercise(
                                                                  exercise:
                                                                      loadedExercise[
                                                                          index],
                                                                  category: widget
                                                                      .exercise);
                                                            },
                                                          );

                                                          showDialog(
                                                              context: navigationKey
                                                                  .currentState!
                                                                  .context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          tr('confirm_deletion'),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                        content:
                                                                            Text(
                                                                          context.locale.languageCode == 'ar'
                                                                              ? 'هل انت متأكد من حذف التمرين المنزلي ؟'
                                                                              : 'Are you sure you want to delete the home exercise ?',
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                        ),
                                                                        actions: [
                                                                          cancelButton,
                                                                          continueButton,
                                                                        ],
                                                                        actionsAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                      ));
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 5.h,
                                    );
                                  },
                                ),
                              ), // when the _loadMore function is running
                    if (_isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // When nothing else to load
                    if (_hasNextPage == false)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        color: Colors.white,
                        child: Center(
                          child: Text(context.locale.languageCode == "ar"
                              ? "تم تحميل المحتوي بالكامل"
                              : "You have fetched all of the content"),
                        ),
                      ),
                  ],
                );
        }),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final ExerciseData exercise;
  final List<Widget> assets;
  final double width, height;
  // final Function onEnterFullScreen;
  // final Function onExitFullScreen;
  final int? current;
  final void Function(int)? updateCurrent;

  const ExerciseCard({
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              exercise.title!,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              exercise.description!,
              textAlign: TextAlign.start,
              maxLines: 2,
              style: TextStyle(
                fontSize: 15.spMin,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
