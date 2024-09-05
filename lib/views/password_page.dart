import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/custom_container.dart';
import '../components/custom_edit.dart';
import '../others/utils.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc,AppState>(
      listener: (context,state){
        if(state is ResetState){
          bool isSuccess = state.isSuccess;
          if(isSuccess){
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Please check your inbox for a resetting email');
            _emailController.clear();
          } else {
            setState(() {isLoading = false;});
            Fluttertoast.showToast(msg: 'Failed to send a resetting email');
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
                  Text('Login to your account',style: Utils.getMedium().copyWith(fontSize: 30),),
                  const SizedBox(height: 20,),
                  Text('Email',style: Utils.getMedium().copyWith(fontSize: 20),),
                  CustomEdit(hint: "Email", textEditingController: _emailController, iconData: Icons.email, isPass: false),
                  const SizedBox(height: 20,),
                  CustomContainer(text: "Reset", onTap: (){

                    var email = _emailController.text;

                    if(email.isEmpty){
                      Fluttertoast.showToast(msg: 'Email must not be empty');
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    BlocProvider.of<AppBloc>(context).add(ResetEvent(email));

                  }, isLoading: isLoading,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
