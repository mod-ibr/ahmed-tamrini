import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/publisherProvider.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AllPublishersScreen extends StatefulWidget {
  const AllPublishersScreen({Key? key}) : super(key: key);

  @override
  State<AllPublishersScreen> createState() => _AllPublishersScreenState();
}

class _AllPublishersScreenState extends State<AllPublishersScreen> {
  @override
  void dispose() {
    Provider.of<PublisherProvider>(navigationKey.currentContext!, listen: false)
        .clearSearch();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Provider.of<PublisherProvider>(context, listen: false)
        .fetchAndSetPublishers();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('all_publishers')),
        // appBar: globalAppBar("جميع الناشرين"),
        body: Consumer<PublisherProvider>(builder: (context, _, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                searchBar(_.searchController, (p0) => _.searchPublisher()),
                const SizedBox(height: 20),
                _.isLoading
                    ? Center(
                        child: Image.asset('assets/images/loading.gif',
                            height: 100.h, width: 100.w),
                      )
                    : _.searchController.text.isNotEmpty && _.publishers.isEmpty
                        ? Center(
                            child: Text(
                              tr('no_results'),
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                          )
                        : _.publishers.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        To(ProfileScreen(
                                            user: _.publishers[index]));
                                      },
                                      title: Text(_.publishers[index].name),
                                      subtitle: Text(
                                        _.publishers[index].description ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: imageAvatar(
                                          profileImageUrl: _
                                              .publishers[index].profileImgUrl),
                                      trailing: IconButton(
                                        onPressed: () {
                                          Widget cancelButton = TextButton(
                                            child: Text(tr("cancel")),
                                            onPressed: () {
                                              pop();
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: Text(tr('confirm_deletion'),
                                                style: const TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              pop();
                                              _.deletePublisher(
                                                  _.publishers[index]);
                                            },
                                          );

                                          showDialog(
                                              context:
                                                  navigationKey.currentContext!,
                                              builder: (context) => AlertDialog(
                                                    title: Text(
                                                      tr('confirm_deletion'),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    content: Text(
                                                      '${context.locale.languageCode == 'ar' ? 'هل انت متأكد من حذف الناشر' : 'Are you sure you want to delete the publisher'}  ${_.publishers[index].name} ?',
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    actions: [
                                                      cancelButton,
                                                      continueButton,
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
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _.publishers.length,
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
          );
        }));
  }

  Widget imageAvatar({required String profileImageUrl}) {
    return CircleAvatar(
      backgroundColor: const Color(0xffdbdbdb),
      radius: 22.w,
      child: ClipOval(
        child: profileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) {
                  if (url.isEmpty) {
                    return Icon(
                      Icons.person_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) => Icon(
                  Icons.person_rounded,
                  size: 20.sp,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
      ),
    );
  }
}
