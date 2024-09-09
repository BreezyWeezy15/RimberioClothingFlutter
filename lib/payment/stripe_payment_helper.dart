
import 'dart:convert';

import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/others/theme_helper.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class StripePaymentHelper {

  late Map<String, dynamic>? _paymentIntent;

  // create payment
  Future<void> makePayment(double total,String fullName,String email,String phone,
      String address) async {

    try {

      // create payment intent
      _paymentIntent = await _createPaymentIntent(total);

      // initialize payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: BillingDetails(
                email: email,
                address: Address(
                    city: '',
                    country: '',
                    line1: address,
                    line2: '',
                    postalCode: '',
                    state: ''),
                phone: phone,
                name: fullName
              ),
              paymentIntentClientSecret: _paymentIntent!['client_secret'],
            style: ThemeHelper.getTheme(),
            merchantDisplayName: "Taki Eddine Gastalli"
          ));

      _displayPaymentSheet();

    } catch(e){
      print("Error making payment : $e");
    }

  }

  Future<Map<String, dynamic>?> _createPaymentIntent(double total) async {
      try {

        var paymentMap = <String,dynamic>{
           'amount' : _calculateAmount(total),
           'currency' : 'USD'
        };

        print(dotenv.env['STRIPE_URL']);
        var response = await http.post(
           Uri.parse(dotenv.env['STRIPE_URL'] ?? ''),
            headers: {
              'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']!}',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
           body: paymentMap
        );

        return jsonDecode(response.body);

      } catch(err){
        throw Exception(err.toString());
      }
  }

  _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {

        //Clear paymentIntent variable after successful payment
        _paymentIntent = null;
        Get.toNamed(AppRouting.checkOutPage);

      })
          .onError((error, stackTrace) {
        throw Exception(error);
      });
    }
    on StripeException catch (e) {
      print('Error is:---> $e');
    }
    catch (e) {
      print('$e');
    }
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }

}
