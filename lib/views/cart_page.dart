import 'dart:io';

import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../db/store_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetCartItemsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc,AppState>(
      listener: (context,state){
        if(state is GetDeleteCartState){
          var int = state.result;
          if(int == 1){
            BlocProvider.of<ProductBloc>(context).add(GetCartItemsEvent());
            Fluttertoast.showToast(msg: 'Cart successfully deleted');
          } else {
            Fluttertoast.showToast(msg: 'Failed to delete cart');
          }
        }
        else if (state is GetDeleteCartItemState){
          var int = state.result;
          if(int == 1){
            BlocProvider.of<ProductBloc>(context).add(GetCartItemsEvent());
            Fluttertoast.showToast(msg: 'Cart Item successfully deleted');
          } else {
            Fluttertoast.showToast(msg: 'Failed to delete cart item');
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ProductBloc,AppState>(
            builder: (context,state){
              if(state is LOADING){
                return const Center(child: CircularProgressIndicator());
              }
              else if (state is ERROR){
                return Center(child: Text('No Items In Cart',
                  style: Utils.getBold().copyWith(fontSize: 25),),);
              }
              else if (state is GetCartItemsState){
                List<StoreData> list = state.data;
                if(list.isEmpty){
                  return Center(child: Text('No Items In Cart',
                    style: Utils.getBold().copyWith(fontSize: 25),),);
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Cart',style: Utils.getBold().copyWith(fontSize: 20),),
                            const Spacer(),
                            IconButton(onPressed: (){

                              // delete
                              showDialog(
                                  context : context,
                                  builder: (context){
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue
                                            ),
                                            child: const Center(child: Icon(Icons.delete_forever_outlined,size: 40,color: Colors.white,)),
                                          ),
                                          const SizedBox(height: 20,),
                                          Text('Do you want to delete cart?',style: Utils.getBold().copyWith(fontSize: 25),
                                            textAlign: TextAlign.center,),
                                          const SizedBox(height: 20,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 40,right: 40),
                                            child: Row(
                                              children: [
                                                ElevatedButton(onPressed: (){

                                                  BlocProvider.of<ProductBloc>(context).add(GetDeleteCartEvent());
                                                  Navigator.pop(context);
                                                }, child:  Text('Yes',
                                                  style: Utils.getBold(),)),
                                                const Spacer(),
                                                ElevatedButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, child: Text('No',
                                                  style: Utils.getBold(),))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });

                            }, icon: const Icon(Icons.delete))
                          ],
                        ),
                        const Divider(),
                        _buildListView(context, list),
                        const Divider(),
                        Row(
                          children: [
                            Text('Due :',style: Utils.getBold().copyWith(fontSize: 20),),
                            const Spacer(),
                            Text('Checkout',style: Utils.getBold().copyWith(fontSize: 20),)
                          ],
                        )
                      ],
                    ),
                  );
                }
              }
              return Center(child: Text('No Items In Cart',
                style: Utils.getBold().copyWith(fontSize: 25),),);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context,List<StoreData> list){
    return Expanded(child: ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context,index){
        return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction){
              BlocProvider.of<ProductBloc>(context).add(GetDeleteCartItemEvent(list[index].id));
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Image.network(list[index].image!,width: 90,height: 90,),
                  const SizedBox(width: 10,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list[index].title!,style: Utils.getBold().copyWith(fontSize: 16),maxLines: 2,
                        overflow: TextOverflow.ellipsis,),
                      Text('Category : ${list[index].category!.capitalize!}',style: Utils.getMedium().copyWith(fontSize: 15),),
                      Text('Quantity : ${list[index].quantity}', style: Utils.getMedium().copyWith(fontSize: 15),),
                      Text('Unit: \$${list[index].price}', style: Utils.getMedium().copyWith(fontSize: 15,
                          color: Colors.blue),),
                    ],
                  ))
                ],
              ),
            ));
      },
    ));
  }
}
