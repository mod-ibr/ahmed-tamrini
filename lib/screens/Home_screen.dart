import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/home_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/articles_category_screen.dart';
import 'package:tamrini/screens/exercise_category_screen.dart';
import 'package:tamrini/screens/food_category_screen.dart';
import 'package:tamrini/screens/home_screen_body.dart';
import 'package:tamrini/screens/products_screens/store_home_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/Drawer.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// PageController _pageController = PageController(initialPage: 2);
// final scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 2;

  // final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const FoodCategoryScreen(),
      const ExerciseCategoryScreen(),
      const HomeScreenBody(),
      const ProductsHomeScreen(),
      const ArticlesCategoryScreen(),
    ];
    return Consumer<HomeProvider>(builder: (_, homeProv, __) {
      if (homeProv.isLoading) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kSecondaryColor,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: ResizeImage(
                    Image.asset('assets/icon/icon.png').image,
                    height: 225.h.toInt(),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.locale.languageCode == 'ar'
                      ? "دليل كمال الأجسام في الوطن العربي"
                      : "Bodybuilding guide in the Arab World",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }
      return Consumer<UserProvider>(
        builder: (_, obj, ___) => Scaffold(
          // key: scaffoldKey,
          drawerEnableOpenDragGesture: false,
          extendBody: true,
          // extendBodyBehindAppBar: selectedIndex==2?true:true,
          drawer: const MyDrawer(),
          appBar: selectedIndex == 0
              ? globalAppBar(tr('health_and_nutrition'), isLeading: true)
              // ? globalAppBar('الصحة والتغذية', isLeading: true)
              : selectedIndex == 1
                  ? globalAppBar(tr('exercises_and_fitness'), isLeading: true)
                  // ? globalAppBar('التمارين واللياقة', isLeading: true)
                  : selectedIndex == 2
                      ? globalAppBar(tr('home'),
                          // ? globalAppBar('الرئيسية',
                          isLeading: true,
                          isMain: obj.isLogin ? true : false,
                          notification:
                              obj.isLogin ? obj.user.notification : false)
                      : selectedIndex == 3
                          ? globalAppBar(tr('store'), isLeading: true)
                          // ? globalAppBar('المتجر', isLeading: true)
                          : selectedIndex == 4
                              ? globalAppBar(tr('educate_yourself'),
                                  isLeading: true)
                              // ? globalAppBar('ثقف نفسك', isLeading: true)
                              : globalAppBar('', isLeading: true),

          bottomNavigationBar: CurvedNavigationBar(
            // key: _bottomNavigationKey,
            index: selectedIndex,
            color: kSecondaryColor!,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: kSecondaryColor!,
            height: 60,
            items: const <Widget>[
              Icon(
                Icons.restaurant,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.fitness_center,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.article,
                size: 30,
                color: Colors.white,
              ),
            ],
            onTap: (index) {
              selectedIndex = index;

              setState(() {});

              // final CurvedNavigationBarState? navBarState =
              //     _bottomNavigationKey.currentState;
              // navBarState?.setPage(1);
              // setState(() {});
            },
          ),
          body: screens[selectedIndex],
        ),
      );
    });
  }
}

// class HomeButton extends StatelessWidget {
//   final String title;
//   final Function onTap;
//   final String image;
//   final double? height;
//   final double? width;
//   final bool imgPadding;
//   final bool isNetImage;
//
//   const HomeButton({
//     required this.title,
//     required this.image,
//     required this.onTap,
//     this.height,
//     this.width,
//     this.imgPadding = false,
//     this.isNetImage = false,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           onTap();
//         },
//         child: Container(
//           width: 100.w,
//           height: height ?? 125.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             // gradient: LinearGradient(
//             //
//             //   begin: Alignment.topRight,
//             //   end: Alignment.bottomLeft,
//             //   colors: [
//             //     kSecondaryColor!!.shade200,
//             //     kSecondaryColor!!.shade400,
//             //     kSecondaryColor!!.shade700,
//             //   ],
//             // ),
//             color: Colors.transparent,
//             // boxShadow: [
//             //   BoxShadow(
//             //     color: Colors.grey.withOpacity(0.5),
//             //     spreadRadius: 1,
//             //     offset: const Offset(0, 3),
//             //   ),
//             // ],
//           ),
//           child: Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding:
//                     EdgeInsets.symmetric(vertical: imgPadding ? 10.0.h : 0),
//                 child: isNetImage
//                     ? Column(
//                         children: [
//                           CachedNetworkImage(
//                             imageUrl: image,
//                           ),
//                         ],
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(
//                           image,
//                           width: width ?? 50.w,
//                         ),
//                       ),
//               ),
//               Center(
//                 child: Text(title,
//                     softWrap: false,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontFamily: 'Cairo',
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold)),
//               ),
//             ],
//           )),
//         ));
//   }
// }
