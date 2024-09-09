

import 'package:car_shop/payment/paypal_payment_helper.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
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

  String? paymentMethod = "Stripe";
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  late PayPalPaymentHelper _payPalPaymentHelper;
  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    paymentMethod = StorageHelper.getPaymentMethod();
    _payPalPaymentHelper = PayPalPaymentHelper();
  }

  Future execute() async {

    accessToken = (await _payPalPaymentHelper.getAccessToken());

    try {

      final transactions = getOrderParams();
      final res = await _payPalPaymentHelper.createPaypalPayment(transactions, accessToken);
      if (res != null) {
        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });
      }

    } catch (ex) {
      print("Paypal error $ex");
    }
  }

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": "itemName",
        "quantity": "10",  // Quantity as a string
        "unit_price": "100.00",  // Use `unit_price` instead of `price`
        "currency": "USD"
      }
    ];

    // Checkout Invoice Specifics
    String totalAmount = '100.00';
    String subTotalAmount = '100.00';
    String shippingCost = '0.00';
    String shippingDiscountCost = "0.00";  // Positive value
    String userFirstName = 'john';
    String userLastName = 'smith';
    String addressCity = 'New York';
    String addressStreet = "123 Main St";
    String addressZipCode = '10001';
    String addressCountry = 'US';
    String addressState = 'NY';
    String addressPhoneNumber = '+1 223 6161 789';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": "USD",
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": shippingDiscountCost
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            "shipping_address": {
              "recipient_name": "$userFirstName $userLastName",
              "line1": addressStreet,
              "line2": "",
              "city": addressCity,
              "country_code": addressCountry,
              "postal_code": addressZipCode,
              "phone": addressPhoneNumber,
              "state": addressState
            }
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };

    return temp;
  }


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
                              BlocBuilder<ProductBloc,AppState>(
                                buildWhen: (context,state){
                                  return state is GetTotalPriceState;
                                },
                                builder: (context,state){
                                  var totalPrice = (state as GetTotalPriceState).totalPrice;
                                  return Row(
                                    children: [
                                      Text(
                                        '${LocaleKeys.due.tr()} : ${totalPrice.toStringAsFixed(2)}',
                                        style: Utils.getBold().copyWith(fontSize: 20),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                         print(paymentMethod);
                                         if(paymentMethod == "Stripe"){

                                           // stripe payment
                                           Fluttertoast.showToast(msg: "Called");
                                           Get.toNamed(AppRouting.paymentPage,arguments: { "due" : totalPrice });
                                         } else {

                                           await execute();
                                           if(checkoutUrl != null){
                                             // paypal payment
                                             Fluttertoast.showToast(msg: 'Success');
                                           } else {
                                             Fluttertoast.showToast(msg: 'Failed to make payment');
                                           }
                                         }
                                        },
                                        child: Text(
                                          LocaleKeys.checkout.tr(),
                                          style: Utils.getBold().copyWith(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                  Stack(
                    children: [
                      Image.network(
                        list[index].image!,
                        width: 90,
                        height: 90,
                      ),
                      Positioned(
                        right: 10,
                        child: Container(
                          width: 30,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(list[index].color!)
                          ),
                        ),
                      )
                    ],
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
