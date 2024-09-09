import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/components/custom_container.dart';
import 'package:car_shop/components/custom_edit.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  late var isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc,AppState>(
      listener: (context,state){
        if(state is LoginState){
          UserCredential? userCredentials = state.userCredential;
          if(userCredentials?.user != null){
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Login Success');
            Get.offNamed(AppRouting.homePage);
          } else {
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Failed to login');
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login to your account',style: Utils.getMedium().copyWith(fontSize: 30),),
                const SizedBox(height: 20,),
                Text('Email',style: Utils.getMedium().copyWith(fontSize: 20),),
                CustomEdit(hint: "Email", textEditingController: _emailController, iconData: Icons.email, isPass: false),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Text('Password',style: Utils.getMedium().copyWith(fontSize: 20),),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRouting.resetPage);
                      },
                      child: Text('Forgot?',style: Utils.getMedium().copyWith(fontSize: 20,color: Colors.blue),),
                    )
                  ],
                ),
                CustomEdit(hint: "Password", textEditingController: _passWordController, iconData: Icons.password , isPass: true),
                const SizedBox(height: 20,),
                CustomContainer(text: "Login", onTap: (){
                  var email = _emailController.text;
                  var pass = _passWordController.text;

                  if(email.isEmpty){
                    Fluttertoast.showToast(msg: 'Email must not be empty');
                    return;
                  }

                  if(pass.isEmpty){
                    Fluttertoast.showToast(msg: 'Password must not be empty');
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });
                  BlocProvider.of<AppBloc>(context).add(LoginEvent(email, pass));

                }, isLoading: isLoading,),
                const SizedBox(height: 40,),
                Center(child: GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRouting.registerPage);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Don't have an account?",
                        style: Utils.getMedium().copyWith(fontSize: 17),),
                      const SizedBox(width: 10,),
                      Text("Sign Up",
                        style: Utils.getMedium().copyWith(fontSize: 19,color: Colors.blue),)
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
