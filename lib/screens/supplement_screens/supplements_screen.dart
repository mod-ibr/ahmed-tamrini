import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/supplement_screens/Add_supplement_category_screen.dart';
import 'package:tamrini/screens/supplement_screens/edit_category_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/helper_functions.dart';

class SupplementsHomeScreen extends StatefulWidget {
  final bool? canAddSupplementToTrainee;

  const SupplementsHomeScreen({this.canAddSupplementToTrainee, Key? key})
      : super(key: key);

  @override
  State<SupplementsHomeScreen> createState() => _SupplementsHomeScreenState();
}

class _SupplementsHomeScreenState extends State<SupplementsHomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    Provider.of<SupplementProvider>(navigationKey.currentContext!,
            listen: false)
        .isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('nutritional_supplements')),
      // appBar: globalAppBar("المكملات الغذائية"),
      body: SingleChildScrollView(
        child: Consumer<SupplementProvider>(builder: (context, _, child) {
          return _.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Provider.of<UserProvider>(context, listen: false).isAdmin
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: kSecondaryColor!,
                                  onPressed: () {
                                    To(const AddSupplementCategoryScreen());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        tr('add_new_section'),
                                        // "إضافة قسم جديد",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      _.supplements.isEmpty || _.supplements == null
                          ? Center(
                              child: Text(tr('no_supplements')),
                              // child: Text("لا يوجد مكملات غذائية"),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // dragStartBehavior: DragStartBehavior.start,
                                itemCount: _.supplements.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Provider.of<SupplementProvider>(context,
                                              listen: false)
                                          .SelectSupplement(
                                              _.supplements[index],
                                              widget.canAddSupplementToTrainee);
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      constraints: BoxConstraints(
                                        minHeight: 100.h,
                                        minWidth: 100.w,
                                        // maxWidth: 150.w,
                                        // maxHeight: 150.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          colorFilter: const ColorFilter.mode(
                                              Colors.black45, BlendMode.darken),
                                          image: _.supplements[index].image!
                                                  .isNotEmpty
                                              ? HelperFunctions
                                                  .ourFirebaseImageProvider(
                                                  url: _.supplements[index]
                                                      .image!,
                                                )
                                              : const AssetImage(
                                                  "assets/images/banner 1.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .isAdmin
                                                ? IconButton(
                                                    onPressed: () {
                                                      Widget cancelButton =
                                                          TextButton(
                                                        child:
                                                            Text(tr('cancel')),
                                                        onPressed: () {
                                                          pop();
                                                        },
                                                      );
                                                      Widget continueButton =
                                                          TextButton(
                                                        child: Text(
                                                          tr('confirm_deletion'),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        onPressed: () {
                                                          pop();

                                                          _.deleteCategory(
                                                            category:
                                                                _.supplements[
                                                                    index],
                                                          );
                                                        },
                                                      );

                                                      showDialog(
                                                          context: navigationKey
                                                              .currentState!
                                                              .context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                  tr('confirm_deletion'),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                                content: Text(
                                                                  '${tr('delete_section')} ${_.supplements[index].title} ؟',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                                actions: [
                                                                  continueButton,
                                                                  cancelButton,
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
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    _.supplements[index].title!,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .isAdmin
                                                    ? IconButton(
                                                        onPressed: () {
                                                          To(EditSUPPCategoryScreen(
                                                            category:
                                                                _.supplements[
                                                                    index],
                                                          ));
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.yellow,
                                                          size: 30,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        mainAxisSpacing: 30,
                                        crossAxisSpacing: 20),
                              ),
                            )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
