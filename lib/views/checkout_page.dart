import 'package:car_shop/auth/product_service.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/components/custom_container.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(ProductService(), StoreHelper()),
      child: Builder(
        builder: (context){
          WidgetsBinding.instance.addPostFrameCallback((_){
            context.read<ProductBloc>().add(GetCartItemsEvent());
          });
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Receipt',style: Utils.getBold().copyWith(fontSize: 30),),
                    const Divider(),
                    const SizedBox(height: 50,),
                    BlocBuilder<ProductBloc,AppState>(
                      builder: (context,state){
                        if(state is GetCartItemsState){
                          var data = state.data;
                          return Text(getReceipt(data),style: Utils.getMedium().copyWith(fontSize: 15),);
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(height: 50,),
                    CustomContainer(text: "Finsih Order", isLoading: false, onTap: (){

                      context.read<ProductBloc>().add(GetDeleteCartEvent());
                      Get.offNamed(AppRouting.homePage);

                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
    receipt.writeln();
    receipt.write("Thank you for shopping with us");

    return receipt.toString();


  }
}
