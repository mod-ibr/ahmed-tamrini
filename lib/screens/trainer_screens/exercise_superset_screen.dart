import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/utils/distripute_assets.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/exercise.dart';
import '../../utils/widgets/custom_image_slide_show.dart';
import '../exercises_screens/article_assets_view.dart';

class ExerciseSupersetScreen extends StatefulWidget {
  final Exercise exercise;
  final ExerciseData? mainExercise;
  final bool isAll;
  final String dayID;

  const ExerciseSupersetScreen({
    Key? key,
    required this.exercise,
    required this.isAll,
    required this.mainExercise,
    required this.dayID,
    // required this.course
  }) : super(key: key);

  @override
  State<ExerciseSupersetScreen> createState() => _ExerciseSupersetScreen();
}

class _ExerciseSupersetScreen extends State<ExerciseSupersetScreen> {
  ExerciseData? selectedExercise;

  void manageSuperSetToTrainee(
    TraineeProvider traineeProvider,
    int index,
    bool value,
  ) {
    log("Value : $value");
    setState(() {
      if (value == true) {
        log("Selected : ${traineeProvider.exerciseProvider.selectedSuperSetExercise[index].title}");

        selectedExercise =
            traineeProvider.exerciseProvider.selectedSuperSetExercise[index];
      } else {
        selectedExercise = null;
      }
    });
  }

//! start pagination data
  int _current = 1;
  bool isFullScreen = true;
  List<Widget> assets = [];
  final int _limit = 10;
  int counter = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<ExerciseData> loadedExercise = []; // ?  Change this Cast
  late ScrollController _controller;

  resetLoadedExercise() {
    loadedExercise = [];
    counter = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
  }

  void _firstLoad() async {
    // ?  Change this Cast
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
    // ?  Change this Cast
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
      final List<ExerciseData> fetchedPosts = // ?  Change this Cast
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

// ?  Change this Cast
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
        appBar: globalAppBar(
          tr('exercises'),
          // "التمارين",
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              color: Colors.white,
              onPressed: () async {
                await Provider.of<TraineeProvider>(context, listen: false)
                    .addSuperSetToExercise(
                  widget.mainExercise,
                  selectedExercise,
                  widget.dayID,
                );
                pop();
              },
            ),
          ],
        ),
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
                    (_.exerciseProvider.selectedSuperSetExercise == null ||
                                _.exerciseProvider.selectedSuperSetExercise
                                    .isEmpty) &&
                            _.exerciseProvider.searchController.text.isNotEmpty
                        ? Center(
                            child: Text(
                              context.locale.languageCode == 'ar'
                                  ? "لا يوجد تمارين بهذا الإسم"
                                  : "There are no exercises with this name",
                            ),
                          )
                        : _.exerciseProvider.selectedSuperSetExercise == null ||
                                _.exerciseProvider.selectedSuperSetExercise
                                    .isEmpty
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
                                      traineeProvider: _,
                                      onSelectExercise: (value) =>
                                          manageSuperSetToTrainee(
                                              _, index, value),
                                      selectedExercise: selectedExercise,
                                      height: height,
                                      width: width,
                                      dayID: widget.dayID,
                                      assets: assets,
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
                              )
                  ],
                );
        }),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final ExerciseData? selectedExercise;
  final void Function(bool) onSelectExercise;
  final ExerciseData exercise;
  final double width, height;
  final String dayID;
  final List<Widget> assets;
  final TraineeProvider traineeProvider;
  final int? current;
  final void Function(int)? updateCurrent;
  const ExerciseCard(
      {required this.assets,
      required this.traineeProvider,
      required this.selectedExercise,
      required this.onSelectExercise,
      Key? key,
      required this.exercise,
      required this.width,
      required this.height,
      required this.dayID,
      this.current,
      this.updateCurrent})
      : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          print('from tap');
          widget.onSelectExercise(true);
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

                    // CustomImageSlideShow(
                    //     assets: widget.exercise.assets!,
                    //     updateCurrent: (value) => _current = value,
                    //   ),

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
                        )),
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
                  value: widget.selectedExercise?.id == widget.exercise.id,
                  onChanged: (value) {
                    print('checkbox checked: ${value}');
                    widget.onSelectExercise(value == true);

                    // TODO check here to add setState and after is selected check to add the value in the provider like other props
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
