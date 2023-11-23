import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/data/user_data.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/home_provider.dart';
import 'package:tamrini/provider/questions_proviser.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/loading_widget.dart';

import '../../utils/constants.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final int indexs;

  const QuestionDetailsScreen({Key? key, required this.indexs})
      : super(key: key);

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: globalAppBar(tr('question_details')),
        // appBar: globalAppBar(" تفاصيل السؤال"),
        body: isLoading
            ? const Center(
                child: LoadingWidget(),
              )
            : Consumer<QuestionsProvider>(builder: (context, _, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            String? username = _
                                .filteredQuestions[widget.indexs].askerUsername;
                            log("######### username : $username");
                            if (username != null) {
                              UserData userData = UserData();
                              log("Asker UserNae : $username");
                              User? user =
                                  await userData.fetchUserByUsername(username);
                              if (user != null) {
                                To(ProfileScreen(user: user));
                              } else {
                                Fluttertoast.showToast(
                                  msg: context.locale.languageCode == 'ar'
                                      ? 'لا يمكن الوصول الى الملف الشخصي'
                                      : "Can't Go To this User Account",
                                );
                                log("Can't Go To this User Account");
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: context.locale.languageCode == 'ar'
                                    ? 'لا يمكن الوصول الى الملف الشخصي'
                                    : "Can't Go To this User Account",
                              );
                              log("Can't Go To this User Account");
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(3.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kSecondaryColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 3.w),
                                  child: imageAvatar(
                                      profileImageUrl: _
                                          .filteredQuestions[widget.indexs]
                                          .askerProfileImageUrl),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _.filteredQuestions[widget.indexs]
                                                .askerUsername,
                                            style: TextStyle(fontSize: 15.sp),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.parse(
                                              _.filteredQuestions[widget.indexs]
                                                  .date
                                                  .toDate()
                                                  .toString(),
                                            )),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        _.filteredQuestions[widget.indexs]
                                            .title,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        _.filteredQuestions[widget.indexs].body,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .isAdmin
                                              ? IconButton(
                                                  onPressed: () {
                                                    Provider.of<HomeProvider>(
                                                            context,
                                                            listen: false)
                                                        .banUser(
                                                            username: _
                                                                .filteredQuestions[
                                                                    widget
                                                                        .indexs]
                                                                .askerUsername);
                                                  },
                                                  icon: const Icon(
                                                    Icons.no_accounts_sharp,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Container(),
                                          Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .isAdmin
                                              ? IconButton(
                                                  onPressed: () {
                                                    _.deleteQuestion(_
                                                        .filteredQuestions[
                                                            widget.indexs]
                                                        .id);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.comments),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              tr('answers'),
                              // "الإجابات",
                              style: TextStyle(fontSize: 25.spMin),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "(${_.filteredQuestions[widget.indexs].answers.length})",
                              style: TextStyle(fontSize: 25.spMin),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.white12,
                            thickness: 1,
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _.filteredQuestions[widget.indexs].answers.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                String? username = _
                                    .filteredQuestions[widget.indexs]
                                    .answers[index]
                                    .username;
                                if (username != null) {
                                  UserData userData = UserData();
                                  User? user = await userData
                                      .fetchUserByUsername(username);
                                  if (user != null) {
                                    To(ProfileScreen(user: user));
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: context.locale.languageCode == 'ar'
                                          ? 'لا يمكن الوصول الى الملف الشخصي'
                                          : "Can't Go To this User Account",
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: context.locale.languageCode == 'ar'
                                        ? 'لا يمكن الوصول الى الملف الشخصي'
                                        : "Can't Go To this User Account",
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.all(3.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kSecondaryColor,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: imageAvatar(
                                          profileImageUrl: _
                                                  .filteredQuestions[
                                                      widget.indexs]
                                                  .answers[index]
                                                  .profileImageUrl ??
                                              ""),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _
                                                    .filteredQuestions[
                                                        widget.indexs]
                                                    .answers[index]
                                                    .username!,
                                                style:
                                                    TextStyle(fontSize: 15.sp),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime.parse(
                                                  _
                                                      .filteredQuestions[
                                                          widget.indexs]
                                                      .answers[index]
                                                      .date!
                                                      .toDate()
                                                      .toString(),
                                                )),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            _.filteredQuestions[widget.indexs]
                                                .answers[index].answer!,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Provider.of<UserProvider>(context,
                                                          listen: false)
                                                      .isAdmin
                                                  ? IconButton(
                                                      onPressed: () {
                                                        _.deleteAnswer(
                                                            _.filteredQuestions[
                                                                widget.indexs],
                                                            _
                                                                .filteredQuestions[
                                                                    widget
                                                                        .indexs]
                                                                .answers[index]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : Container(),
                                              Provider.of<UserProvider>(context,
                                                          listen: false)
                                                      .isAdmin
                                                  ? IconButton(
                                                      onPressed: () {
                                                        Provider.of<HomeProvider>(
                                                                context,
                                                                listen: false)
                                                            .banUser(
                                                          username: _
                                                              .filteredQuestions[
                                                                  widget.indexs]
                                                              .answers[index]
                                                              .username!,
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.no_accounts_sharp,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: tr('add_answer'),
                                  // hintText: "إضافة إجابة",
                                  border: const OutlineInputBorder(
                                      // borderSide: BorderSide(color: Colors.white),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _.addAnswer(_.filteredQuestions[widget.indexs],
                                    controller.text);
                                controller.clear();
                              },
                              child: Text(
                                tr('add'),
                                // "إضافة",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
