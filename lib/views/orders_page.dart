import 'dart:io';

import 'package:car_shop/auth/api_service.dart';
import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppBloc(AuthService()),
      child: Builder(
        builder: (context){

          WidgetsBinding.instance.addPostFrameCallback((_){
            context.read<AppBloc>().add(GetOrdersEvent());
          });

          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Orders",style: Utils.getBold().copyWith(fontSize: 25),),
                    const Divider(),
                    Expanded(child: BlocBuilder<AppBloc,AppState>(
                      builder: (context,state){
                        if(state is LOADING){
                          return const Center(
                            child: SpinKitFadingCube(color: Colors.indigo,size: 25),
                          );
                        }
                        else if (state is ERROR){
                          return  Center(
                            child: Text(state.error.toString()),
                          );
                        }
                        else if (state is GetInvoicesState){
                          var data = state.list;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context,index){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index].invoiceID),
                                  Text(data[index].paid),
                                  Text(data[index].totalPrice),
                                  const SizedBox(height: 10,),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data[index].data.length,
                                    itemBuilder: (context,itemIndex){

                                      var info = data[index].data[itemIndex];

                                      return Row(
                                        children: [
                                          Image.network(info.image,width: 120,height: 120,),
                                          Column(
                                            children: [
                                              Text(info.title),
                                              Text(info.category),
                                              Text(info.color.toString())
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                        else {
                          return const Center(
                            child: SpinKitFadingCube(color: Colors.indigo,size: 25),
                          );
                        }
                      },
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
