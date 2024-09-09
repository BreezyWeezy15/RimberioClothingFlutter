// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "categories": "Categories",
  "settings": "Settings",
  "theme": "Theme",
  "language": "Language",
  "paymentMethod": "Payment Method",
  "feedback": "Feedback",
  "productInfo": "ProductInfo",
  "payNow": "Pay",
  "due": "Due",
  "checkout": "Checkout",
  "cart": "Cart",
  "electronics": "Electronics",
  "jewelry": "Jewelry",
  "menClothing": "Men's Clothing",
  "womenClothing": "Women's Clothing"
};
static const Map<String,dynamic> es = {
  "categories": "Categorías",
  "settings": "Configuración",
  "theme": "Tema",
  "language": "Idioma",
  "paymentMethod": "Método de Pago",
  "feedback": "Comentarios",
  "productInfo": "Información del Producto",
  "payNow": "Pagar",
  "due": "A Pagar",
  "checkout": "Pagar",
  "cart": "Carrito",
  "electronics": "Electrónica",
  "jewelry": "Joyería",
  "menClothing": "Ropa para Hombres",
  "womenClothing": "Ropa para Mujeres"
};
static const Map<String,dynamic> fr = {
  "categories": "Catégories",
  "settings": "Paramètres",
  "theme": "Thème",
  "language": "Langue",
  "paymentMethod": "Méthode de Paiement",
  "feedback": "Commentaires",
  "productInfo": "Informations sur le Produit",
  "payNow": "Payer",
  "due": "À Payer",
  "checkout": "Paiement",
  "cart": "Panier",
  "electronics": "Électronique",
  "jewelry": "Bijoux",
  "menClothing": "Vêtements pour Hommes",
  "womenClothing": "Vêtements pour Femmes"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "es": es, "fr": fr};
}
