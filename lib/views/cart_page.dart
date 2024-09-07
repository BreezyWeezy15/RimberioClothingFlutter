import 'package:drift/drift.dart' as d;
import 'package:car_shop/json/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:car_shop/auth/product_service.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Trans;

import '../db/store_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(ProductService(), StoreHelper()),
      child: BlocListener<ProductBloc, AppState>(
        listener: (context, state) {
          if (state is GetDeleteCartState) {
            var result = state.result;
            if (result == 1) {
              BlocProvider.of<ProductBloc>(context).add(GetCartItemsEvent());
              Fluttertoast.showToast(msg: 'Cart successfully deleted');
            } else {
              Fluttertoast.showToast(msg: 'Failed to delete cart');
            }
          } else if (state is GetDeleteCartItemState) {
            var result = state.result;
            if (result == 1) {
              BlocProvider.of<ProductBloc>(context).add(GetCartItemsEvent());
              Fluttertoast.showToast(msg: 'Cart Item successfully deleted');
            } else {
              Fluttertoast.showToast(msg: 'Failed to delete cart item');
            }
          }
        },
        child: Builder(
          builder: (context){
            WidgetsBinding.instance.addPostFrameCallback((_){
              context.read<ProductBloc>().add(GetCartItemsEvent());
              context.read<ProductBloc>().add(GetTotalPriceEvent());
            });
            return SafeArea(
              child: Scaffold(
                body: BlocBuilder<ProductBloc, AppState>(
                  buildWhen: (context,state){
                    return state is GetCartItemsState;
                  },
                  builder: (context, state) {
                    if (state is LOADING) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (state is ERROR) {
                      return Center(
                        child: Text(
                          'No Items In Cart',
                          style: Utils.getBold().copyWith(fontSize: 25),
                        ),
                      );
                    }
                    else if (state is GetCartItemsState) {
                      List<StoreData> list = state.data;
                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            'No Items In Cart',
                            style: Utils.getBold().copyWith(fontSize: 25),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.cart.tr(),
                                    style: Utils.getBold().copyWith(fontSize: 20),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteCartDialog(context);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              const Divider(),
                              _buildListView(context, list),
                              const Divider(),
                              Row(
                                children: [
                                  BlocBuilder<ProductBloc, AppState>(
                                    buildWhen: (context,state){
                                      return state is GetTotalPriceState;
                                    },
                                    builder: (context,state){
                                      var totalPrice = (state as GetTotalPriceState).totalPrice;
                                      return  Text(
                                        '${LocaleKeys.due.tr()} : $totalPrice',
                                        style: Utils.getBold().copyWith(fontSize: 20),
                                      );
                                    },
                                  ),
                                  const Spacer(),
                                  Text(
                                    LocaleKeys.checkout.tr(),
                                    style: Utils.getBold().copyWith(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Center(
                      child: Text(
                        'No Items In Cart',
                        style: Utils.getBold().copyWith(fontSize: 25),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteCartDialog(BuildContext context) {
    final productBloc = context.read<ProductBloc>(); // Get the ProductBloc

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_forever_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Do you want to delete cart?',
                style: Utils.getBold().copyWith(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        try {
                          productBloc.add(GetDeleteCartEvent());
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error dispatching event: $e');
                          // Optionally show an error message to the user
                        }
                      },
                      child: Text('Yes', style: Utils.getBold()),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No', style: Utils.getBold()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, List<StoreData> list) {

    var productBloc =  context.read<ProductBloc>();

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              productBloc.add(GetDeleteCartItemEvent(list[index].id));
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Image.network(
                    list[index].image!,
                    width: 90,
                    height: 90,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index].title!,
                          style: Utils.getBold().copyWith(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Category : ${list[index].category!.capitalize!}',
                          style: Utils.getMedium().copyWith(fontSize: 15),
                        ),
                        Text(
                          'Quantity : ${list[index].quantity}',
                          style: Utils.getMedium().copyWith(fontSize: 15),
                        ),
                        Text(
                          'Unit: \$${list[index].price}',
                          style: Utils.getMedium().copyWith(fontSize: 15, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            StoreCompanion? companion;
                            setState(() {
                              var quantity = list[index].quantity! + 1;
                              var totalPrice = list[index].price!  * quantity;


                               companion = StoreCompanion(
                                   id: d.Value(list[index].id),
                                  title: d.Value(list[index].title),
                                  category: d.Value(list[index].category),
                                  price: d.Value(list[index].price),
                                  totalPrice: d.Value(totalPrice),
                                  image: d.Value(list[index].image),
                                  quantity: d.Value(quantity),
                                  description: d.Value(list[index].description),
                                  color: d.Value(list[index].color)
                              );
                            });
                            context.read<ProductBloc>().add(GetUpdateCartEvent(companion!));
                            context.read<ProductBloc>().add(GetTotalPriceEvent());
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green
                            ),
                            child: const Icon(Icons.add,color: Colors.white,size: 15,),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(list[index].quantity.toString(),style: Utils.getBold().copyWith(fontSize: 18),),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){

                            StoreCompanion? companion;

                            if(list[index].quantity! > 1){

                              setState(() {

                                var quantity = list[index].quantity! - 1;
                                var totalPrice = list[index].price!  * quantity;

                                print("total " + totalPrice.toString());

                                companion = StoreCompanion(
                                    id: d.Value(list[index].id),
                                    title: d.Value(list[index].title),
                                    category: d.Value(list[index].category),
                                    price: d.Value(list[index].price),
                                    totalPrice: d.Value(totalPrice),
                                    image: d.Value(list[index].image),
                                    quantity: d.Value(quantity),
                                    description: d.Value(list[index].description),
                                    color: d.Value(list[index].color)
                                );
                              });
                            }
                            context.read<ProductBloc>().add(GetUpdateCartEvent(companion!));
                            context.read<ProductBloc>().add(GetTotalPriceEvent());
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green
                            ),
                            child: const Icon(Icons.remove,color: Colors.white,size: 15,),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
