import 'dart:ffi';

import 'package:car_shop/routes/app_routing.dart';
import 'package:drift/drift.dart' as d;
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  double totalPrice = 0.0;
  int quantity = 0;
  int colorIndex = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent(Get.arguments["productID"]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc,AppState>(
      listener: (context,state){
        if(state is GetSaveCartState){
          var int = state.result;
          if(int >= 1){
            setState(() {
              totalPrice = 0.0;
              quantity = 0;
              colorIndex = 0;
            });
            Fluttertoast.showToast(msg: 'Item added successfully');
            Get.toNamed(AppRouting.cartPage);
          } else {
            Fluttertoast.showToast(msg: 'Failed to add item');
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ProductBloc,AppState>(
            builder: (context,state){
              if(state is LOADING){
                return const Center(child: SpinKitFadingCube(color: Colors.blue,size: 40),);
              }
              else if (state is ERROR){
                return const Center(child: SpinKitFadingCube(color: Colors.blue,size: 40,),);
              }
              else if (state is GetProductState){
                Product? product = state.product;
                return Stack(
                  children: [
                    Column(
                      children: [
                        Image.network(product!.image,width: MediaQuery.of(context).size.width,
                          height: 300,fit: BoxFit.contain,filterQuality: FilterQuality.high,),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.category.capitalize!,style: Utils.getMedium().copyWith(fontSize: 22,
                                  color: Colors.black54),),
                              const SizedBox(height: 10,),
                              Text(product.title,style: Utils.getBold().copyWith(fontSize: 20),),
                              const SizedBox(height: 10,),
                              Text("Unit : \$${product.price}",style: Utils.getMedium().copyWith(fontSize: 20,
                                  color: Colors.blue),),
                              const SizedBox(height: 20,),
                              Row(
                                children: List.generate(Utils.colors.length, (index) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        colorIndex = index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(int.parse(Utils.colors[index]))
                                      ),
                                      child: Center(child: colorIndex == index ? const Icon(Icons.check,color: Colors.white,size: 25) :
                                      Container()),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20,),
                              Text('Product Info',style: Utils.getBold().copyWith(fontSize: 20),),
                              const SizedBox(height: 20,),
                              Text(product.description,style: Utils.getMedium().copyWith(fontSize: 16),)
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        child: Row(
                          children: [
                            IconButton(onPressed: (){

                              setState(() {
                                quantity++;
                                totalPrice = totalPrice * quantity;
                              });

                            }, icon: const Icon(Icons.add,size: 30,color: Colors.white,)),
                            Text(quantity.toString(),style: Utils.getBold().copyWith(fontSize: 25,color: Colors.white),),
                            IconButton(onPressed: (){

                              if(quantity > 0){
                                setState(() {
                                  quantity--;
                                  totalPrice = totalPrice * quantity;
                                });
                              }

                            }, icon: const Icon(Icons.remove,size: 30,color: Colors.white,)),
                            const Spacer(),
                            GestureDetector(
                              onTap: (){

                                if(quantity <= 0){
                                  Fluttertoast.showToast(msg: "Quantity must be bigger than 0");
                                  return;
                                }

                                // add data to database
                                StoreCompanion companion = StoreCompanion(
                                    title: d.Value(product.title),
                                    category: d.Value(product.category),
                                    price: d.Value(product.price),
                                    totalPrice: d.Value(totalPrice),
                                    image: d.Value(product.image),
                                    quantity: d.Value(quantity),
                                    description: d.Value(product.description),
                                    color: d.Value(int.parse(Utils.colors[colorIndex]))
                                );
                                BlocProvider.of<ProductBloc>(context).add(GetSaveCartEvent(companion));

                              },
                              child: Text('Pay Now',style: Utils.getBold().copyWith(fontSize: 20,color: Colors.white),),
                            ),
                            const SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator(),);
            },
          ),
        ),
      ),
    );
  }
}
