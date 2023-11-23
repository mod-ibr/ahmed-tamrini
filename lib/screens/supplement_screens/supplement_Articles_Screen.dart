import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/supplement_screens/Add_supplement_screen.dart';
import 'package:tamrini/screens/supplement_screens/supplements_Article_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/distripute_assets.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class SupplementArticlesScreen extends StatefulWidget {
  final Supplement supplement;

  const SupplementArticlesScreen({Key? key, required this.supplement})
      : super(key: key);

  @override
  State<SupplementArticlesScreen> createState() =>
      _SupplementArticlesScreenState();
}

class _SupplementArticlesScreenState extends State<SupplementArticlesScreen> {
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
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('nutritional_supplements')),
        // appBar: globalAppBar("المكملات الغذائية"),
        body: Consumer<SupplementProvider>(builder: (context, _, child) {
          return _.isLoading
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
                      searchBar(_.searchController, (value) {
                        _.search(widget.supplement.title!);
                      }),
                      Provider.of<UserProvider>(context, listen: false).isAdmin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () {
                                      To(AddSupplementScreen(
                                          category: widget.supplement));
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
                                          tr('add_supplement'),
                                          // "إضافة مكمل غذائي",
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
                              _.selectedSupplement.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 2 -
                                      100.h),
                              child: Center(
                                child: Text(
                                  context.locale.languageCode == 'ar'
                                      ? 'لا يوجد مكمل غذائي بهذا الاسم'
                                      : 'There is no nutritional supplement with this name',
                                ),
                              ),
                            )
                          : _.selectedSupplement == null ||
                                  _.selectedSupplement.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                              2 -
                                          100.h),
                                  child: Center(
                                    child: Text(tr('no_supplements')),
                                    // child: Text('لا يوجد مكملات غذائية'),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    List<Widget> assets = [];
                                    if (_.selectedSupplement[index].images !=
                                        null) {
                                      assets = distributeAssets(
                                          _.selectedSupplement[index].images!);
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          To(
                                            SupplementArticlesDetailsScreen(
                                              category: widget.supplement,
                                              supplement:
                                                  _.selectedSupplement[index],
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
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    _.selectedSupplement[index]
                                                                    .images ==
                                                                null ||
                                                            _
                                                                .selectedSupplement[
                                                                    index]
                                                                .images!
                                                                .isEmpty
                                                        ? const SizedBox()
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                ImageSlideshow(
                                                                    children:
                                                                        assets),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              right: 10),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Text(
                                                          _
                                                              .selectedSupplement[
                                                                  index]
                                                              .title!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Text(
                                                          _
                                                              .selectedSupplement[
                                                                  index]
                                                              .description!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 15.sm,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors
                                                                .grey.shade500,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .isAdmin
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

                                                              _.deleteSupplement(
                                                                  supplement:
                                                                      _.selectedSupplement[
                                                                          index],
                                                                  category: widget
                                                                      .supplement);
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
                                                                              ? 'هل انت متأكد من حذف المكمل الغذائي ؟'
                                                                              : 'Are you sure to remove the nutritional supplement?',
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
                                  itemCount: _.selectedSupplement.length,
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
