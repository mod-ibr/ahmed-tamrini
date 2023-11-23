import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/questions_proviser.dart';
import 'package:tamrini/screens/question_screens/Add_question_screen.dart';
import 'package:tamrini/screens/question_screens/question_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  void dispose() {
    Provider.of<QuestionsProvider>(navigationKey.currentContext!, listen: false)
        .clearSearch();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('questions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          To(const AddQuestionScreen());
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
        ),
      ),
      // appBar: globalAppBar("الأسئلة"),
      body: Consumer<QuestionsProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    searchBar(_.searchController, (p0) => _.filterQuestions()),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 30.0.w, vertical: 10.h),
                    //   child: MaterialButton(
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10.0)),
                    //       color: kSecondaryColor!,
                    //       padding: EdgeInsets.symmetric(vertical: 5.h),
                    //       onPressed: () {
                    //         To(const AddQuestionScreen());
                    //       },
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const Padding(
                    //             padding: EdgeInsetsDirectional.only(end: 8.0),
                    //             child:
                    //                 Icon(Icons.add_circle, color: Colors.white),
                    //           ),
                    //           Text(
                    //             tr('add_question'),
                    //             // "أضف سؤالك",
                    //             style: TextStyle(
                    //                 fontSize: 18.sp, color: Colors.white),
                    //           ),
                    //         ],
                    //       )),
                    // ),

                    _.searchController.text.isNotEmpty &&
                            _.filteredQuestions.isEmpty
                        ? Text(
                            tr('no_results'),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : _.filteredQuestions.isNotEmpty
                            ? ListView.separated(
                                itemCount: _.filteredQuestions.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 15.h),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        To(QuestionDetailsScreen(
                                          indexs: index,
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 10.w),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                              color: kPrimaryColor
                                                  .withOpacity(0.4)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color:
                                          //         Colors.grey.withOpacity(0.5),
                                          //     spreadRadius: 2,
                                          //     blurRadius: 5,
                                          //     offset: const Offset(0,
                                          //         3), // changes position of shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kSecondaryColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 3.h,
                                                horizontal: 3.w,
                                              ),
                                              child: imageAvatar(
                                                  profileImageUrl: _
                                                      .filteredQuestions[index]
                                                      .askerProfileImageUrl),

                                              // FaIcon(
                                              //   FontAwesomeIcons.user,
                                              //   size: 18.sp,
                                              //   color: Colors
                                              //       .white, // Customize the avatar icon color as needed
                                              // ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    _.filteredQuestions[index]
                                                        .askerUsername,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    _.filteredQuestions[index]
                                                        .title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    _.filteredQuestions[index]
                                                        .body,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .comment,
                                                            size: 15.sp,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 5.w),
                                                          Text(
                                                            _
                                                                .filteredQuestions[
                                                                    index]
                                                                .answers
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(child: Text(tr('no_questions'))),
                    // : const Center(child: Text("لا يوجد اسئلة")),
                  ],
                ),
              );
      }),
    );
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
