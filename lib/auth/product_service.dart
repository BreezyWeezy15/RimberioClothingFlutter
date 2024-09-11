import '../models/product.dart';
import 'dart:convert';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class ProductService {

  ProductService._privateConstructor();
  static ProductService instance = ProductService._privateConstructor();

  Future<List<Product>?> getProducts(String productCategory) async {

    final HttpWithMiddleware httpClient = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await httpClient.get(Uri.parse("https://fakestoreapi.com/products/category/$productCategory"));
    if(response.statusCode == 200){
      var decodedJson = jsonDecode(response.body) as List<dynamic>;
      return decodedJson.map((e) => Product.fromJson(e)).toList();
    } else {
      return null;
    }
  }
  Future<Product?> getProduct(int productId) async {

    final HttpWithMiddleware httpClient = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);


    var response = await httpClient.get(Uri.parse("https://fakestoreapi.com/products/$productId"));
    if(response.statusCode == 200){
      var decodedJson = jsonDecode(response.body);
      return Product.fromJson(decodedJson);
    } else {
      return null;
    }
  }

}
