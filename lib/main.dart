import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/data/location.dart';
import 'package:tamrini/firebase_options.dart';
import 'package:tamrini/model/home_exercise.dart' as home_exercises;
import 'package:tamrini/model/product.dart';
import 'package:tamrini/provider/ThemeProvider.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/artical_provider.dart';
import 'package:tamrini/provider/diet_food_provider.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/home_exercise_provider.dart';
import 'package:tamrini/provider/home_provider.dart';
import 'package:tamrini/provider/nutritious_value_provider.dart';
import 'package:tamrini/provider/product_provider.dart';
import 'package:tamrini/provider/proten_calculator_provider.dart';
import 'package:tamrini/provider/publisherProvider.dart';
import 'package:tamrini/provider/questions_proviser.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/Articles_screens/Article_details_screen.dart';
import 'package:tamrini/screens/Articles_screens/Articles_screen.dart';
import 'package:tamrini/screens/Articles_screens/pending_publishers_screen.dart';
import 'package:tamrini/screens/Home_screen.dart';
import 'package:tamrini/screens/ProteinCalc_Screen.dart';
import 'package:tamrini/screens/chats/chat_screen.dart';
import 'package:tamrini/screens/diet_food_screens/diet_food_details_screen.dart';
import 'package:tamrini/screens/diet_food_screens/diet_food_screen.dart';
import 'package:tamrini/screens/exercises_screens/exercise_Article_details_screen.dart';
import 'package:tamrini/screens/exercises_screens/exercises_home_screen.dart';
import 'package:tamrini/screens/exercises_screens/suggested_exercises_screen.dart';
import 'package:tamrini/screens/gym_screens/gym_details_screen.dart';
import 'package:tamrini/screens/gym_screens/gyms_screen.dart';
import 'package:tamrini/screens/home_exercises_screens/home_exercise_Article_details_Screen.dart';
import 'package:tamrini/screens/home_exercises_screens/home_exercises_home_screen.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/screens/products_screens/product_details_screen.dart';
import 'package:tamrini/screens/products_screens/store_home_screen.dart';
import 'package:tamrini/screens/question_screens/question_details_screen.dart';
import 'package:tamrini/screens/question_screens/questions_screen.dart';
import 'package:tamrini/screens/supplement_screens/supplements_Article_details_screen.dart';
import 'package:tamrini/screens/supplement_screens/supplements_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_subscribers_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_trainers_screen.dart';
import 'package:tamrini/styles/themes.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/helper_functions.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import 'model/exercise.dart';
import 'model/supplement.dart';
import 'screens/nutrients_classifications_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppleNotificationSetting.enabled;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var token = await messaging.getToken();

  log('current token is $token');
  if (message.data['token'] != token) {
    log("my token : $token");
    log("Received token : ${message.data['token']}");
    log('token is ${message.data['token']}');
    log('token is not the same');

    return;
  }
  log('token is the same');
  log('delivered token is ${message.data['token']}');
}

