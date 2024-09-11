import 'dart:ffi';
import 'package:car_shop/json/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import '../models/product.dart';
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
import 'package:get/get.dart' hide Trans;

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(),
      child: BlocListener<ProductBloc,AppState>(
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
        child: Builder(
          builder: (context){
            WidgetsBinding.instance.addPostFrameCallback((_){
              BlocProvider.of<ProductBloc>(context).add(GetProductEvent(Get.arguments["productID"]));
            });
            return SafeArea(
              child: Scaffold(
                body: BlocBuilder<ProductBloc,AppState>(
                  buildWhen: (context,state){
                    return state is GetProductState;
                  },
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
                                child: SingleChildScrollView(
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
                                      const SizedBox(height: 10,),
                                      RatingBar.readOnly(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        maxRating: 5,  // Set the maximum rating to 100
                                        initialRating: product.rating.rate,  // Use the count from the API
                                        size: 40,  ),
                                      const SizedBox(height: 10,),
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
                                      Text(LocaleKeys.productInfo.tr(),style: Utils.getBold().copyWith(fontSize: 20),),
                                      const SizedBox(height: 20,),
                                      Text(product.description,style: Utils.getMedium().copyWith(fontSize: 16),),
                                      const SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          _buildPayment(context,product),
                        ],
                      );
                    }
                    return const Center(child: SpinKitFadingCube(color: Colors.blue,size: 40,),);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  _buildPayment(BuildContext context,Product product){
    return  Positioned(
      bottom: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){

                      setState(() {
                        quantity++;
                        totalPrice = product.price * quantity;
                      });

                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green
                      ),
                      child: const Center(child: Icon(Icons.add,size: 30,color: Colors.white,)),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Text(quantity.toString(),style: Utils.getBold().copyWith(fontSize: 25,color: Colors.black54),),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){

                      if(quantity > 0){
                        setState(() {
                          quantity--;
                          totalPrice = product.price * quantity;
                        });
                      }

                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green
                      ),
                      child: const Icon(Icons.remove,size: 30,color: Colors.white,),
                    ),
                  ),
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
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo
                      ),
                      child: Center(child: Text(LocaleKeys.payNow.tr(),style: Utils.getBold().copyWith(fontSize: 20,color: Colors.white),)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
