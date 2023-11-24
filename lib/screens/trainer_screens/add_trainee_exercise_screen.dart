import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/exercises_screens/article_assets_view.dart';
import 'package:tamrini/screens/exercises_screens/exercises_home_screen.dart';
import 'package:tamrini/utils/distripute_assets.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/exercise.dart';
import '../../model/trainee_exercise.dart';

class AddTraineeExerciseScreen extends StatefulWidget {
  // final Course course;
  final String dayID;
  final Exercise exercise;
  final bool isAll;
  final bool? superSet;

  const AddTraineeExerciseScreen({
    Key? key,
    // required this.exercise,
    required this.dayID,
    required this.exercise,
    required this.isAll,
    this.superSet,
    // required this.course
  }) : super(key: key);

  @override
  State<AddTraineeExerciseScreen> createState() => _AddTraineeExerciseScreen();
}

class _AddTraineeExerciseScreen extends State<AddTraineeExerciseScreen> {
//! start pagination data
  int _current = 1;
  bool isFullScreen = true;
  List<Widget> assets = [];
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
        appBar: globalAppBar(tr('exercises')),
        // appBar: globalAppBar("التمارين"),
        body: Consumer<TraineeProvider>(builder: (context, _, child) {
          return _.exerciseProvider.isLoading || _isFirstLoadRunning
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : Column(
                  children: [
                    searchBar(_.exerciseProvider.searchController, (value) {
                      widget.isAll
                          ? _.exerciseProvider.searchAll()
                          : _.exerciseProvider.search(widget.exercise.id);
                      _.exerciseProvider.searchAll();
                      _firstLoad();
                    }),
                    (_.exerciseProvider.selectedExercise == null ||
                                _.exerciseProvider.selectedExercise.isEmpty) &&
                            _.exerciseProvider.searchController.text.isNotEmpty
                        ? Center(
                            child: Text(
                              context.locale.languageCode == 'ar'
                                  ? "لا يوجد تمارين بهذا الإسم"
                                  : "There are no exercises with this name",
                            ),
                          )
                        : _.exerciseProvider.selectedExercise == null ||
                                _.exerciseProvider.selectedExercise.isEmpty
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
                                          loadedExercise[index].assets!);
                                    }
                                    return ExerciseCard(
                                      selectedExercise: widget.exercise,
                                      height: height,
                                      width: width,
                                      dayID: widget.dayID,
                                      assets: assets,
                                      traineeProvider: _,
                                      exercise: loadedExercise[index],
                                      current: _current,
                                      updateCurrent: (value) =>
                                          _current = value,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 5.h,
                                    );
                                  },
                                ),
                              ),
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
                        padding: const EdgeInsets.symmetric(vertical: 6),
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

class ExerciseCard extends StatefulWidget {
  final Exercise selectedExercise;
  final ExerciseData exercise;
  // final int index;
  final double width, height;
  final String dayID;
  final List<Widget> assets;
  final TraineeProvider traineeProvider;
  final int? current;
  final void Function(int)? updateCurrent;

  const ExerciseCard(
      {required this.dayID,
      // required this.index,
      required this.assets,
      required this.traineeProvider,
      Key? key,
      required this.exercise,
      this.current,
      this.updateCurrent,
      required this.width,
      required this.height,
      required this.selectedExercise})
      : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool superSetSwitchValue = false;
  bool showSuperSetSwitch = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController setsNoController = TextEditingController();

  TextEditingController repeatNoController = TextEditingController();

  void addExerciseToTrainee(TraineeProvider _) {
    final isValid = _formKey.currentState!.validate();
    _formKey.currentState!.save();

    if (!isValid) {
      return;
    }
    _.addExerciseToTrainee(
        TraineeExercise(
          exercise: widget.exercise,
          setsNo: int.parse(setsNoController.text),
          repeatNo: int.parse(repeatNoController.text),
        ),
        widget.dayID);

    setState(() {
      showSuperSetSwitch = true;
    });
  }

  void removeExerciseFromTrainee() {
    widget.traineeProvider.removeExerciseFromTrainee(
      widget.exercise,
      widget.dayID,
    );

    setState(() {
      showSuperSetSwitch = false;
    });
  }

  void removeSuperSetExerciseFromTrainee() {
    widget.traineeProvider.removeSuperSetFromExercise(
      widget.exercise,
      widget.dayID,
    );
  }