void _handleMessage(RemoteMessage message) {
  Future.delayed(const Duration(seconds: 0), () async {
    debugPrint('message is ${message.data}');
    // if (message.data['type'] == 'questions') {
    //   To(const QuestionsScreen());
    // }
    if (message.data['type'] == 'Products') {
      var title = message.data['title'];
      if (title == null) {
        To(const ProductsHomeScreen());
        return;
      }
      while (Provider.of<ProductProvider>(navigationKey.currentContext!,
              listen: false)
          .allProducts
          .data!
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var product = Provider.of<ProductProvider>(navigationKey.currentContext!,
              listen: false)
          .allProducts
          .data!
          .where((element) => element.title!.contains(title))
          .toList();

      if (product.isEmpty) {
        To(const ProductsHomeScreen());
        return;
      }

      To(ProductDetailsScreen(
          product: product.first, category: Product(id: ""), isAll: true));
    }
    if (message.data['type'] == 'Articles') {
      var title = message.data['title'];
      if (title == null) {
        To(const ArticlesScreen());
        return;
      }
      while (Provider.of<ArticleProvider>(navigationKey.currentContext!,
              listen: false)
          .articles
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var article = Provider.of<ArticleProvider>(navigationKey.currentContext!,
              listen: false)
          .articles
          .where((element) => element.title!.contains(title))
          .toList();

      if (article.isEmpty) {
        To(const ArticlesScreen());
        return;
      }
      To(ArticleDetailsScreen(
          article: article.first, type: "existing", isAll: true));
    }
    if (message.data['type'] == 'Supplements') {
      var title = message.data['title'];
      if (title == null) {
        To(const SupplementsHomeScreen());
        return;
      }
      while (Provider.of<SupplementProvider>(navigationKey.currentContext!,
              listen: false)
          .allSupplements
          .data!
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var supplement = Provider.of<SupplementProvider>(
              navigationKey.currentContext!,
              listen: false)
          .allSupplements
          .data!
          .where((element) => element.title!.contains(title))
          .toList();

      if (supplement.isEmpty) {
        To(const SupplementsHomeScreen());
        return;
      }
      To(SupplementArticlesDetailsScreen(
          supplement: supplement.first, category: Supplement(id: "")));
    }
    if (message.data['type'] == 'Gyms') {
      var title = message.data['title'];

      if (title == null) {
        To(const GymsScreen());
        return;
      }
      while (
          Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
              .gyms
              .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var gym =
          Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
              .gyms
              .where((element) => element.name.contains(title))
              .toList();

      if (gym.isEmpty) {
        To(const GymsScreen());
        return;
      }
      To(GymDetailsScreen(gym: gym.first, isAll: true));
    }
    if (message.data['type'] == 'Trainers') {
      var title = message.data['title'];
      if (title == null) {
        Provider.of<TrainerProvider>(navigationKey.currentContext!,
                listen: false)
            .fetchAndSetPendingTrainers();
        To(const PendingTrainersScreen());
        return;
      }

      // while (Provider.of<TrainerProvider>(navigationKey.currentContext!,
      //         listen: false)
      //     .trainers
      //     .isEmpty) {
      //   await Future.delayed(const Duration(seconds: 2));
      // }
      // debugPrint('trainers is null');

      // debugPrint("message title $title");
      // debugPrint(
      //     "trainers : ${Provider.of<TrainerProvider>(navigationKey.currentContext!, listen: false).trainers}");

      // var trainer = Provider.of<TrainerProvider>(navigationKey.currentContext!,
      //         listen: false)
      //     .trainers
      //     .where((element) => element.name.contains(title))
      //     .toList();
      // if (trainer.isEmpty) {
      //   debugPrint('trainer is empty');
      //   To(const TrainerHomeScreen());
      //   return;
      // }
      // To(TrainerProfileScreen(trainer: trainer.first));
    }
    if (message.data['type'] == 'Publishers') {
      Provider.of<PublisherProvider>(navigationKey.currentContext!,
              listen: false)
          .fetchAndSetPendingPublishers();
      To(const PendingPublishersScreen());
      return;
    }
    if (message.data['type'] == 'HomeExercises') {
      var title = message.data['title'];
      if (title == null) {
        To(const HomeExercisesHomeScreen());
        return;
      }
      while (Provider.of<HomeExerciseProvider>(navigationKey.currentContext!,
              listen: false)
          .allExercises
          .data!
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var homeExercise = Provider.of<HomeExerciseProvider>(
              navigationKey.currentContext!,
              listen: false)
          .allExercises
          .data!
          .where((element) => element.title!.contains(title))
          .toList();

      if (homeExercise.isEmpty) {
        To(const HomeExercisesHomeScreen());
        return;
      }
      To(HomeExerciseArticlesDetailsScreen(
        exercise: homeExercise.first,
        isAll: true,
        category: home_exercises.HomeExercise(id: "0"),
      ));
    }
    if (message.data['type'] == 'Exercises') {
      var title = message.data['title'];
      if (title == null) {
        To(const ExercisesHomeScreen());
        return;
      }
      while (Provider.of<ExerciseProvider>(navigationKey.currentContext!,
              listen: false)
          .allExercises
          .data!
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var exercise = Provider.of<ExerciseProvider>(
              navigationKey.currentContext!,
              listen: false)
          .allExercises
          .data!
          .where((element) => element.title!.contains(title))
          .toList();
      if (exercise.isEmpty) {
        To(const ExercisesHomeScreen());
        return;
      }
      To(ExerciseArticlesDetailsScreen(
        exercise: exercise.first,
        isAll: true,
        category: Exercise(id: "0"),
      ));
    }
    if (message.data['type'] == 'DietFoods') {
      var title = message.data['title'];
      if (title == null) {
        To(const DietFoodScreen());
        return;
      }
      while (Provider.of<DietFoodProvider>(navigationKey.currentContext!,
              listen: false)
          .foodList
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var dietFood = Provider.of<DietFoodProvider>(
              navigationKey.currentContext!,
              listen: false)
          .foodList
          .where((element) => element.title.contains(title))
          .toList();

      if (dietFood.isEmpty) {
        To(const DietFoodScreen());
        return;
      }
      To(DietFoodDetailsScreen(
        dietfood: dietFood.first,
        type: "existing",
      ));
    }
    if (message.data['type'] == 'NutritiousValues') {
      while (Provider.of<NutritionalValueProvider>(
              navigationKey.currentContext!,
              listen: false)
          .nutritiousList
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      To(const NutrientsClassifications());
    }
    if (message.data['type'] == 'ProtenCalculators') {
      To(const ProteinCalculatorScreen());
    }
    if (message.data['type'] == 'questions') {
      var title = message.data['title'];
      if (title == null) {
        To(const QuestionsScreen());
        return;
      }
      while (Provider.of<QuestionsProvider>(navigationKey.currentContext!,
              listen: false)
          .filteredQuestions
          .isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }
      Provider.of<QuestionsProvider>(navigationKey.currentContext!,
                      listen: false)
                  .filteredQuestions
                  .indexWhere((element) => element.title.contains(title)) !=
              -1
          ? To(QuestionDetailsScreen(
              indexs: Provider.of<QuestionsProvider>(
                      navigationKey.currentContext!,
                      listen: false)
                  .filteredQuestions
                  .indexWhere((element) => element.title.contains(title)),
            ))
          : To(const QuestionsScreen());
    }
    if (message.data['type'] == 'chat') {
      String chatId = message.data['chatId'];
      if (message.data['chatId'] != null) {
        To(ChatScreen(chatID: chatId));
      }
    }
    if (message.data['type'] == 'gym_subscription') {
      log("NOTIFICATION type : gym_subscription");
      Provider.of<GymProvider>(navigationKey.currentContext!, listen: false)
          .fetchAndSetPendingSubscribers();
      To(const PendingSubscribersScreen());
    }
    if (message.data['type'] == 'newExercises') {
      var title = message.notification?.title;
      log("Data : ${message.data['type']}");
      log("title : $title}");
      if (title != null) {
        To(const SuggestedExercisesScreen(homeExercises: false));
        return;
      }
    }
    if (message.data['type'] == 'newHomeExercises') {
      var title = message.notification?.title;
      log("Data : ${message.data['type']}");
      log("title : $title}");
      if (title != null) {
        To(const SuggestedExercisesScreen(homeExercises: true));
        return;
      }
    }
  });
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen

  if (initialMessage != null) {
    debugPrint("print app from initialMessage ${initialMessage.data}");
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint("print app from message ${message.data}");
    _handleMessage(message);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // HomeScreenBody.loading = true;

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.appAttest,
  // );

  FirebaseMessaging messaging = FirebaseMessaging.instance..requestPermission();

  AwesomeNotifications notifications = AwesomeNotifications();
  await notifications.initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'daily_notification',
        channelName: 'Daily Notification',
        channelDescription: 'Daily reminder to drink water',
        defaultColor: kPrimaryColor,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'exercises_rest',
        channelName: 'Exercises Rest',
        channelDescription: 'Reminder to rest',
        defaultColor: kPrimaryColor,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'users_data',
        channelName: 'Users data',
        channelDescription: 'Downloaded users data as PDF',
        defaultColor: kPrimaryColor,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      ),
    ],
  );
  await notifications.requestPermissionToSendNotifications();

  AppleNotificationSetting.enabled;
  AppleNotificationSetting.values;

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    provisional: true,
    criticalAlert: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint(" is CONTENT AVAILABLE ${message.contentAvailable}");
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');
    log("*******************************************************");
    // check if token is the same
    String? token = await messaging.getToken();
    log('current token is $token');

    log('token is the same');
    log('delivered token is ${message.data['token']}');

    AwesomeDialog(
      context: navigationKey.currentContext!,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: message.notification?.title,
      desc: message.notification?.body,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _handleMessage(message);
      },
    ).show();

    AppleNotificationSetting.enabled;
    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
    } else {
      debugPrint('null');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true);
  // NotificationSettings settings = await messaging.getNotificationSettings();
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  bool isLoggedIn = CacheHelper.getBoolean(key: 'isLogin');

  bool internetDisconnected = false;
  Future.delayed(const Duration(seconds: 7)).then((value) =>
      InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // show snack-bar with internet connection message
            if (internetDisconnected) {
              ScaffoldMessenger.of(navigationKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text(tr('connect_to_the_internet')),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.green,
                ),
              );
              internetDisconnected = false;
            }

            break;
          case InternetConnectionStatus.disconnected:
            // show snack-bar with no internet connection message
            ScaffoldMessenger.of(navigationKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text(tr('no_internet_connection')),
                duration: const Duration(seconds: 7),
                backgroundColor: Colors.red,
              ),
            );
            internetDisconnected = true;
            break;
        }
      }));

  final userProvider = UserProvider()..initiate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationController>(
          create: (_) => LocationController(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()
            ..init()
            ..changeAppMode(fromShared: isDark),
        ),
        ChangeNotifierProvider<ArticleProvider>(
          create: (_) => ArticleProvider()..fetchAndSetArticles(),
        ),
        ChangeNotifierProvider<DietFoodProvider>(
          create: (_) => DietFoodProvider()..fetchAndSetMeals(),
        ),
        ChangeNotifierProvider<UploadProvider>(
          create: (_) => UploadProvider(),
        ),
        ChangeNotifierProvider<UserProvider>.value(
          value: userProvider,
        ),
        ChangeNotifierProvider<SupplementProvider>(
          create: (_) => SupplementProvider()..fetchAndSetSupplements(),
        ),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
          create: (_) => ProductProvider()..fetchAndSetProducts(),
          update: (_, userProvider, productProvider) =>
              productProvider!..initiate(userProvider),
        ),
        ChangeNotifierProvider<GymProvider>(
            create: (_) => GymProvider()..fetchAndSetGyms()),
        ChangeNotifierProvider<HomeExerciseProvider>(
          create: (_) => HomeExerciseProvider()..fetchAndSetExercise(),
        ),
        ChangeNotifierProvider<QuestionsProvider>(
          create: (_) => QuestionsProvider()..fetchQuestions(),
        ),
        ChangeNotifierProvider<ProteinCalculatorProvider>(
          create: (_) => ProteinCalculatorProvider(),
        ),
        ChangeNotifierProvider<NutritionalValueProvider>(
          create: (_) => NutritionalValueProvider()..initiate(),
        ),
        ChangeNotifierProvider<ExerciseProvider>(
          create: (_) => ExerciseProvider()..fetchAndSetExercise(),
        ),
        ChangeNotifierProxyProvider<UserProvider, TrainerProvider>(
          create: (_) => TrainerProvider()..fetchAndSetTrainers(),
          update: (_, userProvider, trainerProvider) =>
              trainerProvider!..initiate(userProvider),
        ),
        ChangeNotifierProxyProvider<UserProvider, PublisherProvider>(
          create: (_) => PublisherProvider()..fetchAndSetPublishers(),
          update: (_, userProvider, publisherProvider) =>
              publisherProvider!..initiate(userProvider),
        ),
        ChangeNotifierProxyProvider3<ExerciseProvider, UserProvider,
            SupplementProvider, TraineeProvider>(
          create: (_) => TraineeProvider(),
          update: (_, exerciseProvider, userProvider, supplementProvider,
                  traineeProvider) =>
              traineeProvider!
                ..initiate(
                  userProvider,
                  exerciseProvider,
                  supplementProvider,
                ),
        ),
        ChangeNotifierProxyProvider5<UserProvider, ExerciseProvider,
            ArticleProvider, GymProvider, ProductProvider, HomeProvider>(
          create: (_) => HomeProvider(),
          update: (_, userProvider, exerciseProvider, articleProvider,
                  gymProvider, productProvider, homeProvider) =>
              homeProvider!
                ..init(
                    userProvider: userProvider,
                    exerciseProvider: exerciseProvider,
                    articleProvider: articleProvider,
                    gymProvider: gymProvider,
                    productProvider: productProvider),
        ),
      ],
      child: MyApp(isLogged: isLoggedIn),

      // child: MyApp(isDark: isDark, isLogged: isLoggedIn),
    ),
  );

  await AndroidAlarmManager.initialize();
  if (userProvider.drinkAlarm != null) {
    await HelperFunctions.rescheduleDailyNotification(userProvider);
  }
}

