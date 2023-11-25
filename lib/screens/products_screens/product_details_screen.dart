import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/product.dart';
import 'package:tamrini/provider/product_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/screens/products_screens/edit_product_screen.dart';
import 'package:tamrini/screens/products_screens/paymentScreen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/helper_functions.dart';
import '../setting_screens/settings_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Data product;
  final Product category;
  final bool isAll;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.category,
    required this.isAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,000');
    log("productDetailsScreen");
    log(category.id.toString());

    return Scaffold(
      appBar: globalAppBar(
        context.locale.languageCode == 'ar'
            ? 'تفاصيل المنتج'
            : 'Product details',
      ),
      bottomNavigationBar: SizedBox(
        height: 50.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            !Provider.of<UserProvider>(context, listen: false).isLogin
                ? AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.bottomSlide,
                    title: tr('alert'),
                    desc: tr('must_log_in'),
                    btnCancelOnPress: () {
                      // pop();
                    },
                    btnOkOnPress: () {
                      To(const LoginScreen());
                    },
                  ).show()
                : Provider.of<UserProvider>(context, listen: false)
                            .user
                            .isVerifiedPhoneNumber ||
                        Provider.of<UserProvider>(context, listen: false)
                            .user
                            .isVerifiedEmail
                    ? {
                        Provider.of<ProductProvider>(context, listen: false)
                            .fetchAndSetPaymentMethods(),
                        To(PaymentScreen(
                          product: product,
                        ))
                      }
                    : AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        title: tr('error'),
                        desc: tr('confirm_email_n_phone'),
                        btnOkOnPress: () {
                          To(const SettingsScreen());
                        },
                      ).show();
          },
          child: Text(
            tr('buy_now'),
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            // constraints:  BoxConstraints(
            //   minHeight: MediaQuery.of(context).size.height,
            // ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      product.title ?? '',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  product.assets == null
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: ImageSlideshow(
                            // options: CarouselOptions(
                            //   height: 200.h,
                            //   viewportFraction: 1,
                            //   initialPage: 0,
                            //   enableInfiniteScroll: true,
                            //   reverse: false,
                            //   autoPlay: true,
                            //   autoPlayInterval: const Duration(seconds: 5),
                            //   autoPlayAnimationDuration:
                            //       const Duration(milliseconds: 800),
                            //   autoPlayCurve: Curves.fastOutSlowIn,
                            //   enlargeCenterPage: true,
                            //   scrollDirection: Axis.horizontal,
                            // ),
                            children: [
                              for (var i = 0; i < product.assets!.length; i++)
                                InkWell(
                                    onTap: () {
                                      showDialog<dynamic>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return OrientationBuilder(
                                              builder: (context, orientation) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return Scaffold(
                                                    appBar: AppBar(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFEFF2F7),
                                                      elevation: 0,
                                                      iconTheme:
                                                          const IconThemeData(
                                                              color: Color(
                                                                  0xFF003E4F)),
                                                      centerTitle: false,
                                                      title: Text(
                                                        product.title ?? '',
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          color: const Color(
                                                              0xff007c9d),
                                                        ),
                                                      ),
                                                    ),
                                                    body: Container(
                                                      // height: 1.sh,
                                                      alignment:
                                                          Alignment.center,
                                                      child: ImageSlideshow(
                                                        height: 1.sh,
                                                        children: [
                                                          for (var i = 0;
                                                              i <
                                                                  product
                                                                      .assets!
                                                                      .length;
                                                              i++)
                                                            PhotoView(
                                                              imageProvider:
                                                                  HelperFunctions
                                                                      .ourFirebaseImageProvider(
                                                                url: product
                                                                    .assets![i],
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          });
                                    },
                                    child: Image(
                                      image: HelperFunctions
                                          .ourFirebaseImageProvider(
                                              url: product.assets![i]),
                                      fit: BoxFit.contain,
                                    ))
                            ],
                          ),
                        ),
                  Row(
                    children: [
                      Text(formatter.format(product.price),
                          style: TextStyle(
                            fontSize: 28.sp,
                            // fontWeight: FontWeight.bold,
                          )),
                      Text(
                        context.locale.languageCode == 'ar' ? " د.ع" : ' IQD',
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        (product.description)!,
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  Provider.of<UserProvider>(context, listen: false).isAdmin &&
                          !isAll
                      ? MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: kSecondaryColor!,
                          onPressed: () {
                            To(EditProductScreen(
                              product: product,
                              category: category,
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                tr('edit'),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontFamily: 'Cairo'),
                              ),
                            ],
                          ))
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
