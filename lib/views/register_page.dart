import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/custom_container.dart';
import '../components/custom_edit.dart';
import '../others/utils.dart';
import '../routes/app_routing.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _confirmPassWordController = TextEditingController();
  bool isLoading = false;


  @override
  void dispose() {
    _fullName.dispose();
    _emailController.dispose();
    _phone.dispose();
    _address.dispose();
    _passWordController.dispose();
    _confirmPassWordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc,AppState>(
      listener: (context,state){
        if(state is RegisterState){
          if(state.userCredential?.user != null){

            BlocProvider.of<AppBloc>(context).add(AccountEvent(
                _fullName.text,
                _phone.text,
                _emailController.text,
                _address.text));

          }
          else {
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Failed to create an account');
          }
        }
        else if (state is AccountState){
          var isCreated = state.isCreated;
          if(isCreated){
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Account Created');
            Get.offNamed(AppRouting.homePage);
          } else {
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Failed to create an account');
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create a new account',style: Utils.getMedium().copyWith(fontSize: 30),),
                  const SizedBox(height: 20,),
                  Text('Email',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Email", textEditingController: _emailController, iconData: Icons.email, isPass: false),
                  const SizedBox(height: 20,),
                  Text('Full Name',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Full Name", textEditingController: _fullName, iconData: Icons.person, isPass: false),
                  const SizedBox(height: 20,),
                  Text('Phone',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Phone", textEditingController: _phone, iconData: Icons.phone, isPass: false),
                  const SizedBox(height: 20,),
                  Text('Address',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Address", textEditingController: _address, iconData: Icons.location_on_outlined, isPass: false),
                  const SizedBox(height: 20,),
                  Text('Password',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Password", textEditingController: _passWordController, iconData: Icons.password , isPass: true,),
                  const SizedBox(height: 20,),
                  Text('Confirm Password',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Confirm Password", textEditingController: _confirmPassWordController, iconData: Icons.password , isPass: true,),
                  const SizedBox(height: 20,),
                  CustomContainer(text: "Register", onTap: (){
                    var fullName = _fullName.text;
                    var email = _emailController.text;
                    var pass = _passWordController.text;
                    var phone = _phone.text;
                    var address = _address.text;
                    var confirmPassword = _confirmPassWordController.text;
                    if(fullName.isEmpty){
                      Fluttertoast.showToast(msg: 'Full name must not be empty');
                      return;
                    }
                    if(email.isEmpty){
                      Fluttertoast.showToast(msg: 'Email must not be empty');
                      return;
                    }
                    if(phone.isEmpty){
                      Fluttertoast.showToast(msg: 'Phone must not be empty');
                      return;
                    }
                    if(address.isEmpty){
                      Fluttertoast.showToast(msg: 'Address must not be empty');
                      return;
                    }
                    if(pass.isEmpty){
                      Fluttertoast.showToast(msg: 'Password must not be empty');
                      return;
                    }
                    if(confirmPassword.isEmpty){
                      Fluttertoast.showToast(msg: 'Confirm password must not be empty');
                      return;
                    }
                    if(pass != confirmPassword){
                      Fluttertoast.showToast(msg: 'Passwords do not match');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    BlocProvider.of<AppBloc>(context).add(RegisterEvent(email, pass));

                  }, isLoading: isLoading,),
                  const SizedBox(height: 40,),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Already have an account?",
                          style: Utils.getMedium().copyWith(fontSize: 17),),
                        const SizedBox(width: 10,),
                        Text("Login",
                          style: Utils.getMedium().copyWith(fontSize: 19,color: Colors.blue),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