class MyApp extends StatefulWidget {
  // final bool isDark;
  final bool isLogged;

  const MyApp({
    super.key,
    // required this.isDark,
    required this.isLogged,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LocationController(), fenix: true);
    return EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      startLocale: CacheHelper.getBoolean(key: 'isArabic')
          ? const Locale('ar')
          : Locale(View.of(context).platformDispatcher.locale.languageCode),
      path: 'assets/languages',
      child: ScreenUtilInit(
        builder: (_, __) {
          return Consumer<ThemeProvider>(
            // create: (_) => ThemeProvider()
            //   ..init()
            //   ..changeAppMode(fromShared: widget.isDark),
            builder: (context, obj, child) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .addTabCalculator();
                },
                child: GetMaterialApp(
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var locale in supportedLocales) {
                      if (locale.languageCode == deviceLocale!.languageCode &&
                          locale.countryCode == deviceLocale.countryCode) {
                        return deviceLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  debugShowCheckedModeBanner: false,
                  title: tr('tamrini'),
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: Provider.of<ThemeProvider>(context).isDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  // home: SplashScreen(isLoggedIn: widget.isLogged),
                  home: widget.isLogged
                      ? const HomeScreen()
                      : const LoginScreen(),
                  navigatorKey: navigationKey,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   final bool isLoggedIn;
//
//   const SplashScreen({super.key, required this.isLoggedIn});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3)).then(
//       (value) {
//         ToAndFinish(
//             widget.isLoggedIn ? const HomeScreen() : const LoginScreen());
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: kSecondaryColor,
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/icon/icon.png'),
//             SizedBox(height: 8.h),
//             Text(
//               context.locale.languageCode == 'ar'
//                   ? "طريقك للحصول على لياقة بدنية عالية"
//                   : "Your way to get high fitness",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
