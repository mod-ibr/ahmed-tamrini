import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/Add_gym_screen.dart';
import 'package:tamrini/screens/gym_screens/gym_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/gym.dart';
import '../../utils/distripute_assets.dart';

class GymsScreen extends StatefulWidget {
  const GymsScreen({Key? key}) : super(key: key);

  @override
  State<GymsScreen> createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  //! start pagination data
  int _current = 1;
  List<Widget> assets = [];
  final int _limit = 10;
  int counter = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<Gym> loadedGyms = [];
  late ScrollController _controller;

  resetLoadedGyms() {
    loadedGyms = [];
    counter = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
  }

  void _firstLoad() async {
    List<Gym> allGyms =
        Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
            .filteredGyms;
    resetLoadedGyms();
    TextEditingController searchController =
        Provider.of<GymProvider>(context, listen: false).searchController;
    if (searchController.text.trimRight().trimLeft().isEmpty) {
      await Future.delayed(Duration.zero)
          .then((value) => setState(() => _isFirstLoadRunning = true));
    }

    await Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        loadedGyms = allGyms.sublist(
          0,
          _limit <= allGyms.length ? _limit : allGyms.length,
        );

        counter += _limit;
        log("Counter Value : $counter");

        setState(() => _isFirstLoadRunning = false);
      },
    );
  }

  void _loadMore() async {
    List<Gym> allGyms =
        Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
            .filteredGyms;
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() => _isLoadMoreRunning = true);
      await Future.delayed(const Duration(seconds: 2));
      final List<Gym> fetchedPosts = getNextItems(allGyms, counter);
      if (fetchedPosts.isNotEmpty) {
        counter += _limit;
        setState(() {
          log("THe all List lenght : ${allGyms.length}");
          log("THe loaded List lenght BEFORE ADDING : ${loadedGyms.length}");
          loadedGyms.addAll(fetchedPosts);
          log("THe loaded List lenght After ADDING : ${loadedGyms.length}");

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

  List<Gym> getNextItems(List<Gym> selectedGyms, int startIndex) {
    final endIndex = startIndex + _limit;

    if (startIndex >= selectedGyms.length) {
      // No more items to load, return an empty list
      return [];
    }

    final nextItems = selectedGyms.sublist(
      startIndex,
      endIndex <= selectedGyms.length ? endIndex : selectedGyms.length,
    );

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
    Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
        .clearSearch();

    _controller.removeListener(_loadMore);
    super.dispose();
  }

  //! End pagination data
  List sortBy = [
    tr('lowest_price'),
    // 'الأقل سعراً',
    tr('highest_price'),
    // 'الأعلى سعراً',
    tr('closest'),
    // 'الأقرب',
    tr('farthest'),
    // 'الأبعد',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final getHeight = mediaQuery.size.height;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('gyms')),
      // appBar: globalAppBar("صالات الجيم"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<GymProvider>(builder: (context, _, child) {
          return _.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchBar(_.searchController, (value) {
                        print(value);
                        _.searchGym();
                        _firstLoad();
                      }),
                      (Provider.of<UserProvider>(context, listen: false)
                                  .isAdmin ||
                              !Provider.of<UserProvider>(context, listen: false)
                                  .isGymOwner)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ((userProvider.isAdmin) ||
                                        (!userProvider.isGymOwner))
                                    ? MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: kSecondaryColor!,
                                        onPressed: () {
                                          To(const AddGymScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      end: 8.0),
                                              child: Icon(Icons.add_circle,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              (userProvider.isAdmin)
                                                  ? tr('add_gym')
                                                  // ? "اضافة صالة جديدة"
                                                  : tr('promote_to_gym_owner'),
                                              // : "ترقية الي صاحب صالة",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          : const SizedBox(),
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        hint: Text(
                          tr('sort_by'),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                        iconDisabledColor: Colors.grey,
                        iconEnabledColor: kPrimaryColor,
                        value: _.selectedSortBy,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: kPrimaryColor),
                        underline: Container(
                          height: 2,
                          color: kPrimaryColor,
                        ),
                        onChanged: (String? newValue) {
                          _.changeSelectedSortBy(newValue);
                        },
                        items: sortBy.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            onTap: () {
                              _.changeSelectedSortBy(value);
                            },
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      _.searchController.text.isNotEmpty &&
                              _.filteredGyms.isEmpty
                          ? Center(
                              child: Text(
                                context.locale.languageCode == 'ar'
                                    ? "لا يوجد جيم بهذا الإسم"
                                    : 'No gym founded by this name',
                              ),
                            )
                          : _.filteredGyms.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    controller: _controller,
                                    itemCount: loadedGyms.length,
                                    itemBuilder: (context, index) {
                                      assets.clear();
                                      assets = distributeAssets(
                                          loadedGyms[index].assets);

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: getHeight * 0.3,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            onTap: () {
                                              To(GymDetailsScreen(
                                                  gym: loadedGyms[index],
                                                  isAll: false));
                                            },
                                            child: Stack(
                                              children: [
                                                loadedGyms[index].assets.isEmpty
                                                    ? const SizedBox.shrink()
                                                    : SizedBox(
                                                        height: getHeight * 0.3,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          child: ImageSlideshow(
                                                            children: assets,
                                                          ),
                                                        ),
                                                      ),
                                                Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .isAdmin
                                                    ? Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Widget
                                                                  cancelButton =
                                                                  TextButton(
                                                                child: Text(tr(
                                                                    'cancel')),
                                                                onPressed: () {
                                                                  pop();
                                                                },
                                                              );
                                                              Widget
                                                                  continueButton =
                                                                  TextButton(
                                                                child: Text(
                                                                    tr(
                                                                        'confirm_deletion'),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                                onPressed: () {
                                                                  pop();
                                                                  _.rejectGym(
                                                                      gym: loadedGyms[
                                                                          index],
                                                                      userProvider:
                                                                          userProvider);
                                                                },
                                                              );

                                                              showDialog(
                                                                  context:
                                                                      navigationKey
                                                                          .currentContext!,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                            title:
                                                                                Text(
                                                                              tr('confirm_deletion'),
                                                                              textAlign: TextAlign.right,
                                                                            ),
                                                                            content:
                                                                                Text(
                                                                              '${context.locale.languageCode == 'ar' ? 'هل انت متأكد من حذف صالة' : 'Are you sure you want to delete the gym'} ${loadedGyms[index].name} ?',
                                                                              textAlign: TextAlign.right,
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
                                                              Icons
                                                                  .delete_forever,
                                                              color: Colors.red,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  left: 0,
                                                  child: Container(
                                                    // height: getHeight * 0.1,
                                                    // width: getWidht * 0.7,
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: double.infinity,
                                                      maxHeight:
                                                          double.infinity,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blueGrey[500],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.blueGrey[900]!
                                                              .withOpacity(0.0),
                                                          Colors.blueGrey[500]!
                                                              .withOpacity(0.5),
                                                          Colors.blueGrey[500]!
                                                              .withOpacity(0.8),
                                                          Colors.blueGrey[500]!
                                                              .withOpacity(1.0),
                                                        ],
                                                      ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          spreadRadius: 5,
                                                          blurRadius: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    child: SafeArea(
                                                      minimum:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AutoSizeText(
                                                            loadedGyms[index]
                                                                .name,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .location_on,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 15.sp,
                                                                  ),
                                                                  Text(
                                                                    "${loadedGyms[index].distance.toPrecision(3)} ${context.locale.languageCode == 'ar' ? 'كم' : 'km'} ",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Spacer(),

                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    " ${loadedGyms[index].price} ${context.locale.languageCode == 'ar' ? 'دينار عراقي' : 'Iraqi Dinar'} ",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                )
                              : Center(
                                  child: Text(
                                    tr('no_results'),
                                  ),
                                ),
                      // when the _loadMore function is running
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
                  ),
                );
        }),
      ),
    );
  }
}
