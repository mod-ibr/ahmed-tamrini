import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/artical_provider.dart';
import 'package:tamrini/screens/Articles_screens/Article_details_screen.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/distripute_assets.dart';

class PendingArticlesScreen extends StatefulWidget {
  const PendingArticlesScreen({Key? key}) : super(key: key);

  @override
  State<PendingArticlesScreen> createState() => _PendingArticlesScreenState();
}

class _PendingArticlesScreenState extends State<PendingArticlesScreen> {
  TextEditingController searchController = TextEditingController();
  //VideoManager? //VideoManager;

  @override
  void dispose() {
    searchController.dispose();

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
        appBar: globalAppBar(tr('pending_articles')),
        // appBar: globalAppBar("المقالات المعلقة"),
        body: Consumer<ArticleProvider>(builder: (context, _, child) {
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
                      _.pendingArticles.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                List<Widget> assets = [];
                                if (_.pendingArticles[index].image != null) {
                                  assets = distributeAssets(_
                                      .pendingArticles[index]
                                      .image as List<String>);
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      To(ArticleDetailsScreen(
                                        article: _.pendingArticles[index],
                                        type: "pending",
                                        isAll: false,
                                      ));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _.pendingArticles[index].image ==
                                                        null ||
                                                    _.pendingArticles[index]
                                                        .image!.isEmpty
                                                ? const SizedBox()
                                                : Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: ImageSlideshow(
                                                            children: assets),
                                                      ),
                                                    ],
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: AutoSizeText(
                                                  _.pendingArticles[index]
                                                      .title!,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Text(
                                                _.pendingArticles[index].body!,
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15.sm,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      _.approveArticle(
                                                          _.pendingArticles[
                                                              index]);
                                                    },
                                                    child: Text(
                                                      context.locale
                                                                  .languageCode ==
                                                              'ar'
                                                          ? 'قبول'
                                                          : 'Accept',
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                      ),
                                                    )),
                                                MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      _.rejectArticle(_
                                                          .pendingArticles[
                                                              index]
                                                          .id!);
                                                    },
                                                    child: Text(
                                                      context.locale
                                                                  .languageCode ==
                                                              'ar'
                                                          ? 'رفض'
                                                          : 'Reject',
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _.pendingArticles.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 5.h,
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      (MediaQuery.of(context).size.height / 2) -
                                          50.h),
                              child: Center(
                                child: Text(
                                  tr('no_pending_articles'),
                                  // 'لا يوجد مقالات معلقة',
                                  style: TextStyle(fontSize: 22.sp),
                                ),
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
