

import 'package:car_shop/views/cart_page.dart';
import 'package:car_shop/views/checkout_page.dart';
import 'package:car_shop/views/details_page.dart';
import 'package:car_shop/views/home_page.dart';
import 'package:car_shop/views/intro_page.dart';
import 'package:car_shop/views/login_page.dart';
import 'package:car_shop/views/orders_page.dart';
import 'package:car_shop/views/password_page.dart';
import 'package:car_shop/views/payment_page.dart';
import 'package:car_shop/views/profile_page.dart';
import 'package:car_shop/views/register_page.dart';
import 'package:car_shop/views/settings_page.dart';
import 'package:car_shop/views/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRouting {

  static const String splashPage = "/splash";
  static const String introPage = "/intro";
  static const String loginPage = "/login";
  static const String registerPage = "/register";
  static const String resetPage = "/reset";
  static const String homePage = "/home";
  static const String detailsPage = "/details";
  static const String cartPage = "/cart";
  static const String settingsPage = "/settings";
  static const String paymentPage = "/page";
  static const String checkOutPage = "/checkout";
  static const String ordersPage = "/orders";
  static const String profilePage = "/profile";

  static List<GetPage> pages  = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(name: introPage, page: () => const IntroPage()),
    GetPage(name: loginPage, page: () => const LoginPage()),
    GetPage(name: registerPage, page: () => const RegisterPage()),
    GetPage(name: resetPage, page: () => const PasswordPage()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: detailsPage, page: () => const DetailsPage()),
    GetPage(name: cartPage, page: () => const CartPage()),
    GetPage(name: settingsPage, page: () => const SettingsPage()),
    GetPage(name: paymentPage, page: () => const PaymentPage()),
    GetPage(name: checkOutPage, page: () => const CheckoutPage()),
    GetPage(name: ordersPage, page: () => const OrdersPage()),
    GetPage(name: profilePage, page: () => const ProfilePage())
  ];

}
