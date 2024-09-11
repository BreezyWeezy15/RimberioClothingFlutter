import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/components/custom_container.dart';
import 'package:car_shop/components/custom_edit.dart';
import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocProvider(
            create: (BuildContext context) => AppBloc(),
            child: Builder(
              builder: (context){

                WidgetsBinding.instance.addPostFrameCallback((_){
                  context.read<AppBloc>().add(UserInfoEvent());
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile Information",style: Utils.getBold().copyWith(fontSize: 18),),
                    const Divider(),
                    Expanded(child: BlocBuilder<AppBloc,AppState>(
                      builder: (context,state){
                        if(state is LOADING){
                          return const Center(
                            child: SpinKitFadingCube(size: 50,color: Colors.blue,),
                          );
                        }
                        else if (state is ERROR){
                          return const Center(
                            child: SpinKitFadingCube(size: 50,color: Colors.blue,),
                          );
                        }
                        else if (state is UserInfoState){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50,),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                        image: NetworkImage(state.userModel!.profileUrl)
                                    )
                                ),
                              ),
                              const SizedBox(height: 50,),
                              CustomEdit(hint: state.userModel!.fullName, textEditingController: _fullNameController, iconData: Icons.person),
                              const SizedBox(height: 15,),
                              CustomEdit(hint: state.userModel!.email, textEditingController: _emailController, iconData: Icons.email),
                              const SizedBox(height: 15,),
                              CustomEdit(hint: state.userModel!.phone, textEditingController: _phoneController, iconData: Icons.phone),
                              const SizedBox(height: 15,),
                              CustomContainer(text: "Edit", isLoading: isLoading, onTap: (){})
                            ],
                          );
                        }
                        else {
                          return const Center(
                            child: SpinKitFadingCube(size: 50,color: Colors.blue,),
                          );
                        }
                      },
                    ))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

