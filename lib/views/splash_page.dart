import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:car_shop/views/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    super.initState();

    BlocProvider.of<AppBloc>(context).add(AuthEvent());


  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc,AppState>(
      listener: (context,state){
        if(state is AuthState){
          User? user = state.user;

          Future.delayed(const Duration(seconds: 5),(){

            if(user != null){
              Get.offNamed(AppRouting.homePage);
            } else {
              if(StorageHelper.isDone()){
                Get.offNamed(AppRouting.loginPage);
              } else {
                Get.offNamed(AppRouting.introPage);
              }
            }
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Image.asset("assets/images/logo.png",width: 250,height: 250,
                fit: BoxFit.cover,filterQuality: FilterQuality.high),
          ),
        ),
      ),
    );
  }
}
