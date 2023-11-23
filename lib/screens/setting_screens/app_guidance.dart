import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tamrini/utils/constants.dart';

import '../../utils/widgets/global Widgets.dart';

class AppGuidance extends StatefulWidget {
  const AppGuidance({super.key});

  @override
  State<AppGuidance> createState() => _AppGuidanceState();
}

class _AppGuidanceState extends State<AppGuidance> {
  Widget logo() => Column(
        children: [
          Image.asset(
            "assets/icon/icon.png",
            width: 100.w,
            height: 100.h,
          ),
          Text(
            context.locale.languageCode == 'ar'
                ? "جميع الحقوق محفوظة"
                : "All rights preserved",
            style: TextStyle(fontSize: 16.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tamrini",
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                " © ",
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                DateTime.now().year.toString(),
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ],
      );

  Widget logoTranslated() => Column(
        children: [
          Image.asset(
            "assets/icon/icon.png",
            width: 100.w,
            height: 100.h,
          ),
          Text(
            "All Rights Reserved",
            style: TextStyle(fontSize: 16.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tamrini",
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                " © ",
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                DateTime.now().year.toString(),
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ],
      );

  Widget arabicGuidance() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.all(10.sp),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'مرحبا بك في تطبيق تمريني',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '1- الشاشة الرئيسية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- البانر الإعلاني يقدم لك إعلانات من قبل شركات رياضية يتم استبدال الإعلان بشكل تلقائي كل 5 ثوان وفي حال اعجبك الإعلان اضغط على الصور وسوف يتم تحويلك لموقع الإعلان.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- تمارين متنوعة وفي هذا القسم تضهر لك التمارين الموجوده بقسم ابحث عن تمرينك وبشكل عشوائي عند الضغط على التمرين سوف يتم عرض لك التمرين مشروح بالصورة والصوت والكتابة  ولتفصيل جميع التمارين اضغط على كلمة المزيد.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- آخر المقالات  هو مختصر لقسم المقالات ولعرض جميع المقالات اضغط على كلمة المزيد.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- منتجات متنوعة يتم عرض فيها المنتجات الرياضية الموجودة في قسم المتجر ولعرض جميع المنتجات اضغط على كلمة المزيد.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- اقرب جم من هنا يظهر لك اقرب جم على منزلك ولتفصيل النوادي الرياضية اضغط على كلمة المزيد.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- في أعلى الصفحة الرئيسية يوجد زر الجرس وفي هذا الزر يوجد قائمة الإشعارات.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '2- القائمة الجانبية وهي موجودة في الجزء العلوي للشاشة الرئيسية على جهة اليمين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- الكورسات هذا القسم المخصص لكورساتك التدريبية تستطيع عرضها وأداء تمارينك من خلاله.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- منبه شرب الماء  ومن خلاله تقدر تضيف الكمية أو أوقات شرب الماء ويقوم التطبيق بتذكيرك.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- المكملات الغذائية وهذا القسم تستطيع عرض المكملات المكتوبة لك من قبل المدرب ومعرفة طريقة استخدامها ومكوناتها.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- النظام الغذائي هنا ستجد نظامك الغذائي المكتوب لك من قبل المدرب.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- المتابعة هنا ستجد صورك ووزنك وطولك التي تم مشاركتها مع المدرب حتى تعرف مستوى تقدمك والتغييرات التي حصلت معك.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- الإعدادات 1 – الوضع المظلم تفعيل الدارك مود وتعطيله 2- الملف الشخصي لتفعيل وتعديل بياناتك أو حذف حسابك 3- تغيير كلمة المرور الخاصة بك 4- تغيير رقم هاتفك.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- عن التطبيق يقدم لك هذا القسم تفاصيل عن التطبيق.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- تواصل معنا ستجد هنا جميع وسائل التواصل معنا في حال لديك استفسار.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- تقييم التطبيق ادخل على هذا القسم وادعمنا بتقييم التطبيق.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              'تسجيل خروج في حال تريد تسجيل الخروج لتبديل حسابك أو عمل حساب جديد.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '3- الصحة والتغذية وهي موجودة في البار أسفل الشاشة أول أيقونة على جهة اليمين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- القيم الغذائية من هنا اختر الأكلة التي تريد معرفة سعراتها الحرارية والقيم الغذائية الخاصة بها وذلك من خلال تفصيل الأكلات أو البحث عنها.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- حاسبة البروتينات هنا تدخل معلوماتك كاملة للحصول على احتياجك للسعرات اليومية حسب هدفك ونشاطك الخ.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- المكملات الغذائية هذا القسم يحتوي على جميع المكملات الغذائية تستطيع من خلاله البحث عن أي مكمل لمعرفة طريقة استخدامه ومكوناته.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '4- التمارين واللياقة وهوه موجود في البار أسفل الصفحة الرئيسية الأيقونة الثانية من جهة اليمين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- ابحث عن تمرينك في هذا القسم تستطيع مشاهدة أكثر من 1200 تمرين ومقسمين قسم لكل عضلة تستطيع اختيار التمرين أو البحث عن اسمه وسوف يظهر لك التمرين مشروح بالصورة والصوت والكتابة.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- التمارين المنزلية نفس فكرة قسم ابحث عن تمرينك ولاكن مخصص للتمارين المنزلية.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- صالات الجيم هنا ستجد النوادي الرياضية الأقرب لمكانك ستتعرف على صورها وأسعار الاشتراك واوقات الدوام وأرقام التواصل مع الجم.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- المدربين اختر مدربك من خلال هذا القسم ستجد مدربين مخصصين لطلبك مع معرض أعمالهم وإنجازاتهم وتستطيع التواصل معهم من خلال التطبيق والاشتراك معهم. وفي حال كنت مدربًا تستطيع من خلال هذا القسم كتابة الكورسات التدريبية للاعبيك واختيار التمارين بكل سهولة فلديك قاعدة بيانات تحتوي على أكثر من 1200 تمرين بصورة وصوت وكتابة بمجرد ضغطة سوف يحصل اللاعب على كورس إلكتروني يحتوي على النظام الغذائي والتمارين المصورة والمكملات الغذائية.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '5- المتجر وهو موجود في البار أسفل الشاشة الرئيسية رابع أيقونة من جهة اليمين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- تحتوي على مكملات غذائية لجميع احتياجاتك وأهدافك مقسمة حسب هدف المكمل تستطيع شراء المكملات من أفضل الوكالات المخصصة لهذا المجال مع حرية الدفع بواسطة الدفع الإلكتروني أو عند الاستلام والتوصيل لأي مكان.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '6- ثقف نفسك أول قسم من جهة اليسار',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- 1 المقالات هنا تنشر مقالات رياضية من قبل مدربين محترفين.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- 2 اكلات دايت هنا ننشر اكلات دايت وطريقه عملها وتستطيع البحث عن أكلة معينة.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- 3- الأسئلة إذا كان لديك أي سؤال قم بنشره بهذا القسم وسيتم الرد عليك من قبل المختصين وذوي المعرفة وتستطيع أيضًا البحث عن سؤال معين في بالك.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              '7- يومي',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 20.sp),
            Text(
              'في هذا القسم المهم سوف تجد احتياجك للسعرات الحرارية والبروتينات والكربوهيدرات والدهون الصحية اليومية وعند إضافة الوجبة التي أكلتها سوف تطرح القيمة الغذائية للوجبة من مجموع احتياجك اليومي. وبهذا تعرف كم تبقى لك من احتياجك وتعرف تنظم وجباتك اليومية بمقدار محسوب بشكل ممتاز.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            logo(),
          ],
        ),
      ),
    );
  }

  Widget englishGuidance() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.all(10.sp),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                "Welcome to Tamrini App",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "1- Home Screen",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              "- The banner displays advertisements from sports companies and changes them automatically every 5 seconds. If you like an ad, click on the image, and it will take you to the ad's website.",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "- Various exercises are displayed in this section. You can find exercises by searching for them, and when you click on an exercise, it will be presented with images, audio, and text explanations. To see all exercises, click on 'More.'",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "- 'Latest Articles' is a summary of the articles section. To view all articles, click on 'More.'",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "- Various products are displayed in this section, including sports products available in the store. To view all products, click on 'More.'",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "- 'Nearest Gym' will show you the nearest gyms to your location. To get more details about sports clubs, click on 'More.'",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "- At the top of the home page, there is a bell icon that contains the notification menu.",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "2- Side Menu (Located at the top left of the Home Screen)",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- "Courses" is dedicated to your training courses. You can view and perform exercises through this section.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Water Reminder" allows you to add the quantity or times for drinking water, and the app will remind you.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Dietary Supplements" displays dietary supplements prescribed by the trainer, along with usage instructions and ingredients.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Diet Plan" contains your personalized diet plan provided by the trainer.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Progress Tracking" displays your photos, weight, and height that you have shared with the trainer to track your progress and changes.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Settings" includes options such as enabling or disabling dark mode, editing your profile data, changing your password, and updating your phone number.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "About the App" provides details about the application.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Contact Us" contains various ways to contact us in case you have any inquiries.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "App Rating" allows you to rate the app.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              "To log out, click here if you want to switch accounts or create a new one.",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "3- Health and Nutrition (Located at the bottom bar, first icon on the left)",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- "Nutritional Values" allows you to select a meal to view its caloric content and nutritional values in detail. You can search for specific meals as well.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Protein Calculator" lets you enter your complete information to calculate your daily calorie needs based on your goal and activity level.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Dietary Supplements" in this section, you can find all dietary supplements. You can search for any supplement to learn how to use it and its ingredients.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "4- Exercises and Fitness (Located at the bottom bar, second icon on the left)",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- Search for your exercise in this section. You can view over 1200 exercises, categorized by muscle group. You can choose an exercise or search for its name, and you will see the exercise explained with images, audio, and text.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Home Workouts" follows the same idea as the exercise section but is dedicated to home workouts.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Gyms" will show you the nearest sports clubs to your location. You will learn about their images, subscription prices, working hours, and contact numbers.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- "Trainers" allows you to choose your trainer. You will find trainers specialized in your request, along with their portfolios and achievements. You can also communicate with them through the app and subscribe to their training courses. If you are a trainer, you can easily write training courses for your players and choose exercises from a database of over 1200 exercises with images, audio, and text. With just a click, the player will receive an electronic course containing dietary plans, illustrated exercises, and dietary supplements.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "5- Store (Located at the bottom bar, fourth icon on the right)",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- The store contains dietary supplements for all your needs and goals, categorized according to the supplement\'s goal. You can purchase supplements from the best agencies specialized in this field, with the freedom to pay electronically or upon delivery, with delivery to any location.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "6- Educate Yourself (Located on the right)",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              '- 1 Articles: Here, we publish sports articles by professional trainers.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- 2 Diet Recipes: We publish diet recipes and their preparation methods here, and you can search for specific recipes.',
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '- 3 Questions: If you have any questions, post them in this section, and they will be answered by experts and knowledgeable individuals. You can also search for specific questions.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              "7- My Day",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 20.sp),
            Text(
              'In this important section, you will find your daily calorie, protein, carbohydrate, and healthy fat requirements. When you add the meal you have eaten, the nutritional value of the meal will be deducted from your daily requirements. This way, you can track how much is left of your requirements and plan your daily meals accurately.',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.sp),
            logoTranslated(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('app_guidance')),
      body: context.locale.languageCode == 'ar'
          ? arabicGuidance()
          : englishGuidance(),
    );
  }
}
