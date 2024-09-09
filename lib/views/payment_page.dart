import 'package:car_shop/components/custom_container.dart';
import 'package:car_shop/components/custom_edit.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/payment/stripe_payment_helper.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;
  var paymentMethod = "Stripe";
  var total = 0.0;
  late StripePaymentHelper _stripePaymentHelper;
  @override
  void initState() {
    super.initState();
    _stripePaymentHelper = StripePaymentHelper();
    total = Get.arguments['due'];
    paymentMethod = StorageHelper.getPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Payment",style: Utils.getBold().copyWith(fontSize: 25),),
              const Divider(),
              const SizedBox(height: 20,),
              CustomEdit(hint: 'Full Name', textEditingController: _fullNameController, iconData: Icons.person),
              const SizedBox(height: 5,),
              CustomEdit(hint: 'Email', textEditingController: _emailController, iconData: Icons.email),
              const SizedBox(height: 5,),
              CustomEdit(hint: 'Phone', textEditingController: _phoneController, iconData: Icons.phone),
              const SizedBox(height: 5,),
              CustomEdit(hint: 'Address', textEditingController: _addressController, iconData: Icons.location_on_outlined),
              const SizedBox(height: 30,),
              CustomContainer(text: 'Pay Now', isLoading: isLoading, onTap: () async {

                _fullNameController.text  = "Taki Eddine";
                _emailController.text = "Algeriahero22@gmail.com";
                _phoneController.text = "+213777309438";
                _addressController.text = "Rue de la remonte 150 / 93";

                var fullName = _fullNameController.text.toString();
                var email = _emailController.text.toString();
                var phone = _phoneController.text.toString();
                var address = _addressController.text.toString();

                if(fullName.isEmpty){
                  Fluttertoast.showToast(msg: 'Full Name cannot be empty');
                  return;
                }

                if(email.isEmpty){
                  Fluttertoast.showToast(msg: 'Email cannot be empty');
                  return;
                }

                if(phone.isEmpty){
                  Fluttertoast.showToast(msg: 'Phone cannot be empty');
                  return;
                }

                if(address.isEmpty){
                  Fluttertoast.showToast(msg: 'Address cannot be empty');
                  return;
                }


                Map<String,dynamic> info = {
                "fullName" : fullName,
                "email" : email,
                "phone" : phone,
                "address" : address,
                };
                StorageHelper.addShippingInfo(info);


                setState(() {
                  isLoading = true;
                });

                await _stripePaymentHelper.makePayment(total, fullName, email, phone, address);

                setState(() {
                isLoading = false;
                });
              })

            ],
          ),
        ),
      ),
    );
  }
}
