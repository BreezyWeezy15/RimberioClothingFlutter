import 'package:car_shop/auth/api_service.dart';
import 'package:car_shop/auth/product_service.dart';
import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/others/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:car_shop/views/splash_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


NotificationHelper notificationHelper = NotificationHelper.instance;
ProductService productService = ProductService.instance;
StoreHelper storeHelper = StoreHelper.instance;
AuthService authService = AuthService.instance;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(EasyLocalization(
      supportedLocales: const [Locale("en"),Locale("fr"),Locale("es")],
      path: "assets/json",
      fallbackLocale: const Locale("en"),
      child: const MyApp()));
}


Future<void> _initializeApp() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDimH8BIv-JCmNnmUUtC9KU57r0VRhXHz4",
      appId: "1:393168671411:android:4a40bd6755aea41b3f56c6",
      messagingSenderId: "393168671411",
      projectId: "rimberio-296b9",
    ),
  );
  await EasyLocalization.ensureInitialized();
  await dotenv.load();
  await GetStorage.init();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE'] ?? '';
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationHelper.initNotifications();

}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notificationHelper.showNotification(title: message.notification!.title!,
      body: message.notification!.body!);
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocListener<AppBloc, AppState>(
        listenWhen: (context,state){
          return state is GetThemeState;
        },
        listener : (context,state){
          themeMode = (state as GetThemeState).themeMode;
        },
        child: GetMaterialApp(
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          fallbackLocale: const Locale("en"),
          home: const SplashPage(),
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          themeMode: themeMode, // Set the theme mode based on state
          debugShowCheckedModeBanner: false,
          getPages: AppRouting.pages,
        ),
      ),
    );
  }
}




