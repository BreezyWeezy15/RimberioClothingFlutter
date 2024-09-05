

import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {


  static final List<String> titles = [
    "Electronics",
    "Jewelry",
    "Men's Clothing",
    "Women's Clothing"
  ];
  static final List<String> images = [
    "assets/images/jewelry.jpg",
    "assets/images/jewelry.jpg",
    "assets/images/jewelry.jpg",
    "assets/images/jewelry.jpg",
  ];
  static final List<String> descriptions = [
    "Discover the latest gadgets and tech essentials for your everyday needs.",
    "Explore stunning jewelry pieces that add a touch of elegance to any outfit.",
    "Shop stylish and comfortable clothing options tailored for the modern man.",
    "Find trendy and chic clothing designed to make every woman shine."
  ];

  static final List<String> colors = [
    "0xFF18dffc",
    "0xFFffc000",
    "0xFF15355a",
    "0xFFff10750",
    "0xFF151d26"
  ];


  static final List<String> banners = [
    "assets/images/banner1.png",
    "assets/images/banner2.png",
    "assets/images/banner3.png",
  ];

  static final List<String> categoriesNames = [
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing",
  ];

  static final List<String> categories = [
    "assets/images/electro.png",
    "assets/images/jewelry.png",
    "assets/images/men.png",
    "assets/images/women.png",
  ];

  static final List<String> languages = [
    'English',
    'French',
    'Spanish'
  ];

  static final List<String> flags = [
    "assets/images/english.png",
    "assets/images/french.png",
    "assets/images/spanish.png"
  ];

  static final List<String> payments = [
    "Stripe",
    "Paypal"
  ];

  static final List<String> paymentsLogos = [
    "assets/images/stripe.png",
    "assets/images/paypal.png"
  ];

  // Fonts
  static TextStyle getBold() {
    return GoogleFonts.podkova(fontWeight: FontWeight.bold);
  }

  static TextStyle getMedium() {
    return GoogleFonts.podkova(fontWeight: FontWeight.w500);
  }

}