  @override
  void dispose() {
    setsNoController.dispose();
    repeatNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            widget.traineeProvider.newDayWeekExercises[widget.dayID]!
                    .map((traineeExercise) => traineeExercise.exercise)
                    .contains(widget.exercise)
                ? widget.traineeProvider
                    .removeExerciseFromTrainee(widget.exercise, widget.dayID)
                : addExerciseToTrainee(widget.traineeProvider);
          },
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.exercise.assets == null ||
                              widget.exercise.assets!.isEmpty
                          ? const SizedBox()
                          : VideoViewer(
                              title: widget.exercise.title ?? "",
                              width: width,
                              height: height,
                              imageUrl: widget.exercise.assets!.first,
                              videourl: widget.exercise.assets!.last,
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.exercise.title!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.exercise.description!,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15.sm,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                controller: setsNoController,
                                decoration: InputDecoration(
                                  labelText: tr('sets_number'),
                                  // labelText: 'عدد المجموعات',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _formKey.currentState!.validate();
                                },
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Flexible(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                controller: repeatNoController,
                                decoration: InputDecoration(
                                  labelText: tr('repetitions_number'),
                                  // labelText: 'عدد مرات التكرار',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                onChanged: (idNumber) {
                                  _formKey.currentState!.validate();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      if (showSuperSetSwitch == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.sports_gymnastics,
                                  ),
                                  SizedBox(
                                    width: 15.h,
                                  ),
                                  Text(
                                    context.locale.languageCode == 'ar'
                                        ? 'سوبر سيت'
                                        : 'Superset',
                                    // 'سوبر سيت',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'cairo',
                                    ),
                                  ),
                                  const Spacer(),
                                  CupertinoSwitch(
                                    value: superSetSwitchValue,
                                    onChanged: (value) {
                                      if (value == true) {
                                        ExerciseProvider _ = widget
                                            .traineeProvider.exerciseProvider;
                                        _.moveToExercise(
                                            widget.selectedExercise,
                                            isAll: true,
                                            isAdd: true,
                                            dayID: widget.dayID,
                                            superSet: true,
                                            mainExercise: widget.exercise);
                                        // To(ExercisesHomeScreen(
                                        //   isCourse: true,
                                        //   dayID: widget.dayID,
                                        //   mainExercise: widget.exercise,
                                        //   superSet: true,
                                        // ));
                                      } else {
                                        // remove superset
                                        removeSuperSetExerciseFromTrainee();
                                      }
                                      setState(() {
                                        superSetSwitchValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (widget
                                          .traineeProvider
                                          .newDayWeekExercises[widget.dayID]
                                          ?.isNotEmpty ==
                                      true &&
                                  widget.traineeProvider.exerciseProvider
                                      .selectedExercise.isNotEmpty)
                                Text(
                                  widget.traineeProvider
                                          .newDayWeekExercises[widget.dayID]!
                                          .firstWhere((traineeExercise) =>
                                              traineeExercise.exercise!.id ==
                                              widget.exercise.id)
                                          .superSetExercise
                                          ?.title ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo',
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Checkbox(
                    value: widget
                        .traineeProvider.newDayWeekExercises[widget.dayID]!
                        .map((traineeExercise) => traineeExercise.exercise)
                        .contains(widget.exercise),
                    onChanged: (value) {
                      value != true
                          ? removeExerciseFromTrainee()
                          : addExerciseToTrainee(widget.traineeProvider);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class VideoWidget extends StatelessWidget {
//   final ExerciseData exercise;
//   final List<Widget> assets;
//   final double width, height;
//   final Function onEnterFullScreen;
//   final Function onExitFullScreen;
//   final int? current;
//   final void Function(int)? updateCurrent;

//   const VideoWidget({
//     required this.onEnterFullScreen,
//     required this.onExitFullScreen,
//     required this.exercise,
//     required this.assets,
//     required this.width,
//     required this.height,
//     this.current,
//     this.updateCurrent,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return (assets.isNotEmpty)
//         ? VideoViewer(
//             title: exercise.title ?? "",
//             // onEnterFullScreen: onEnterFullScreen,
//             // onExitFullScreen: onExitFullScreen,
//             width: width,
//             height: height,
//             imageUrl: exercise.assets!.first,
//             videourl: exercise.assets!.last,
//           )
//         : const SizedBox();
//   }
// }
