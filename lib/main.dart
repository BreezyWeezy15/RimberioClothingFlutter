import 'package:car_shop/auth/api_service.dart';
import 'package:car_shop/auth/product_service.dart';
import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/views/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDimH8BIv-JCmNnmUUtC9KU57r0VRhXHz4",
        appId: "1:393168671411:android:4a40bd6755aea41b3f56c6",
        messagingSenderId: "393168671411",
        projectId: "rimberio-296b9")
  );
  await dotenv.load();
  await GetStorage.init();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc(AuthService())),
        BlocProvider(create: (_) => ProductBloc(ProductService(),StoreHelper()))
      ],
      child: GetMaterialApp(
        home: const MyApp(),
        debugShowCheckedModeBanner: false,
        getPages: AppRouting.pages,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

