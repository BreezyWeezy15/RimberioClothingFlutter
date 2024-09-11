
import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/components/custom_container.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/others/fcm_helper.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final FcmHelper _fcmHelper = FcmHelper();
  var totalPrice = 0.0;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
       BlocProvider(create: (_) => ProductBloc()),
       BlocProvider(create: (_) => AppBloc())
    ],
        child: Builder(
      builder: (context){
        WidgetsBinding.instance.addPostFrameCallback((_){
          context.read<ProductBloc>().add(GetCartItemsEvent());
          context.read<ProductBloc>().add(GetTotalPriceEvent());
        });
        return MultiBlocListener(
          listeners: [
            BlocListener<ProductBloc, AppState>(
              listener: (context, state) {
                if (state is GetTotalPriceState) {
                  totalPrice = state.totalPrice;
                }
              },
            ),
            BlocListener<AppBloc, AppState>(
              listener: (context, state) {
                if (state is GetUploadInvoiceState) {
                  bool isSuccess = state.isSuccess;
                  if (isSuccess) {
                    _sendFcmNotification();
                    Fluttertoast.showToast(msg: 'All Done.');
                    context.read<ProductBloc>().add(GetDeleteCartEvent());
                    Get.offNamed(AppRouting.homePage);
                  }
                  else {

                    Fluttertoast.showToast(msg: 'Failed to upload invoice${state.error}');
                  }

                  setState(() {
                    isLoading = true;
                  });
                }
              },
            ),
          ],
          child: SafeArea(
            child: Scaffold(
              body: BlocBuilder<ProductBloc, AppState>(
                buildWhen: (context,state){
                  return state is GetCartItemsState;
                },
                builder: (context, state) {
                  if (state is LOADING) {
                    return const Center(
                      child: SpinKitFadingCube(color: Colors.red, size: 25),
                    );
                  }
                  else if (state is GetCartItemsState) {
                    var data = state.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(child: Column(
                            children: [
                              Text(
                                'Receipt',
                                style: Utils.getBold().copyWith(fontSize: 30),
                              ),
                              const Divider(),
                              const SizedBox(height: 50),
                              Text(
                                getReceipt(data),
                                style: Utils.getMedium().copyWith(fontSize: 15),
                              ),
                              const SizedBox(height: 50)
                            ],
                          )),
                          CustomContainer(
                            text: "Finish Order",
                            isLoading: false,
                            onTap: () {

                              setState(() {
                                isLoading = true;
                              });

                              context.read<AppBloc>().add(GetUploadInvoiceEvent(data, totalPrice.toString()));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: Text('No items in cart'),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    ));
  }

  String getReceipt(List<StoreData> data){
    final receipt = StringBuffer();
    receipt.write('#Order Details');
    receipt.writeln();
    receipt.writeln('----------------');

    /// DATE
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    receipt.writeln('#Ordered At : ');
    receipt.write(formattedDate);
    receipt.writeln();

    receipt.writeln('----------------');

    receipt.writeln('#Personal Info / Address ');
    receipt.writeln();


    // Full Name
    receipt.write(StorageHelper.getShippingInfo()['fullName']);
    receipt.writeln();

    // email
    receipt.write(StorageHelper.getShippingInfo()['email']);
    receipt.writeln();

    // phone
    receipt.write(StorageHelper.getShippingInfo()['phone']);
    receipt.writeln();

    /// full address

    receipt.write(StorageHelper.getShippingInfo()['address']);
    receipt.writeln();


    receipt.writeln();
    receipt.writeln('----------------');
    receipt.writeln('#Items');
    receipt.writeln();

    // Ordered Food
    for (var data in data) {
      receipt.writeln('x${data.quantity} ${data.title}');
    }


    receipt.writeln();
    receipt.writeln('----------------');
    receipt.writeln('#TotalPrice $totalPrice');
    receipt.writeln();


    receipt.write("Thank you for shopping with us");

    return receipt.toString();


  }
  _sendFcmNotification() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if(kDebugMode){
      print(token);
    }

   bool isSuccess = await _fcmHelper.sendPushMessage(recipientToken: token!, title: "shopping",
        body: "Your order has been received,Thank you for shopping");

   if(isSuccess){
     Fluttertoast.showToast(msg: "Fcm successfully sent");
   } else {
     Fluttertoast.showToast(msg: 'Failed to send fcm');
   }

  }


}
