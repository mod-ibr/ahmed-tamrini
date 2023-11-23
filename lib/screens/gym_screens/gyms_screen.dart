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

import '../../utils/distripute_assets.dart';

class GymsScreen extends StatefulWidget {
  const GymsScreen({Key? key}) : super(key: key);

  @override
  State<GymsScreen> createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  List sortBy = [
    tr('lowest_price'),
    // 'الأقل سعراً',
    tr('highest_price'),
    // 'الأعلى سعراً',
    tr('closest'),
    // 'الأقرب',
    tr('furthest'),
    // 'الأبعد',
  ];

  @override
  void dispose() {
    Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
        .clearSearch();

    super.dispose();
  }

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
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchBar(_.searchController, (p0) => _.searchGym()),
                        (Provider.of<UserProvider>(context, listen: false)
                                    .isAdmin ||
                                !Provider.of<UserProvider>(context,
                                        listen: false)
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
                                                    : tr(
                                                        'promote_to_gym_owner'),
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color),
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

// SizedBox(
//                             height: 50.h,
//                             child: ListView(
//
//                                 scrollDirection: Axis.horizontal,
//
//                                 children : [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: InkWell(
//                                       onTap: () {
//                                         _.sortByPrice(isAscending:  false) ;                                    },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           border: Border.all(color: kSecondaryColor!),
//                                             // color: _.catSelected == index
//                                             //     ? kSecondaryColor!
//                                             //     : Colors.white,
//                                             borderRadius: BorderRadius.circular(10)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Center(
//                                             child: Text(
//                                               "السعر",
//                                               style: TextStyle(
//                                                   // color: _.catSelected == index
//                                                   //     ? Colors.white
//                                                   //     : Colors.black
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: InkWell(
//                                       onTap: () {
//                                         _.sortByDistance(isAscending:  false) ;                                    },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(color: kSecondaryColor!),
//                                             // color: _.catSelected == index
//                                             //     ? kSecondaryColor!
//                                             //     : Colors.white,
//                                             borderRadius: BorderRadius.circular(10)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Center(
//                                             child: Text(
//                                               "المسافة",
//                                               style: TextStyle(
//                                                 // color: _.catSelected == index
//                                                 //     ? Colors.white
//                                                 //     : Colors.black
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),]
//                             ),
//                           ),
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
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      List<Widget> assets = [];
                                      assets = distributeAssets(
                                          _.filteredGyms[index].assets);

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: getHeight * 0.3,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            onTap: () {
                                              To(GymDetailsScreen(
                                                  gym: _.filteredGyms[index],
                                                  isAll: false));
                                            },
                                            child: Stack(
                                              children: [
                                                _.filteredGyms[index].assets
                                                        .isEmpty
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        // width: getWidht,
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
                                                                      gym: _.filteredGyms[
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
                                                                              '${context.locale.languageCode == 'ar' ? 'هل انت متأكد من حذف صالة' : 'Are you sure you want to delete the gym'} ${_.filteredGyms[index].name} ?',
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
                                                            _
                                                                .filteredGyms[
                                                                    index]
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
                                                                    "${_.filteredGyms[index].distance.toPrecision(3)} ${context.locale.languageCode == 'ar' ? 'كم' : 'km'} ",
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
                                                                    " ${_.filteredGyms[index].price} ${context.locale.languageCode == 'ar' ? 'دينار عراقي' : 'Iraqi Dinar'} ",
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
                                      // return Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //
                                      //       To(GymDetailsScreen(
                                      //         gym: _
                                      //             .filteredGyms[index],
                                      //       ));
                                      //     },
                                      //     child: Stack(
                                      //       children: [
                                      //         Card(
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(15),
                                      //           ),
                                      //           elevation: 7,
                                      //           child: Padding(
                                      //             padding:
                                      //                 const EdgeInsets.all(8.0),
                                      //             child: Column(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment.start,
                                      //               children: [
                                      //                 _
                                      //                             .filteredGyms[
                                      //                                 index]
                                      //                             .assets
                                      //                             .isEmpty
                                      //                     ? const SizedBox()
                                      //                     : ClipRRect(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     10.0),
                                      //                         child: ImageSlideshow(
                                      //                             children: assets,),
                                      //                       ),
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets.only(
                                      //                           top: 10.0,
                                      //                           right: 10),
                                      //                   child: SizedBox(
                                      //                     width: double.infinity,
                                      //                     child: Row(
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceBetween,
                                      //                       children: [
                                      //                         Text(
                                      //                           _
                                      //                               .filteredGyms[
                                      //                                   index]
                                      //                               .name,
                                      //                           textAlign:
                                      //                               TextAlign.start,
                                      //                           style: TextStyle(
                                      //                               fontSize: 20.sp,
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .bold),
                                      //                         ),
                                      //                         // Padding(
                                      //                         //   padding:
                                      //                         //       const EdgeInsets
                                      //                         //           .all(8.0),
                                      //                         //   child: Text(
                                      //                         //     intl.DateFormat(
                                      //                         //             'yyyy-MM-dd')
                                      //                         //         .format(DateTime.parse(_
                                      //                         //             .filteredGyms[
                                      //                         //                 index]
                                      //                         //             .date!
                                      //                         //             .toDate()
                                      //                         //             .toString())),
                                      //                         //     style: TextStyle(
                                      //                         //       fontSize: 15.sp,
                                      //                         //       fontWeight:
                                      //                         //           FontWeight
                                      //                         //               .normal,
                                      //                         //     ),
                                      //                         //   ),
                                      //                         // ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Padding(
                                      //                   padding: const EdgeInsets
                                      //                           .symmetric(
                                      //                       vertical: 10.0,
                                      //                       horizontal: 10),
                                      //                   child: SizedBox(
                                      //                     width: double.infinity,
                                      //                     child: Text(
                                      //                       _
                                      //                           .filteredGyms[
                                      //                               index]
                                      //                           .description,
                                      //                       textAlign:
                                      //                           TextAlign.start,
                                      //                       maxLines: 2,
                                      //                       style: TextStyle(
                                      //                         fontSize: 15.sm,
                                      //                         fontWeight:
                                      //                             FontWeight.normal,
                                      //                         color: Colors
                                      //                             .grey.shade500,
                                      //                         overflow: TextOverflow
                                      //                             .ellipsis,
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      // Provider.of<UserProvider>(context,listen: false).isAdmin?
                                      //
                                      //  Positioned(
                                      //                 top: 0,
                                      //                 left: 0,
                                      //                 child: Padding(
                                      //                   padding:
                                      //                       const EdgeInsets.all(
                                      //                           15),
                                      //                   child: IconButton(
                                      //                     onPressed: () {
                                      //                       Widget cancelButton =
                                      //                           TextButton(
                                      //                         child: const Text(
                                      //                             tr('cancel)),
                                      //                         onPressed: () {
                                      //                           pop();
                                      //                         },
                                      //                       );
                                      //                       Widget continueButton =
                                      //                           TextButton(
                                      //                         child: const Text(
                                      //                             tr('confirm_deletion'),
                                      //                             style: TextStyle(
                                      //                                 color: Colors
                                      //                                     .red)),
                                      //                         onPressed: () {
                                      //                           pop();
                                      //                           _.deleteGym(
                                      //                               _
                                      //                                       .filteredGyms[
                                      //                                           index]
                                      //                                       .id!
                                      //                                   );
                                      //                         },
                                      //                       );
                                      //
                                      //                       showDialog(
                                      //                           context: navigationKey.currentContext!,
                                      //                           builder:
                                      //                               (context) =>
                                      //                                   AlertDialog(
                                      //                                     title:
                                      //                                         const Text(
                                      //                                      tr('confirm_deletion'),
                                      //                                       textAlign:
                                      //                                           TextAlign.right,
                                      //
                                      //                                     ),
                                      //                                     content:
                                      //                                          Text(
                                      //                                       'هل انت متأكد من حذف صالة  ${_.filteredGyms[index].name} ؟',
                                      //                                       textAlign:
                                      //                                           TextAlign.right,
                                      //                                     ),
                                      //                                     actions: [
                                      //                                       cancelButton,
                                      //                                       continueButton,
                                      //                                     ],
                                      //                                     actionsAlignment:
                                      //                                         MainAxisAlignment
                                      //                                             .spaceEvenly,
                                      //                                   ));
                                      //                     },
                                      //                     icon: const Icon(
                                      //                       Icons.delete_forever,
                                      //                       color: Colors.red,
                                      //                       size: 30,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               )
                                      //             : const SizedBox(),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    itemCount: _.filteredGyms.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 5.h,
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      tr('no_results'),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
