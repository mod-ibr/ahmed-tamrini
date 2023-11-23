import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/supplement_provider.dart';

import '../../provider/trainee_provider.dart';
import '../../utils/distripute_assets.dart';
import '../../utils/widgets/custom_image_slide_show.dart';
import '../../utils/widgets/global Widgets.dart';

class AddTraineeSupplementScreen extends StatefulWidget {
  final Supplement supplement;
  final bool isAll;

  const AddTraineeSupplementScreen(
      {required this.supplement, required this.isAll, Key? key})
      : super(key: key);

  @override
  State<AddTraineeSupplementScreen> createState() =>
      _AddTraineeSupplementScreenState();
}

class _AddTraineeSupplementScreenState
    extends State<AddTraineeSupplementScreen> {
  @override
  void dispose() {
    Provider.of<SupplementProvider>(navigationKey.currentContext!,
            listen: false)
        .clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: globalAppBar("المكملات الغذائية", actions: [
          IconButton(
            icon: Icon(Icons.save),
            color: Colors.white,
            onPressed: () async {
              await Provider.of<TraineeProvider>(context, listen: false)
                  .addSupplementsToTrainee();

              await Provider.of<TraineeProvider>(context, listen: false)
                  .saveChangedSelectedTraineeData();
            },
          ),
        ]),
        body: Consumer<TraineeProvider>(builder: (context, _, child) {
          return _.supplementProvider.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      searchBar(_.supplementProvider.searchController, (value) {
                        widget.isAll
                            ? _.supplementProvider.searchAll()
                            : _.supplementProvider
                                .search(widget.supplement.title!);
                        _.supplementProvider.searchAll();
                      }),
                      (_.supplementProvider.selectedSupplement == null ||
                                  _.supplementProvider.selectedSupplement
                                      .isEmpty) &&
                              !_.supplementProvider.searchController.text
                                  .isEmpty
                          ? Center(
                              child: Text(
                                context.locale.languageCode == 'ar'
                                    ? "لا يوجد مكمل غذائي بهذا الإسم"
                                    : "There is no nutritional supplement with this name",
                              ),
                            )
                          : _.supplementProvider.selectedSupplement == null ||
                                  _.supplementProvider.selectedSupplement
                                      .isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                              2 -
                                          100.h),
                                  child: const Center(
                                    child: Text('لا يوجد مكمل غذائي'),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    List<Widget> assets = [];
                                    if (_.supplementProvider
                                            .selectedSupplement[index].images !=
                                        null) {
                                      assets = distributeAssets(_
                                          .supplementProvider
                                          .selectedSupplement[index]
                                          .images! as List<String>);
                                    }
                                    return SupplementCard(
                                      index: index,
                                      exercise: _.supplementProvider
                                          .selectedSupplement[index],
                                      traineeProvider: _,
                                    );
                                  },
                                  itemCount: _.supplementProvider
                                      .selectedSupplement.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 5.h,
                                    );
                                  },
                                )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}

class SupplementCard extends StatefulWidget {
  final int index;
  final SupplementData exercise;
  final TraineeProvider traineeProvider;

  const SupplementCard(
      {required this.index,
      required this.exercise,
      required this.traineeProvider,
      Key? key})
      : super(key: key);

  @override
  _SupplementCardState createState() => _SupplementCardState();
}

class _SupplementCardState extends State<SupplementCard> {
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

  @override
  void initState() {
    super.initState();
  }

  void _addSupplementToTrainee(TraineeProvider traineeProvider, index) {
    traineeProvider.addSupplementToTrainee(
      traineeProvider.supplementProvider.selectedSupplement[index],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.traineeProvider.supplements
                  .map((supplement) => supplement.id)
                  .contains(widget.traineeProvider.supplementProvider
                      .selectedSupplement[widget.index].id)
              ? widget.traineeProvider.removeSupplementFromTrainee(
                  widget.traineeProvider.supplementProvider
                      .selectedSupplement[widget.index],
                )
              : _addSupplementToTrainee(widget.traineeProvider, widget.index);
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
                    widget.traineeProvider.supplementProvider
                                    .selectedSupplement[widget.index].images ==
                                null ||
                            widget
                                .traineeProvider
                                .supplementProvider
                                .selectedSupplement[widget.index]
                                .images!
                                .isEmpty
                        ? const SizedBox()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CustomImageSlideShow(
                              // onEnterFullScreen: setFullScreen,
                              // onExitFullScreen: setFullScreen,
                              assets: widget.traineeProvider.supplementProvider
                                  .selectedSupplement[widget.index].images!,
                              updateCurrent: (value) => _current = value,
                            ),

                            //  CustomImageSlideShow(
                            //   assets: widget.traineeProvider.supplementProvider
                            //       .selectedSupplement[widget.index].images!,
                            //   children: widget.assets,
                            // ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.traineeProvider.supplementProvider
                              .selectedSupplement[widget.index].title!,
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
                          widget.traineeProvider.supplementProvider
                              .selectedSupplement[widget.index].description!,
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
                  value: widget.traineeProvider.supplements
                      .map((supplement) => supplement.id)
                      .contains(widget.traineeProvider.supplementProvider
                          .selectedSupplement[widget.index].id),
                  onChanged: (value) {
                    value != true
                        ? widget.traineeProvider.removeSupplementFromTrainee(
                            widget.traineeProvider.supplementProvider
                                .selectedSupplement[widget.index])
                        : _addSupplementToTrainee(
                            widget.traineeProvider, widget.index);
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
